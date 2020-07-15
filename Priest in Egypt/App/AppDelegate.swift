import UIKit
import OneSignal
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let defaults = UserDefaults.standard
    let service = DifferentServices.shared
    
    var deepURL: URL? {
        didSet {
            NotificationCenter.default.post(name: .notificationDeepURLHasCome, object: self.deepURL)
            defaultsDeepURL = deepURL!.absoluteString
        }
    }
    
    var defaultsDeepURL: String {
        get {
            return defaults.object(forKey: "defaultsDeepURL") as? String ?? ""
        } set (newValue)  {
            defaults.set(newValue, forKey: "defaultsDeepURL")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
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
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "79a3e167-e79f-4de1-9461-f9aeaad0a6b5",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        service.screenLauncher()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
      if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
        if (rootViewController.responds(to: #selector(WebViewController.canRotate))) {
          // Unlock landscape view orientations for this view controller
          return .allButUpsideDown;
        }
      }
      
      // Only allow portrait (standard behaviour)
      return .portrait;
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
      if (rootViewController == nil) { return nil }
      if (rootViewController.isKind(of: UITabBarController.self)) {
        return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
      } else if (rootViewController.isKind(of: UINavigationController.self)) {
        return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
      } else if (rootViewController.presentedViewController != nil) {
        return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
      }
      return rootViewController
    }
    
}

extension Notification.Name {
    static let notificationDeepURLHasCome = Notification.Name("deepURLHasCome")
}
