//
//  RecapViewController+Make.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

extension RecapViewController {
    static func make() -> RecapViewController {
        return UIStoryboard.recap.instantiateViewController(ofType: RecapViewController.self)
    }
}
