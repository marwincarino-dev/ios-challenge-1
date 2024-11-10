//
//  MainViewModel.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

protocol MainViewModel {
    var screenViewModels: [ScreenViewModel] { get }
    
    func loadScreens() async throws
}
