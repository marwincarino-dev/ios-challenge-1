//
//  AnswerCell.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/10/24.
//

import Foundation
import UIKit

class AnswerCell: UICollectionViewCell  {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
}

extension AnswerCell {
    func configure(with answer: String?) {
        label.text = answer
    }
}

extension AnswerCell {
    static var reuseIdentifier: String { String(describing: self)  }
    
    static var preferredHeight: CGFloat { 44.0 }
}

extension AnswerCell {
    static func nib() -> UINib {
        return UINib.instantiate(ofType: AnswerCell.self)
    }
}
