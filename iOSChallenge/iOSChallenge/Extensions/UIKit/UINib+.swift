//
//  UINib+.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

extension UINib {
    static func instantiateView<T: UIView>(ofType type: T.Type) -> T {
        let nibName = String(describing: type)
        let nib = UINib(nibName: nibName, bundle: nil)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Could not instantiate view with name \(nibName)")
        }
        
        return view
    }
    
    static func instantiate<T: UIView>(ofType type: T.Type) -> UINib {
        let nibName = String(describing: type)
        return UINib(nibName: nibName, bundle: nil)
    }
}
