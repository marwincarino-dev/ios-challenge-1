//
//  LoadActivityFromRemoteUseCaseTests.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/8/24.
//

import XCTest

final class LoadActivityFromRemoteUseCaseTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }
    
    func test_init_doesNotRequestDataFromURL() {
        let (client, _) = makeSUT(url: anyURL())
        
        XCTAssert(client.requestedURLs.isEmpty)
    }
    
    func test_loadOnce_requestsDataFromURLOnce() {
        let url = anyURL()
        let (client, sut) = makeSUT(url: url)
        
        sut.load(completion: { _ in })
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = anyURL()
        let (client, sut) = makeSUT(url: url)
        
        sut.load(completion: { _ in })
        sut.load(completion: { _ in })
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_returnsConnectivityErrorOnClientError() {
        let (client, sut) = makeSUT(url: anyURL())
        
        expect(
            sut,
            toCompleteWith: .failure(.connectivity),
            when: {
                client.complete(with: anyError(), at: 0)
            }
        )
    }
    
    func test_load_returnsInvalidDataOnNon200HTTPResponseStatusCode() {
        let (client, sut) = makeSUT(url: anyURL())
        let invalidStatusCodes = [199, 201, 400, 500]
        
        invalidStatusCodes.enumerated().forEach { (index, statusCode) in
            expect(
                sut,
                toCompleteWith: .failure(.invalidData),
                when: {
                    client.complete(with: statusCode, data: anyData([]), at: index)
                }
            )
        }
    }
}

private extension LoadActivityFromRemoteUseCaseTests {
    func makeSUT(url: URL) -> (HTTPClientSpy, RemoteActivityLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteActivityLoader(url: url, client: client)
        
        return (client, sut)
    }
    
    func expect(
        _ sut: RemoteActivityLoader,
        toCompleteWith expectedResult: ActivityLoader.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(
                    receivedData,
                    expectedData,
                    file: file,
                    line: line
                )
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(
                    receivedError,
                    expectedError,
                    file: file,
                    line: line
                )
                
            default:
                XCTFail(
                    "Expecting \(expectedResult) got \(receivedResult) instead",
                    file: file,
                    line: line
                )
            }
            
            exp.fulfill()
        }
        
        action()
        
        waitForExpectations(timeout: 0.1)
    }
}

protocol ActivityLoader {
    typealias Result = Swift.Result<[Data], RemoteActivityLoader.Error>
    
    func load(completion: @escaping (ActivityLoader.Result) -> Void)
}

final class RemoteActivityLoader: ActivityLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (ActivityLoader.Result) -> Void) {
        client.request(from: url, completion: { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case let .success((data, response)):
                guard response.statusCode == RemoteActivityLoader.OK_200 else {
                    completion(.failure(Error.invalidData))
                    return
                }
                
                completion(.success([data]))
                
                return
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        })
    }
}

extension RemoteActivityLoader {
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}

private extension RemoteActivityLoader {
    static let OK_200 = 200
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func request(from url: URL, completion: @escaping (Result) -> Void)
}

final class HTTPClientSpy: HTTPClient {
    /// Use to capture data for testing
    private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
    
    func request(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(
        with error: Error,
        at index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard messages.count > index else {
            return XCTFail("Invalid Index: Unable to complete request")
        }
        
        messages[index].completion(.failure(error))
    }
    
    func complete(
        with statusCode: Int,
        data: Data,
        at index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard messages.count > index else {
            return XCTFail("Invalid Index: Unable to complete request", file: file, line: line)
        }
        
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        
        messages[index].completion(.success((data, response)))
    }
}

extension HTTPClientSpy {
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyError() -> NSError {
    NSError(domain: "Test", code: 1)
}

func anyData(_ data: [[String: Any]]) -> Data {
    let json = ["data": data]
    return try! JSONSerialization.data(withJSONObject: json)
}
