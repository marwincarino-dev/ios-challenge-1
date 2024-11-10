//
//  RecapViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class RecapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var feedbackStackView: UIStackView!
    @IBOutlet var feedbackIndicatorView: UIView!
    @IBOutlet var feedbackLabel: UILabel!
    @IBOutlet var answersStackView: UIStackView!
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var bodyCollectionView: UICollectionView!
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
    
    var bodyCell: BodyCell?
    var placeholder = "%  RECAP  %"
    
    
    
    //
    
    
    func setupCollectionView() {
        collectionView.register(AnswerCell.nib(), forCellWithReuseIdentifier: AnswerCell.reuseIdentifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bodyCollectionView.frame.size.width, height: bodyCollectionView.frame.height) // Set your desired size
        bodyCollectionView.setCollectionViewLayout(layout, animated: true)
        bodyCollectionView.register(BodyCell.nib(), forCellWithReuseIdentifier: BodyCell.reuseIdentifier)
        bodyCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bodyCollectionView.dataSource = self
        bodyCollectionView.dropDelegate = self
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        // Define layout with flexible width cells
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Item size - Flexible width and automatic height
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(124), heightDimension: .absolute(48))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group - horizontal group that wraps to the next row if item width exceeds screen width
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            return section
        }
        
        return layout
    }
    
    
    //
}

// MARK: - UICollectionViewDataSource
extension RecapViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bodyCollectionView {
            return 1
        } else if collectionView == self.collectionView {
            return viewModel.answers.count
        }
        
        return 0
    }
    
    
     
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bodyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyCell.reuseIdentifier, for: indexPath) as? BodyCell else {
                return UICollectionViewCell()
            }
            
            cell.textView.text = viewModel.body
            bodyCell = cell
            
            return cell
        } else if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCell.reuseIdentifier, for: indexPath) as? AnswerCell else {
                return UICollectionViewCell()
            }

            cell.label.text = viewModel.answers[indexPath.row].text
            
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 4)
            cell.layer.shadowRadius = 5
            
            return cell
        }
        
        return UICollectionViewCell()
//
//        if indexPath.section == 0 {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodyCell.reuseIdentifier, for: indexPath) as? BodyCell else {
//                return UICollectionViewCell()
//            }
//            
//            cell.label.text = viewModel.body
//            
//            return cell
//            
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCell.reuseIdentifier, for: indexPath) as? AnswerCell else {
//                return UICollectionViewCell()
//            }
//
//            cell.label.text = viewModel.answers[indexPath.row].text
//            
//            cell.clipsToBounds = true
//            cell.layer.cornerRadius = 10.0
//            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = UIColor.lightGray.cgColor
//            cell.layer.shadowColor = UIColor.black.cgColor
//            cell.layer.shadowOpacity = 0.25
//            cell.layer.shadowOffset = CGSize(width: 0, height: 4)
//            cell.layer.shadowRadius = 5
//            
//            return cell
//        }
    }
}

// MARK: - UICollectionViewDragDelegate
extension RecapViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let text = viewModel.answers[indexPath.row].text
        
        let itemProvider = NSItemProvider(object: text as NSString)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = text
        
        return [dragItem]
    }
}


// MARK: - UICollectionViewDropDelegate
extension RecapViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("dropping")
        
        
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let draggedText = items.first as? String else { return }
            self.insertTextIntoBlank(draggedText)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    
        return UICollectionViewDropProposal(operation: .move)
    }
    
    private func insertTextIntoBlank(_ text: String) {
        guard let bodyText = bodyCell?.textView.text else { return }
        guard let placeholderRange = bodyText.range(of: placeholder) else { return }
        
        // Replace the blank with the dragged text
        placeholder = text
        
        
        
        // Create an attributed string based on the existing text
        let attributedText = NSMutableAttributedString(string: bodyText)
        
        // Replace the blank with the dropped text
        let nsRange = NSRange(placeholderRange, in: bodyText)
        attributedText.replaceCharacters(in: nsRange, with: text)
        
        // Apply underline attribute to the new text
        let underlineRange = NSRange(location: nsRange.location, length: text.count)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineRange)
        
        // Set the attributed text to the UITextView
        bodyCell?.textView.attributedText = attributedText
        
        
        
//        bodyCell?.textView.text = bodyCell?.textView.text?.replacingCharacters(in: range, with: text)
    }
}

private extension RecapViewController {
    func setup() {
        
        setupAnswers()
        setupCollectionView()
        updateFeedbackView()
        setupActivityIndicator()
        
    }
    
    func setupAnswers() {
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
