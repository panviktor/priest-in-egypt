//
//  ScoreManager.swift
//  Priest in Egypt
//
//  Created by Viktor on 25.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import Foundation

class ScoreManager {
    let defaults = UserDefaults.standard
    
    private var allScore = [Int]()
    
    private(set) var currentLevel: Int
    private(set) var firstScore: Int
    private(set) var secondScore: Int
    private(set) var thirdScore : Int
    
    func appendNewScore(_ score: Int) {
        allScore.append(score)
        sortedScore()
        saveScore()
    }
    
    func addNewUnlockedLevel(_ level: Int) {
        if currentLevel < level {
            currentLevel = level
            defaults.set(currentLevel, forKey: "unlockedLevel")
        }
    }
    
    private func sortedScore() {
        allScore.sort()
        self.firstScore = allScore.max() ?? 0
        self.secondScore = allScore.filter { $0 < self.firstScore }.max() ?? 0
        self.thirdScore = allScore.filter { $0 < self.secondScore }.max() ?? 0
    }
    
    private func saveScore() {
        defaults.set(allScore, forKey: "savedScore")
    }
    
    func reset() {
        allScore.removeAll()
        saveScore()
    }
    
    init(){
        self.currentLevel = 1
        self.firstScore = 0
        self.secondScore = 0
        self.thirdScore = 0
        
        self.allScore = defaults.object(forKey:"savedScore") as? [Int] ?? [Int]()
        self.currentLevel =  defaults.object(forKey:"unlockedLevel") as? Int ?? 1

        if !allScore.isEmpty { sortedScore() }
    }
}
