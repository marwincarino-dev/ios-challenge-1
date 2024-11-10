//
//  ActivityContainerRepository.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

protocol ActivityContainerRepository {
    func load() async throws -> ActivityContainer
}
