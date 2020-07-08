//
//  AppDelegate.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//


import UIKit
import OneSignal
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let service = DifferentServices.shared
    var deepURL: URL? {
        didSet {
            NotificationCenter.default.post(name: .notificationDeepURLHasCome, object: self.deepURL)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        Settings.isAutoInitEnabled = true
        ApplicationDelegate.initializeSDK(nil)
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            if let error = error {
                print("Received error while fetching deferred app link %@", error)
            }
            if let url = url {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                self.deepURL = url
            }
        }
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "79a3e167-e79f-4de1-9461-f9aeaad0a6b5",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        service.screenLauncher()
        
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            print(#line)
            if let error = error {
                print("Received error while fetching deferred app link %@", error)
            }
            if let url = url {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}

extension Notification.Name {
    static let notificationDeepURLHasCome = Notification.Name("deepURLHasCome")
}
