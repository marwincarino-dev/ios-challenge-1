//
//  CommonActivityContainerRepository.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

final class CommonActivityContainerRepository: ActivityContainerRepository {
    private let primary: ActivityLoader
    private let secondary: ActivityLoader?
    
    init(primary: ActivityLoader, secondary: ActivityLoader? = nil) {
        self.primary = primary
        self.secondary = secondary
    }
}

extension CommonActivityContainerRepository {
    // TO DO: - Add `retry` capability
    func load() async throws -> ActivityContainer {
        return try await load(using: primary, with: secondary)
    }
}

private extension CommonActivityContainerRepository {
    func load(using primary: ActivityLoader, with fallback: ActivityLoader? = nil) async throws -> ActivityContainer {
        return try await withCheckedThrowingContinuation({ continuation in
            primary.load(completion: { [weak self] result in
                guard let _ = self else { return }
                
                switch result {
                case let .success(data):
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    if let fallback {
                        fallback.load(completion: { result in
                            switch result {
                            case let .success(data):
                                continuation.resume(returning: data)
                            case let .failure(error):
                                continuation.resume(throwing: error)
                            }
                        })
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            })
        })
    }
}
