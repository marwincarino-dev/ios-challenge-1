//
//  CommonMainViewModel.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

final class CommonMainViewModel: MainViewModel {
    private var item: ActivityContainer?
    
    private let getActivityUseCase: GetActivityContainerUseCase
    
    init(getActivityUseCase: GetActivityContainerUseCase) {
        self.getActivityUseCase = getActivityUseCase
    }
    
    func loadScreens() async throws{
        item = try await getActivityUseCase.load()
    }
}

extension CommonMainViewModel {
    var screenViewModels: [ScreenViewModel] {
        item?.activity.screens.compactMap(
            { screen in
                switch screen.type {
                case .multipleChoiceModuleScreen:
                    let choices = screen.choices?.compactMap({
                        MultipleChoiceViewModel.Choice(id: $0.id, text: $0.text, emoji: $0.emoji)
                    })
                    
                    return  MultipleChoiceViewModel(
                        id: screen.id,
                        question: screen.question.unwrap(),
                        allowsMultipleChoices: screen.multipleChoicesAllowed ?? false,
                        choices: choices ?? []
                    )
                    
                case .recapModuleScreen:
                    let answers = screen.answers?.compactMap({
                        RecapViewModel.Answer(id: $0.id, text: $0.text)
                    })
                    
                    return RecapViewModel(
                        id: screen.id,
                        eyebrow: screen.eyebrow.unwrap(),
                        body: screen.body.unwrap(),
                        answers: answers ?? [],
                        correctAnswer: screen.correctAnswer.unwrap()
                    )
                }
            }
        ) ?? []
    }
}
