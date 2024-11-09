//
//  MainViewModel.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

protocol MainViewModel {
    var item: ActivityContainer? { get }
    
    func loadActivityContainer() async throws
}

final class CommonMainViewModel: MainViewModel {
    private(set) var item: ActivityContainer?
    
    private let getActivityUseCase: GetActivityContainerUseCase
    
    init(getActivityUseCase: GetActivityContainerUseCase) {
        self.getActivityUseCase = getActivityUseCase
    }
    
    func loadActivityContainer() async throws{
        item = try await getActivityUseCase.load()
    }
}
