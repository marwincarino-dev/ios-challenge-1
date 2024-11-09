//
//  ChoiceView.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

final class ChoiceView: UIView {
    // MARK: - IBOutlets
    
    @IBOutlet private var emojiLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    // MARK: - Properties
    
    var onTap: (() -> Void)?
    
    private(set) var isSelected: Bool = false {
        didSet {
            layer.borderColor = isSelected ? selectedColor.cgColor : unselectedColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        
        isSelected = false
        
        setupTapGestureRecognizer()
    }
    
    func configure(emoji: String, text: String) {
        emojiLabel.text = emoji
        textLabel.text = text
    }
    
    // MARK: - IBActions
    
    @IBAction
    private func touchUpInside(_ sender: Any) {
        select()
        onTap?()
    }
}

private extension ChoiceView {
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

private extension ChoiceView {
    var unselectedColor: UIColor {
        UIColor.lightGray
    }
    
    var selectedColor: UIColor {
        UIColor.purple
    }
}

extension ChoiceView {
    static func make() -> ChoiceView {
        return UINib.instantiateView(ofType: ChoiceView.self)
    }
}
