//
//  AppDelegate.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return bootstrap(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
