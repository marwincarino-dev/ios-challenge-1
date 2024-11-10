//
//  String+.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/11/24.
//

import Foundation

extension String {
    func formatBody() -> String {
        guard let placeholderRange = self.range(of: String.recapPlaceholder) else { return self }
        
        let targetRange = NSRange(placeholderRange, in: self)
        
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.replaceCharacters(in: targetRange, with: String.blankPlaceholder)
        
        return attributedText.string
    }
    
    static var recapPlaceholder: String { "%  RECAP  %" }
    
    static var blankPlaceholder: String { "________" }
}
