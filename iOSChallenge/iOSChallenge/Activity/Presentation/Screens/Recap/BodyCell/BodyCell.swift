//
//  BodyCell.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/10/24.
//

import Foundation
import UIKit

class BodyCell: UICollectionViewCell  {
    @IBOutlet private var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.text = nil
    }
}

extension BodyCell {
    func configure(with body: String) {
        textView.text = body
    }
    
    func configure(with body: NSAttributedString) {
        textView.attributedText = body
    }
    
    var text: String? {
        textView.text
    }
}

extension BodyCell {
    static var reuseIdentifier: String { String(describing: self)  }
}

extension BodyCell {
    static func nib() -> UINib {
        return UINib.instantiate(ofType: BodyCell.self)
    }
}
