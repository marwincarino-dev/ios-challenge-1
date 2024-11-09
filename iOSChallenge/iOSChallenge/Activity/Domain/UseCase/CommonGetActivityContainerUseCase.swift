//
//  CommonGetActivityContainerUseCase.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

final class CommonGetActivityContainerUseCase: GetActivityContainerUseCase {
    private let repository: ActivityContainerRepository
    
    init(repository: ActivityContainerRepository) {
        self.repository = repository
    }
    
    func load() async throws -> ActivityContainer {
        try await repository.load()
    }
}
