//
//  LocalActivityContainer.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

struct LocalActivityContainer: Codable, Equatable {
    let id: String
    let state: String
    let stateChangedAt: Date?
    let title: String
    let description: String
    let duration: String
    let activity: Activity
}

extension LocalActivityContainer {
    struct Activity: Codable, Equatable {
        let screens: [Screen]
    }
}

extension LocalActivityContainer.Activity {
    struct Screen: Codable, Equatable {
        let id: String
        let type: String
        
        let question: String?
        let multipleChoicesAllowed: Bool?
        let choices: [Choice]?
        
        let eyebrow: String?
        let body: String?
        let answers: [Answer]?
        let correctAnswer: String?
    }
}

extension LocalActivityContainer.Activity.Screen {
    struct Answer: Codable, Equatable {
        let id: String
        let text: String
    }
    
    struct Choice: Codable, Equatable {
        let id: String
        let text: String
        let emoji: String
    }
}
