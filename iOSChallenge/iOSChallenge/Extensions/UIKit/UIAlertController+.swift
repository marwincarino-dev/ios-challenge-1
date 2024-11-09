//
//  UIAlertController+.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

extension UIAlertController {
    static func defaultAlert(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            .init(
                title: "OK",
                style: .default
            )
        )
        
        return alertController
    }
}
