//
//  LoadActivityFromLocalUseCaseTests.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/8/24.
//

import XCTest
@testable import iOSChallenge

final class LoadActivityFromLocalUseCaseTests: XCTestCase {
    func test_load_requestFromInvalidURLReturnsInvalidDataError() {
        let sut = makeSUT(url: anyURL())
        
        sut.load { [weak self] result in
            guard let _ = self  else { return }
            
            switch result {
            case .success(_):
                XCTFail("Expecting an error")
            case .failure(let error as LocalActivityLoader.Error):
                XCTAssertEqual(error, .invalidData)
            default:
                XCTFail("Expecting \(LocalActivityLoader.Error.invalidData) got \(result) instead")
            }
        }
    }
}

private extension LoadActivityFromLocalUseCaseTests {
    func makeSUT(url: URL) -> LocalActivityLoader {
        let sut = LocalActivityLoader(
            url: url,
            decoder: .localActivityDecoder
        )
        
        return sut
    }
    
    func getValidURL() -> URL {
        let url = Bundle.main.url(
            forResource: "activity-response-ios",
            withExtension: "json"
        )!
        
        return url
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
        if let data = try? Data(contentsOf: url) {
            if let decodedData = try? decoder.decode(ActivityContainer.self, from: data) {
                completion(.success(decodedData))
            } else {
                completion(.failure(Error.decoding))
            }
        } else {
            completion(.failure(Error.invalidData))
        }
    }
}

extension LocalActivityLoader {
    enum Error: Swift.Error {
        case decoding
        case invalidData
    }
}
