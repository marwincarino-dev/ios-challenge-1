//
//  AppConfig.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

enum AppConfig {
    static var remoteActivityURL: URL {
        URL(string: "https://any-url.com")!
    }
    
    static var activityURL: URL {
        Bundle.main.url(
            forResource: "activity-response-ios",
            withExtension: "json"
        )!
    }
}
