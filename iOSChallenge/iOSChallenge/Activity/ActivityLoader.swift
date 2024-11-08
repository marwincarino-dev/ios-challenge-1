//
//  ActivityLoader.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

protocol ActivityLoader {
    typealias Result = Swift.Result<[Data], Error>
    
    func load(completion: @escaping (ActivityLoader.Result) -> Void)
}
