//
//  Any+.swift
//  iOSChallengeTests
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyError() -> NSError {
    NSError(domain: "Test", code: 1)
}

func anyData(_ data: [[String: Any]]) -> Data {
    let json = ["data": data]
    return try! JSONSerialization.data(withJSONObject: json)
}
