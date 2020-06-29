//
//  DifferentServices.swift
//  Priest in Egypt
//
//  Created by Viktor on 29.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import Foundation

class DifferentServices {
    static let shared = DifferentServices()
    let defaults = UserDefaults.standard
    
    func checkFirstBoot() -> Bool {
        return defaults.object(forKey:"firstBoot") as? Bool ?? true
    }
    
    private init() {
        print("Singleton initialized")
    }
}
