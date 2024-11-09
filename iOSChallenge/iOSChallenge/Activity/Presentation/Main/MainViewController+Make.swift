//
//  MainViewController+Make.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

extension MainViewController {
    static func make() -> MainViewController {
        return UIStoryboard.main.instantiateViewController(ofType: MainViewController.self)
    }
}
