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
    
    @IBAction
    private func onTapContinue(_ sender: Any) {
        onSubmit?()
    }
    
    // MARK: - Properties
    
    var onSubmit: (() -> Void)?
    var viewModel: MultipleChoiceViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        questionLabel.text = viewModel.question
        
        selectionTypeLabel.isHidden = !viewModel.allowsMultipleChoices
        
        continueButton.isHidden = !viewModel.allowsMultipleChoices
        updateContinueButtonState()
        
        setupChoices()
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
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 54.0)
        ])
        
        return view
    }
    
    func updateContinueButtonState() {
        guard !continueButton.isHidden else { return }
        
        continueButton.isEnabled = !viewModel.selectedChoices.isEmpty
    }
}

private extension MultipleChoiceViewController {
    func handleChoiceOnTap(choice: MultipleChoiceViewModel.Choice) -> (() -> Void) {
        return { [weak self] in
            guard let self else { return }
            
            self.viewModel.select(choice: choice)
            self.updateContinueButtonState()
            
            if !self.viewModel.allowsMultipleChoices {
                self.onSubmit?()
            }
        }
    }
}

extension MultipleChoiceViewController {
    static func make() -> MultipleChoiceViewController {
        return UIStoryboard.multipleChoice.instantiateViewController(ofType: MultipleChoiceViewController.self)
    }
}
