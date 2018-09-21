//
//  Level.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 1/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

protocol LevelDelegate: class {
    func nodeMoves(from: IJPoint, to: IJPoint)
    func movementNotAllowed()
    func levelCompleted()
}


class Level {
    var fields : [[Field]]!
    weak var delegate : LevelDelegate?
    var levelStates : [String]!
    
    func loadLevelMap(levelMap: String) {
        levelStates = [String]()
        fields = parse(levelMap)
    }
    
    private func parse(_ levelText: String) -> [[Field]]? {
        var line = 0
        var level = [[Field]]()
        level.append([])
        
        // Support for single line levels
        let levelText = levelText.replacingOccurrences(of: "|", with: "\n").replacingOccurrences(of: "-", with: " ")
        
        for char in levelText {
            if char == "\n" || char == "|" {
                line += 1
                level.append([])
            } else {
                if let field = Field.init(rawValue: char) {
                    level[line].append(field)
                }
                else {
                    return nil
                }
            }
        }
        return level
    }
    
    func toString(singleLine: Bool) -> String {
        var levelStr = ""
        for i in 0..<fields.count {
            for j in 0..<fields[i].count {
                let char = singleLine ? String(fields[i][j].rawValue).replacingOccurrences(of: " ", with: "-") : String(fields[i][j].rawValue)
                levelStr += char
            }
            levelStr += "\n"
        }
        if singleLine {
            return levelStr.replacingOccurrences(of: "\n", with: "|")
        }
        return levelStr
    }
    
    //MARK: Movements
    
    func movePlayer(from: IJPoint, with displacement: IJPoint) {
        let to = IJPoint(i: from.i + displacement.i, j: from.j + displacement.j)
        fields[from.i][from.j] = fields[from.i][from.j] == .player ? .empty : .goalSquare
        fields[to.i][to.j] = fields[to.i][to.j] == .empty ? .player : .playerOnGoalSquare
        delegate?.nodeMoves(from: from, to: to)
    }
    
    func moveBox(from: IJPoint, with displacement: IJPoint) {
        let to = IJPoint(i: from.i + displacement.i, j: from.j + displacement.j)
        fields[from.i][from.j] = fields[from.i][from.j] == .box ? .empty : .goalSquare
        fields[to.i][to.j] = fields[to.i][to.j] == .empty ? .box : .boxOnGoalSquare
        delegate?.nodeMoves(from: from, to: to)
    }
    
    func move(with displacement: IJPoint) {
        
        if let playerPosition = playerPosition() {
            if isAllowedMovement(from: playerPosition, with: displacement) {
                levelStates.append(self.toString(singleLine: true))
                
                let to = IJPoint(i: playerPosition.i + displacement.i, j: playerPosition.j + displacement.j)
                print("Move from \(playerPosition) to \(to)")
                
                let toField = fields[to.i][to.j]
                if toField == .box || toField == .boxOnGoalSquare {
                    moveBox(from: to, with: displacement)
                }
                movePlayer(from: playerPosition, with: displacement)
                if isLevelCompleted() {
                    delegate?.levelCompleted()
                }
            } else {
                delegate?.movementNotAllowed()
            }
        }
    }
    
    func moveBack() -> Bool {
        if let levelState = levelStates.last {
            levelStates.removeLast()
            fields = parse(levelState)
            return true
        }
        return false 
    }
    
    func canMoveBack() -> Bool {
        return levelStates.count > 0
    }
    
    
    private func isLevelCompleted() -> Bool {
        for i in 0..<fields.count {
            for j in 0..<fields[i].count {
                if fields[i][j] == .box {
                    return false
                }
            }
        }
        return true
    }
    
    func isInLevelBounds(point: IJPoint) -> Bool {
        return point.i > 0 && point.i <= fields.count && point.j > 0 && point.j <= fields[point.i].count
    }
    
    func isAllowedMovement(from: IJPoint, with displacement: IJPoint) -> Bool {
        let to = IJPoint(i: from.i + displacement.i, j: from.j + displacement.j)
        
        if  isInLevelBounds(point: to) {
            switch fields[to.i][to.j] {
            case .box, .boxOnGoalSquare:
                let boxTo = IJPoint(i: to.i + displacement.i, j: to.j + displacement.j)
                if isInLevelBounds(point: boxTo) {
                    let field = fields[boxTo.i][boxTo.j]
                    return field == .empty || field == .goalSquare
                }
            case .empty, .goalSquare:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    func playerPosition() -> IJPoint? {
        for i in 0..<fields.count {
            for j in 0..<fields[i].count {
                if fields[i][j] == .player || fields[i][j] == .playerOnGoalSquare {
                    return IJPoint(i: i, j: j)
                }
            }
        }
        return nil
    }
}



