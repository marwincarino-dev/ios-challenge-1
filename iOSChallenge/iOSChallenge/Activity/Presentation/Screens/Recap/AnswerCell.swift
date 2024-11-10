//
//  AnswerCell.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/10/24.
//

import Foundation
import UIKit

class AnswerCell: UICollectionViewCell  {
    static var reuseIdentifier: String { String(describing: self)  }
    
    @IBOutlet var label: UILabel!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
    }
    
    
    static func nib() -> UINib {
        return UINib.instantiate(ofType: AnswerCell.self)
    }
}

