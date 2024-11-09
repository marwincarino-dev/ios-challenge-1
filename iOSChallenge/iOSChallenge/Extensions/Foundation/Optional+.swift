//
//  Optional+.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

extension Optional<String> {
    func unwrap() -> String {
        return self ?? ""
    }
}
