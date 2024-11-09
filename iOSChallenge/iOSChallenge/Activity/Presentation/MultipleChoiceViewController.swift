//
//  MultipleChoiceViewController.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import UIKit

final class MultipleChoiceViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static func make() -> MultipleChoiceViewController {
        return UIStoryboard.main.instantiateViewController(ofType: MultipleChoiceViewController.self)
    }
}

