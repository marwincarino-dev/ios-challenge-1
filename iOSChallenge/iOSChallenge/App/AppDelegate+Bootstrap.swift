//
//  AppDelegate+Bootstrap.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation
import UIKit

extension AppDelegate {
    func bootstrap(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let remote: ActivityLoader = RemoteActivityLoader(url: AppConfig.remoteActivityURL, client: ActivityHTTPClient())
        let local: ActivityLoader = LocalActivityLoader(url: AppConfig.activityURL)
        let repository: ActivityContainerRepository = CommonActivityContainerRepository(primary: remote, secondary: local)
        let getUseCase: GetActivityContainerUseCase = CommonGetActivityContainerUseCase(repository: repository)
        
        let mainViewController = MainViewController.make()
        mainViewController.viewModel = CommonMainViewModel(getActivityUseCase: getUseCase)
      
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
}
