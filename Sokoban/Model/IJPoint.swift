//
//  IJPoint.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 15/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

struct IJPoint {
    let i : Int
    let j : Int
    
    static let up = IJPoint(i: -1, j: 0)
    static let right = IJPoint(i: 0, j: 1)
    static let down = IJPoint(i: 1, j: 0)
    static let left = IJPoint(i: 0, j: -1)
}
