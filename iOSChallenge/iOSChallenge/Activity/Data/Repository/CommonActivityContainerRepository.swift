//
//  CommonActivityContainerRepository.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

final class CommonActivityContainerRepository: ActivityContainerRepository {
    private let remote: ActivityLoader
    private let local: ActivityLoader?
    
    init(remote: ActivityLoader, local: ActivityLoader? = nil) {
        self.remote = remote
        self.local = local
    }
}

extension CommonActivityContainerRepository {
    func load() async throws -> ActivityContainer {
        return try await load(using: primary, with: secondary)
    }
}

private extension CommonActivityContainerRepository {
    func load(using primary: ActivityLoader, with fallback: ActivityLoader? = nil) async throws -> ActivityContainer {
        return try await withCheckedThrowingContinuation({ continuation in
            primary.load(completion: { [weak self] result in
                guard let self else { return }
                
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
                    }
                    
                    continuation.resume(throwing: error)
                }
            })
        })
    }
    
    var primary: ActivityLoader { remote }
    
    var secondary: ActivityLoader? { local }
}
