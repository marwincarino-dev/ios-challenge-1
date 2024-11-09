//
//  GetActivityContainerUseCase.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

protocol GetActivityContainerUseCase {
    func load() async throws -> ActivityContainer
}
