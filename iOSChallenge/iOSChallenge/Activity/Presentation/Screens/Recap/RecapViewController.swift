//
//  RecapViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class RecapViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var feedbackStackView: UIStackView!
    @IBOutlet var feedbackIndicatorView: UIView!
    @IBOutlet var feedbackLabel: UILabel!
    @IBOutlet var answersStackView: UIStackView!
    @IBOutlet var continueButton: UIButton!
    
    // MARK: - Properties
    
    var onSubmit: (() -> Void)?
    var viewModel: RecapViewModel!
    
    private var answerViews: [AnswerView] = []
    private var previousAnswerView: AnswerView?
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func onTapContinue(_ sender: Any) {
        submitWithSimulatedLoading()
    }
}

private extension RecapViewController {
    func setup() {
        bodyLabel.text = viewModel.body
        
        setupChoices()
        updateFeedbackView()
        setupActivityIndicator()
    }
    
    func setupChoices() {
        viewModel.answers.forEach { answer in
            let view = makeAnswerView(with: answer)
            answersStackView.addArrangedSubview(view)
        }
    }
    
    func makeAnswerView(with answer: RecapViewModel.Answer) -> UIView {
        let view = AnswerView.make()
        view.configure(text: answer.text)
        view.onTap = handleChoiceOnTap(answer: answer)
        
        answerViews.append(view)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 54.0)
        ])
        
        return view
    }
    
    func submit() {
        onSubmit?()
        
        viewModel.clearSelectedAnswer()
        clearChoiceViewSelection()
    }
    
    func submitWithSimulatedLoading() {
        Task { @MainActor in
            view.isUserInteractionEnabled = false
            showActivityIndicator()
            
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            hideActivityIndicator()
            view.isUserInteractionEnabled = true
            
            submit()
        }
    }

    func clearChoiceViewSelection() {
        answerViews.forEach { view in
            view.resetSelection()
        }
    }
    
    func updateFeedbackView(isCorrectAnswer: Bool? = nil) {
        feedbackStackView.isHidden = viewModel.selectedAnswer == nil
        
        guard !feedbackStackView.isHidden, let isCorrectAnswer else { return }
        
        feedbackIndicatorView.backgroundColor = isCorrectAnswer ? .systemGreen : .systemRed
        feedbackLabel.text = isCorrectAnswer ? correctAnswerText : wrongAnswerText
    }
    
    func updateContinueButton() {
        continueButton.isEnabled = viewModel.selectedAnswer != nil
    }

    func setupActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

private extension RecapViewController {
    func handleChoiceOnTap(answer: RecapViewModel.Answer) -> ((AnswerView) -> Void) {
        return { [weak self] answerView in
            guard let self else { return }
            
            previousAnswerView?.resetSelection()
            previousAnswerView = answerView
            
            self.viewModel.select(answer: answer)
            self.updateFeedbackView(isCorrectAnswer: viewModel.hasCorrectAnswer)
            self.updateContinueButton()
        }
    }
}

private extension RecapViewController {
    var correctAnswerText: String {
        "You're correct!"
    }
    
    var wrongAnswerText: String {
        "Try again"
    }
}
