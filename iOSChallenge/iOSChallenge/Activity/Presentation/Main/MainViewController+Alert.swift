//
//  MainViewController+Alert.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

extension MainViewController {
    func showAlert(title: String?, message: String?) {
        self.navigationController?.present(
            UIAlertController.defaultAlert(
                title: title,
                message: message
            ),
            animated: true
        )
    }
}
