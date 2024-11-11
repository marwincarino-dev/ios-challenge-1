//
//  MultipleChoiceViewModelTests.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/11/24.
//

import XCTest
@testable import iOSChallenge

final class MultipleChoiceViewModelTests: XCTestCase {
    func test_selectingMultipleChoice_returnsSingleChoice_whenMultipleChoiceIsNotAllowed() {
        let choice1 = MultipleChoiceViewModel.Choice(id: anyID(), text: "choice 1", emoji: "")
        let choice2 = MultipleChoiceViewModel.Choice(id: anyID(), text: "choice 2", emoji: "")
        let choice3 = MultipleChoiceViewModel.Choice(id: anyID(), text: "choice 3", emoji: "")
        
        let sut = makeSUT(
            allowsMultipleChoices: false,
            choices: [
                choice1,
                choice2,
                choice3
            ]
        )
        
        sut.select(choice: choice1)
        sut.select(choice: choice2)
        
        XCTAssertEqual(sut.selectedChoices.count, 1)
    }
    
    func test_selectingMultipleChoice_returnsChoices_whenMultipleChoiceIsAllowed() {
        let choice1 = MultipleChoiceViewModel.Choice(id: anyID(), text: "choice 1", emoji: "")
        let choice2 = MultipleChoiceViewModel.Choice(id: anyID(), text: "choice 2", emoji: "")
        let choice3 = MultipleChoiceViewModel.Choice(id: anyID(), text: "choice 3", emoji: "")
        
        let sut = makeSUT(
            allowsMultipleChoices: true,
            choices: [
                choice1,
                choice2,
                choice3
            ]
        )
        
        sut.select(choice: choice1)
        sut.select(choice: choice2)
        
        XCTAssertEqual(sut.selectedChoices.count, 2)
    }
}

private extension MultipleChoiceViewModelTests {
    func makeSUT(allowsMultipleChoices: Bool, choices: [MultipleChoiceViewModel.Choice]) -> MultipleChoiceViewModel {
        MultipleChoiceViewModel(
            id: anyID(),
            question: "Question",
            allowsMultipleChoices: allowsMultipleChoices,
            choices: choices
        )
    }
}
