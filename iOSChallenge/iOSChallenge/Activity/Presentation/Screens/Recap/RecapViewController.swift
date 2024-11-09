//
//  RecapViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class RecapViewController: UIViewController {
    var viewModel: RecapViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension RecapViewController {
    static func make() -> RecapViewController {
        return UIStoryboard.recap.instantiateViewController(ofType: RecapViewController.self)
    }
}

final class RecapViewModel: ScreenViewModel {
    typealias Answer = (id: String, text: String)
   
    let id: String
    let eyebrow: String
    let body: String
    let answers: [Answer]
    let correctAnswer: String
    
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
}
