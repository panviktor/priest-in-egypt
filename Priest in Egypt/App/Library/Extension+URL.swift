//
//  Extension+URL.swift
//  Priest in Egypt
//
//  Created by Viktor on 10.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import Foundation

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair
                .components(separatedBy:"=")[safe: 1]?
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            queryStrings[key] = value
        }
        print(queryStrings)
        return queryStrings
    }
}
