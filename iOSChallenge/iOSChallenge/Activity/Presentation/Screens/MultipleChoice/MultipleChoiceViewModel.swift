//
//  MultipleChoiceViewModel.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

final class MultipleChoiceViewModel: ScreenViewModel {
    let id: String
    let question: String
    let allowsMultipleChoices: Bool
    let choices: [Choice]
    
    private(set) var selectedChoices: Set<Choice> = Set()
    
    init(
        id: String,
        question: String,
        allowsMultipleChoices: Bool,
        choices: [Choice]
    ) {
        self.id = id
        self.question = question
        self.allowsMultipleChoices = allowsMultipleChoices
        self.choices = choices
    }
    
    func select(choice: Choice) {
        guard canSelectChoices else { return }
        
        if selectedChoices.contains(choice) {
            selectedChoices.remove(choice)
        } else {
            selectedChoices.insert(choice)
        }
    }
    
    func clearSelectedChoices() {
        selectedChoices.removeAll()
    }
}

private extension MultipleChoiceViewModel {
    var canSelectChoices: Bool {
        if allowsMultipleChoices {
            return true
        } else {
            return selectedChoices.isEmpty
        }
    }
}

extension MultipleChoiceViewModel {
    struct Choice: Hashable {
        let id: String
        let text: String
        let emoji: String
    }
}
