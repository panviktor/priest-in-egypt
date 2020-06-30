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
    fileprivate let defaults = UserDefaults.standard
    
    
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
                //                self.launchWKweb()
                self.requestURL()
                //self.launchTheGame()
            }
            
        } else {
            print("No internet connection")
            delay(bySeconds: 0.1) {
                self.launchNoInternet()
            }
        }
    }
    
    //MARK: - Bot checker logic
    fileprivate func checkFirstBoot() -> Bool {
        return defaults.object(forKey:"firstBoot") as? Bool ?? true
    }
    
    func requestURL() {
        let session = URLSession.shared
        let url = URL(string:  "http://78.47.187.129/5P1WyX8M")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            print(#line, response)
        })
        task.resume()
    }
    
    
    //MARK: - UI
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
    
    fileprivate func launchNoInternet() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "NoInternet", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoInternetViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}
