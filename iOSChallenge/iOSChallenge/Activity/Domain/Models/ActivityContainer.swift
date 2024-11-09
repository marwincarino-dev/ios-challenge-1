//
//  ActivityContainer.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

// MARK: - ActivityContainer

struct ActivityContainer: Codable, Equatable {
    let id: String
    let state: String
    let stateChangedAt: Date?
    let title: String
    let description: String
    let duration: String
    let activity: Activity
}

// MARK: - Activity

extension ActivityContainer {
    struct Activity: Codable, Equatable {
        let screens: [Screen]
    }
}

// MARK: - Screen

extension ActivityContainer.Activity {
    struct Screen: Codable, Equatable {
        let id: String
        let type: `Type`
        
        let question: String?
        let multipleChoicesAllowed: Bool?
        let choices: [Choice]?
        
        let eyebrow: String?
        let body: String?
        let answers: [Answer]?
        let correctAnswer: String?
    }
    
    enum `Type`: String, Codable {
        case multipleChoiceModuleScreen
        case recapModuleScreen
    }
}

extension ActivityContainer.Activity.Screen {
    // MARK: - Answer
    
    struct Answer: Codable, Equatable {
        let id: String
        let text: String
    }
    
    // MARK: - Choice
    
    struct Choice: Codable, Equatable {
        let id: String
        let text: String
        let emoji: String
    }
}
