//
//  LoadActivityFromRemoteUseCaseTests.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/8/24.
//

import XCTest
@testable import iOSChallenge

final class LoadActivityFromRemoteUseCaseTests: XCTestCase {
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
