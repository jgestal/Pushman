//
//  World.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 10/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

class World: Codable {
    var id: Int!
    var title: String!
    var description: String!
    var email: String?
    var url: String?
    var author: String!
    var maxWidth : String?
    var maxHeight : String?
    var levels = [LevelMap]()
    
//    func log() {
//        if let title = title {
//            print("Title: \(title)")
//        }
//        if let description = description {
//            print("Description: \(description)")
//        }
//        if let email = email {
//            print("Email: \(email)")
//        }
//        if let url = url {
//            print("Url: \(url)")
//        }
//        if let author = author {
//            print("Author: \(author)")
//        }
//        if let maxWidth = maxWidth {
//            print("Max Width: \(maxWidth)")
//        }
//        if let maxHeight = maxHeight {
//            print("Max Height: \(maxHeight)")
//        }
//        levels.forEach {
//            $0.log()
//        }
//    }
}
