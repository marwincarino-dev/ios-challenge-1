//
//  HTTPClientSpy.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/8/24.
//

import XCTest
@testable import iOSChallenge

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
            return XCTFail("Invalid Index: Unable to complete request")
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
