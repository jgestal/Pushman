//
//  LevelCreditsTableViewCell.swift
//  Pushman
//
//  Created by Juan Gestal Romani on 18/09/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class LevelCreditsTableViewCell: UITableViewCell {
    
    static let identifier = "kLevelCreditsTableViewCell"
    static let height = CGFloat(124)
    
    @IBOutlet weak var worldLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}
