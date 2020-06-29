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
    let service = DifferentServices.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        service.launchWKweb()
        return true
    }
}

