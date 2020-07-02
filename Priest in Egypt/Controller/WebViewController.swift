//
//  WebViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 29.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load("https://www.apple.com")
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    
    override func loadView() {
        self.view = webView
    }
}

extension WebViewController: WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
        }
        
        if keyPath == "title" {
            if let title = webView.title {
                print(title)
            }
        }
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: "Hey, listen!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        completionHandler()
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
