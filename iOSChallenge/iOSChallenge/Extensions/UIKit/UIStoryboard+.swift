//
//  UIStoryboard+.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var multipleChoice: UIStoryboard {
        UIStoryboard(name: "MultipleChoice", bundle: nil)
    }
    
    static var recap: UIStoryboard {
        UIStoryboard(name: "Recap", bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(ofType type: T.Type) -> T {
        let storyboardId = String(describing: type)
        
        guard let controller = instantiateViewController(withIdentifier: storyboardId) as? T else {
            fatalError("Could not instantiate view controller with identifier \(storyboardId)")
        }
        
        return controller
    }
}
