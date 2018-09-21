//
//  Field.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 1/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

enum Field : Character {
    case wall = "#"
    case player = "@"
    case playerOnGoalSquare = "+"
    case box = "$"
    case boxOnGoalSquare = "*"
    case goalSquare = "."
    case empty = " "
}
