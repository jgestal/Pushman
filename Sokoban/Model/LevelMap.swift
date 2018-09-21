//
//  LevelMap.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 10/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

class LevelMap: Codable {
    var id: Int!
    var name: String!
    var width: String?
    var height: String?
    var levelMap: String!
    var score: Int? 
}
