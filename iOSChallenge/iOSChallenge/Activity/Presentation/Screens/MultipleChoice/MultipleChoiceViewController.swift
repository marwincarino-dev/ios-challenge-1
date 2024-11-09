//
//  MultipleChoiceViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class MultipleChoiceViewController: UIViewController {
    var viewModel: MultipleChoiceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static func make() -> MultipleChoiceViewController {
        return UIStoryboard.multipleChoice.instantiateViewController(ofType: MultipleChoiceViewController.self)
    }
}

final class MultipleChoiceViewModel: ScreenViewModel {
    typealias Choice = (id: String, text: String, emoji: String)
  
    let id: String
    let question: String
    let allowsMultipleChoices: Bool
    let choices: [Choice]
    
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
}
