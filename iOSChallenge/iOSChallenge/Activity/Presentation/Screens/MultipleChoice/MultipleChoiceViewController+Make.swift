//
//  MultipleChoiceViewController+Make.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

extension MultipleChoiceViewController {
    static func make() -> MultipleChoiceViewController {
        return UIStoryboard.multipleChoice.instantiateViewController(ofType: MultipleChoiceViewController.self)
    }
}
