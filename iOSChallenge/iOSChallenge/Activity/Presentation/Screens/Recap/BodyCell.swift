//
//  BodyCell.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/10/24.
//

import Foundation
import UIKit

class BodyCell: UICollectionViewCell  {
    static var reuseIdentifier: String { String(describing: self)  }
    
    @IBOutlet var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.text = nil
    }
    
    
    static func nib() -> UINib {
        return UINib.instantiate(ofType: BodyCell.self)
    }
}

