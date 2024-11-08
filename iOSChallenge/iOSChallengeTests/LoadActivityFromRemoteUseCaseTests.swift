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
    
    func makeSUT(url: URL) -> (HTTPClientSpy, ActivityLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteActivityLoader(url: url, client: client)
        
        return (client, sut)
    }

}

protocol ActivityLoader {
    typealias Result = Swift.Result<[Data], Error>
    
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
            
        })
    }
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
}

extension HTTPClientSpy {
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }
}

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
