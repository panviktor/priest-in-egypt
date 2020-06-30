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
    
    fileprivate func requestURL() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let url = URL(string:  "http://78.47.187.129/5P1WyX8M")!
        //   let url = URL(string:  "http://ctraf.com/test")!
        let task = session.dataTask(with: url, completionHandler: { _, _, _ in })
        task.resume()
    }
    
    fileprivate func gameOrNot(_ redirectURL: String) {
        if redirectURL == "https://nobot/" {
            defaults.set(false, forKey: "firstBoot")
            defaults.set(false, forKey: "game")
            //FIXME: - One Signal Start
        } else {
            defaults.set(false, forKey: "firstBoot")
            defaults.set(true, forKey: "game")
            launchTheGame()
        }
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


extension DifferentServices: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let redirectURL = request.url  else { return }
        gameOrNot(redirectURL.absoluteString)
        //        completionHandler(request)
    }
}
