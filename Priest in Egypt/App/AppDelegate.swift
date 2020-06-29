//
//  AppDelegate.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let service = DifferentServices.shared
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let firstLaunchСheck = DifferentServices.shared.checkFirstBoot()
        let storyboard: UIStoryboard
        let initialViewController: UIViewController
        
        if firstLaunchСheck {
            storyboard = UIStoryboard(name: "Welcome", bundle: .main)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        } else {
            storyboard = UIStoryboard(name: "WKweb", bundle: .main)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController")
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

