//
//  LevelTableViewCell.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 11/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class FinishedLevelTableViewCell: CustomTableViewCell {
    
    static let height: CGFloat = 88
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bestMovesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
