//
//  MultipleChoiceViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class MultipleChoiceViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var selectionTypeLabel: UILabel!
    @IBOutlet private var choicesStackView: UIStackView!
    @IBOutlet private var continueButton: UIButton!
   
    // MARK: - Properties
    
    var onSubmit: (() -> Void)?
    var viewModel: MultipleChoiceViewModel!
    
    private var choiceViews: [ChoiceView] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - IBActions
    
    @IBAction
    private func onTapContinue(_ sender: Any) {
        submitWithSimulatedLoading()
    }
}

private extension MultipleChoiceViewController {
    func setup() {
        questionLabel.text = viewModel.question
        
        selectionTypeLabel.isHidden = !viewModel.allowsMultipleChoices
        
        continueButton.isHidden = !viewModel.allowsMultipleChoices
        updateContinueButton()
        
        setupChoices()
        
        setupActivityIndicator()
    }
    
    func setupChoices() {
        viewModel.choices.forEach { choice in
            let view = makeChoiceView(with: choice)
            choicesStackView.addArrangedSubview(view)
        }
    }
    
    func makeChoiceView(with choice: MultipleChoiceViewModel.Choice) -> UIView {
        let view = ChoiceView.make()
        view.configure(emoji: choice.emoji, text: choice.text)
        view.onTap = handleChoiceOnTap(choice: choice)
        
        choiceViews.append(view)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 54.0)
        ])
        
        return view
    }
    
    func submit() {
        onSubmit?()
        
        if shouldClearSelection {
            viewModel.clearSelectedChoices()
            clearChoiceViewSelection()
        }
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
        choiceViews.forEach { view in
            view.resetSelection()
        }
    }
    
    func updateContinueButton() {
        guard !continueButton.isHidden else { return }
        
        continueButton.isEnabled = !viewModel.selectedChoices.isEmpty
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

private extension MultipleChoiceViewController {
    func handleChoiceOnTap(choice: MultipleChoiceViewModel.Choice) -> (() -> Void) {
        return { [weak self] in
            guard let self else { return }
            
            self.viewModel.select(choice: choice)
            self.updateContinueButton()
            
            if !self.viewModel.allowsMultipleChoices {
                submitWithSimulatedLoading()
            }
        }
    }
}

private extension MultipleChoiceViewController {
    var shouldClearSelection: Bool {
        !viewModel.allowsMultipleChoices
    }
}
