//
//  RecapViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class RecapViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private var eyebrowLabel: UILabel!
    @IBOutlet private var bodyCollectionView: UICollectionView!
    @IBOutlet private var feedbackStackView: UIStackView!
    @IBOutlet private var feedbackIndicatorView: UIView!
    @IBOutlet private var feedbackLabel: UILabel!
    @IBOutlet private var answersCollectionView: UICollectionView!
    @IBOutlet private var continueButton: UIButton!
   
    // MARK: - Properties
    
    var onSubmit: (() -> Void)?
    var viewModel: RecapViewModel!
    
    private var bodyCell: BodyCell?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Actions
    
    @IBAction func onTapContinue(_ sender: Any) {
        submitWithSimulatedLoading()
    }
}

private extension RecapViewController {
    func setup() {
        setupBodyCollectionView()
        setupAnswersCollectionView()
        updateFeedbackView()
        setupActivityIndicator()
    }
    
    func setupRecap() {
        eyebrowLabel.text = viewModel.eyebrow
    }
    
    func setupBodyCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bodyCollectionView.frame.size.width, height: bodyCollectionView.frame.height)
        
        bodyCollectionView.setCollectionViewLayout(layout, animated: true)
        bodyCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bodyCollectionView.dataSource = self
        bodyCollectionView.dropDelegate = self
        bodyCollectionView.register(BodyCell.nib(), forCellWithReuseIdentifier: BodyCell.reuseIdentifier)
    }
    
    func setupAnswersCollectionView() {
        answersCollectionView.setCollectionViewLayout(dynamicCollectionLayout(), animated: true)
        answersCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        answersCollectionView.dataSource = self
        answersCollectionView.dragDelegate = self
        answersCollectionView.dropDelegate = self
        answersCollectionView.register(AnswerCell.nib(), forCellWithReuseIdentifier: AnswerCell.reuseIdentifier)
    }
    
    func dynamicCollectionLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(
                widthDimension: .estimated(124),
                heightDimension: .absolute(AnswerCell.preferredHeight)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            
            // Group - horizontal group that wraps to the next row if item width exceeds screen width
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(AnswerCell.preferredHeight)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            
            return section
        }
    }
    
    func submit() {
        onSubmit?()
        
        viewModel.clearSelectedAnswer()
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
    
    func insertTextIntoBlank(_ answerText: String) {
        let placeholder = viewModel.answerPlaceholder
        
        guard let bodyText = bodyCell?.text,
              let placeholderRange = bodyText.range(of: placeholder) else { return }
              
        let attributedText = NSMutableAttributedString(string: bodyText)
        let targetRange = NSRange(placeholderRange, in: bodyText)
        
        attributedText.replaceCharacters(in: targetRange, with: answerText)
        
        let underlineRange = NSRange(location: targetRange.location, length: answerText.count)
        attributedText.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: underlineRange
        )
        
        attributedText.addAttributes([
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: UIColor.lightGray
        ], range: NSRange(location: 0, length: attributedText.length))
        
        bodyCell?.configure(with: attributedText)
        
        viewModel.select(answer: answerText)
        updateFeedbackView(isCorrectAnswer: viewModel.hasCorrectAnswer)
        updateContinueButton()
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
    var correctAnswerText: String {
        "You're correct!"
    }
    
    var wrongAnswerText: String {
        "Try again"
    }
}

// MARK: - UICollectionView

extension RecapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bodyCollectionView {
            return 1
        } else if collectionView == answersCollectionView {
            return viewModel.answers.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bodyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BodyCell.reuseIdentifier,
                for: indexPath
            ) as? BodyCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModel.body)
            bodyCell = cell
            
            return cell
        } else if collectionView == answersCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnswerCell.reuseIdentifier,
                for: indexPath
            ) as? AnswerCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: viewModel.answers[indexPath.row].text)
            cell.contentView.backgroundColor = .clear
            cell.clipsToBounds = false
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 2
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension RecapViewController: UICollectionViewDragDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        let text = viewModel.answers[indexPath.row].text
        let itemProvider = NSItemProvider(object: text as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = text
        
        return [dragItem]
    }
}

extension RecapViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard collectionView == bodyCollectionView else { return }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let draggedText = items.first as? String else { return }
            self.insertTextIntoBlank(draggedText)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: any UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
    
        return UICollectionViewDropProposal(operation: .move)
    }
}

