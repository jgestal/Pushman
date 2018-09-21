//
//  LevelManager.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 10/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

class LevelManager {
    
    static let shared = LevelManager()

    var scoreData : [Int:[Int:Int]]!
    var worlds = [World]()

    private init() {
        worlds = loadJson(filename: "levels")!
        if let savedData = UserDefaults.standard.data(forKey: "scores") {
            do {
                scoreData = try JSONDecoder().decode([Int:[Int:Int]].self, from: savedData)
            } catch {
                scoreData = [Int:[Int:Int]]()
            }
        }
        else {
            scoreData = [Int:[Int:Int]]()
        }
    }

    func loadJson(filename fileName: String) -> [World]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let worlds = try decoder.decode([World].self, from: data)
                return worlds.sorted { $0.id < $1.id }
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
  
}


extension LevelManager {
    
    private func saveToDefaults() {
        let dataToSave = try! JSONEncoder().encode(scoreData)
        UserDefaults.standard.set(dataToSave, forKey: "scores")
        UserDefaults.standard.synchronize()
    }
    
    func clearScores() {
        scoreData = [Int:[Int:Int]]()
        saveToDefaults()
    }
    
    func getScore(worldID: Int, levelID: Int) -> Int? {
        guard
            let worldScores = scoreData[worldID],
            let levelScore = worldScores[levelID]
            else { return nil }
        return levelScore
    }
    
    func saveScore(worldID: Int, levelID: Int, moves: Int) {
        if scoreData[worldID] == nil {
            scoreData[worldID] = [Int:Int]()
        }
        scoreData[worldID]![levelID] = moves
        saveToDefaults()
    }
    
    func isBestScore(worldID: Int, levelID: Int, moves: Int) -> Bool {
        if let score = scoreData[worldID]?[levelID] {
            return moves < score
        }
        return true
    }
    
    func percentCompletedOfWorld(worldID: Int) -> String {
        if let scoresOfWorld = scoreData[worldID] {
            let percent = Float(scoresOfWorld.count) * 100 / Float(worlds[worldID].levels.count)
            return String(Int(percent)) + "%"
        } else {
            return "0%"
        }
    }
}
