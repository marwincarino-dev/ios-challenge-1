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
    
    private(set) var selectedAnswer: String?
    
    private lazy var answerTexts: [String] = {
        answers.map({ $0.text })
    }()
    
    init(
        id: String,
        eyebrow: String,
        body: String,
        answers: [Answer],
        correctAnswer: String
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.body = body.formatBody()
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
    
    func select(answer: String) {
        if selectedAnswer == answer {
            selectedAnswer = nil
        } else {
            selectedAnswer = answer
        }
    }
    
    func clearSelectedAnswer() {
        selectedAnswer = nil
    }
}

extension RecapViewModel {
    var hasCorrectAnswer: Bool {
        guard let selectedAnswer,
              answerTexts.contains(selectedAnswer) else { return false }
        
        return selectedAnswer == correctAnswer
    }
    
    var answerPlaceholder: String {  selectedAnswer ?? String.blankPlaceholder }
}

extension RecapViewModel {
    struct Answer: Equatable {
        let id: String
        let text: String
    }
}
