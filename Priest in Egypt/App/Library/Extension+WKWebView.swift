//
//  Extension+WKWebView.swift
//  Priest in Egypt
//
//  Created by Viktor on 10.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
    
    func load(_ url: URL) {
        let request = URLRequest(url: url)
        load(request)
    }
}
