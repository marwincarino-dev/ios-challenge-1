//
//  LoadActivityFromLocalUseCaseTests.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/8/24.
//

import XCTest
@testable import iOSChallenge

final class LoadActivityFromLocalUseCaseTests: XCTestCase {
    func test_load_requestFromInvalidFileURLReturnsInvalidFileURLError() {
        let sut = makeSUT(url: anyURL())
        
        expect(sut, toCompleteWith: .failure(.invalidFileURL))
    }
    
    func test_load_requestFromInvalidDataReturnsInvalidDataError() {
        let sut = makeSUT(url: LoadActivityFromLocalUseCaseTests.invalidActivityURL)
        
        expect(sut, toCompleteWith: .failure(.invalidData))
    }
}

private extension LoadActivityFromLocalUseCaseTests {
    func makeSUT(
        url: URL = activityURL,
        decoder: JSONDecoder = .localActivityDecoder
    ) -> LocalActivityLoader {
        let sut = LocalActivityLoader(
            url: url,
            decoder: decoder
        )
        
        return sut
    }
    
    func expect(
        _ sut: LocalActivityLoader,
        toCompleteWith expectedResult: Result<ActivityContainer, LocalActivityLoader.Error>,
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
                
            case let (.failure(receivedError as LocalActivityLoader.Error), .failure(expectedError)):
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
        
        waitForExpectations(timeout: 0.1)
    }
    
    static var activityURL: URL {
        Bundle.main.url(
            forResource: "activity-response-ios",
            withExtension: "json"
        )!
    }
    
    static var invalidActivityURL: URL {
        Bundle.main.url(
            forResource: "invalid-activity-response-ios",
            withExtension: "json"
        )!
    }
}

final class LocalActivityLoader: ActivityLoader {
    private let url: URL
    private let decoder: JSONDecoder
    
    init(url: URL, decoder: JSONDecoder = .localActivityDecoder) {
        self.url = url
        self.decoder = decoder
    }

    func load(completion: @escaping (ActivityLoader.Result) -> Void) {
        guard url.isFileURL else {
            completion(.failure(Error.invalidFileURL))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try decoder.decode(ActivityContainer.self, from: data)
            
            completion(.success(decodedData))
        } catch {
            completion(.failure(Error.invalidData))
        }
    }
}

extension LocalActivityLoader {
    enum Error: Swift.Error {
        case invalidData
        case invalidFileURL
    }
}
