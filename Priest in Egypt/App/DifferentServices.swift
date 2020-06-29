//
//  DifferentServices.swift
//  Priest in Egypt
//
//  Created by Viktor on 29.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import Reachability

class DifferentServices: UIResponder, UIApplicationDelegate,  ReachabilityObserverDelegate {
    var window: UIWindow?
    
    static let shared = DifferentServices()
    private let defaults = UserDefaults.standard
    
    func checkFirstBoot() -> Bool {
        return defaults.object(forKey:"firstBoot") as? Bool ?? true
    }
    
    //MARK: - Reachability
    override init() {
        super.init()
        try? addReachabilityObserver()
    }
    
    deinit {
        removeReachabilityObserver()
    }
    

    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            print("Internet connection")
             delay(bySeconds: 0.1) {
                self.launchWKweb()
            }
           
        } else {
            print("No internet connection")
            delay(bySeconds: 0.1) {
                self.launchNoInternet()
            }
        }
    }
    
    
    func launchTheGame() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Welcome", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func launchWKweb() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "WKweb", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func launchNoInternet() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "NoInternet", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoInternetViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    
    func checkInternet() {
        
    }
}
