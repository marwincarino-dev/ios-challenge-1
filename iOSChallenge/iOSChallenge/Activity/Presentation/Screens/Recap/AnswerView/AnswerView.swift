//
//  AnswerView.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

final class AnswerView: UIView {
    // MARK: - IBOutlets
    
    @IBOutlet private var textLabel: UILabel!
    
    // MARK: - Properties
    
    var onTap: ((AnswerView) -> Void)?
    
    private(set) var isSelected: Bool = false {
        didSet {
            layer.shadowColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
            layer.shadowOpacity = isSelected ? 0.25 : 0.0
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = isSelected ? 5 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        resetSelection()
        setupTapGestureRecognizer()
    }
    
    func configure(text: String) {
        textLabel.text = text
    }
    
    func resetSelection() {
        isSelected = false
    }
    
    // MARK: - IBActions
    
    @IBAction
    private func touchUpInside(_ sender: Any) {
        select()
        onTap?(self)
    }
}

private extension AnswerView {
    func setupTapGestureRecognizer() {
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(touchUpInside)
            )
        )
    }
    
    func select() {
        isSelected.toggle()
    }
}

extension AnswerView {
    static func make() -> AnswerView {
        return UINib.instantiateView(ofType: AnswerView.self)
    }
}
