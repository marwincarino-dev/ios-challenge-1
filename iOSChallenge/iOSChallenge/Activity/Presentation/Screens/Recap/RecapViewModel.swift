//
//  RecapViewModel.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

final class RecapViewModel: ScreenViewModel {
    let id: String
    let eyebrow: String
    let body: String
    let answers: [Answer]
    let correctAnswer: String
    
    private(set) var selectedAnswer: Answer?
    
    init(
        id: String,
        eyebrow: String,
        body: String,
        answers: [Answer],
        correctAnswer: String
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.body = body
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
    
    func select(answer: Answer) {
        if selectedAnswer == answer {
            selectedAnswer = nil
        } else {
            selectedAnswer = answer
        }
    }
    
    func clearSelectedAnswer() {
        selectedAnswer = nil
    }
    
    var hasCorrectAnswer: Bool {
        return selectedAnswer?.id == correctAnswer
    }
}

extension RecapViewModel {
    struct Answer: Equatable {
        let id: String
        let text: String
    }
}
