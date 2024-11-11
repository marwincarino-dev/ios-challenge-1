//
//  RecapViewModelTests.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/11/24.
//

import XCTest
@testable import iOSChallenge

final class RecapViewModelTests: XCTestCase {

    
    func test_selectWrongAnswer_returnsIncorrectAnswer() {
        let correctAnswer = "correct answer"
        let wrongAnswer1 = "wrong answer 1"
        let wrongAnswer2 = "wrong answer 2"
        
        let sut = makeSUT(
            correctAnswer: correctAnswer,
            answers: [
                wrongAnswer1,
                wrongAnswer2,
                correctAnswer
            ]
        )
        
        sut.select(answer: wrongAnswer1)
        
        XCTAssertFalse(sut.hasCorrectAnswer)
    }
}

private extension RecapViewModelTests {
    func makeSUT(correctAnswer: String, answers: [String]) -> RecapViewModel {
        RecapViewModel(
            id: anyID(),
            eyebrow: "eyebrow",
            body: "Body",
            answers: answers.map({ RecapViewModel.Answer(id: anyID(), text: $0) }),
            correctAnswer: correctAnswer
        )
    }
}
