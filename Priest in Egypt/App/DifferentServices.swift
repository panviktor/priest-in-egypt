//
//  DifferentServices.swift
//  Priest in Egypt
//
//  Created by Viktor on 29.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import OneSignal
import FBSDKCoreKit
import Reachability

class DifferentServices: UIResponder, UIApplicationDelegate,  ReachabilityObserverDelegate {
    fileprivate enum AppState {
        case inGame
        case WKWeb
        case starting
    }
    
    var window: UIWindow?
    
    static let shared = DifferentServices()
    fileprivate let defaults = UserDefaults.standard
    fileprivate var state: AppState
    fileprivate var checkRun = false
    
    //MARK: - Reachability
    override init() {
        self.state = .starting
        super.init()
        try? addReachabilityObserver()
    }
    
    deinit {
        removeReachabilityObserver()
    }
    
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            print("Internet connection!")
            switch state {
            case .inGame:
                launchTheGame()
            case .WKWeb:
                launchWKweb()
            case .starting:
                if checkFirstBoot() && !checkRun  {
                    checkMainURL()
                } else if checkGame() {
                    launchTheGame()
                } else {
                    launchWKweb()
                }
            }
        } else {
            print("No internet connection")
            delay(bySeconds: 0.1) {
                self.launchNoInternet()
            }
        }
        print(state)
    }
    
    //MARK: - Bot checker logic
    fileprivate func checkFirstBoot() -> Bool {
        return defaults.object(forKey:"firstBoot") as? Bool ?? true
    }
    
    fileprivate func checkGame() -> Bool {
        return defaults.object(forKey:"game") as? Bool ?? true
    }
    
    fileprivate func checkMainURL() {
        checkRun.toggle()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let url = URL(string:  "http://78.47.187.129/5P1WyX8M")!
        let task = session.dataTask(with: url, completionHandler: { _, _, _ in })
        task.resume()
    }
    
    fileprivate func gameOrNot(_ redirectURL: String) {
        print(#file, #function, redirectURL)
        if redirectURL == "https://nobot/" {
            defaults.set(false, forKey: "firstBoot")
            defaults.set(false, forKey: "game")
            state = .WKWeb
            hasPromptedOneSignal()
            DispatchQueue.main.async {
                self.launchWKweb()
            }
        } else {
            defaults.set(false, forKey: "firstBoot")
            defaults.set(true, forKey: "game")
            state = .inGame
            DispatchQueue.main.async {
                self.launchTheGame()
            }
        }
    }
    
    //MARK: - OneSignal
    private func hasPromptedOneSignal() {
        OneSignal.sendTag("nobot", value: "1")
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
        if checkFirstBoot()  {
            if reachable {
                checkMainURL()
            } else {
                state = .starting
                launchNoInternet()
            }
        } else {
            if reachable {
                if checkGame() {
                    launchTheGame()
                } else {
                    launchWKweb()
                }
            } else {
                state = .starting
                launchNoInternet()
            }
        }
        print(#line, state)
    }
}
//MARK: - URLSessionDataDelegate
extension DifferentServices: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let redirectURL = request.url  else { return }
        gameOrNot(redirectURL.absoluteString)
        //completionHandler(request)
    }
}

//MARK: - GUI
extension DifferentServices {
    private func launchTheGame() {
        state = .inGame
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Welcome", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func launchWKweb() {
        state = .WKWeb
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
