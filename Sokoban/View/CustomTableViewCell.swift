//
//  CustomTableViewCell.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 11/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        changeBackgroundToSelectedOrHighlighted(selectedOrHighlighted: selected)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        changeBackgroundToSelectedOrHighlighted(selectedOrHighlighted: highlighted)
    }
    
    private func changeBackgroundToSelectedOrHighlighted(selectedOrHighlighted: Bool) {
        if selectedOrHighlighted {
            backgroundColor = UIColor(red:0.91, green:0.76, blue:0.60, alpha:1.0)
        } else {
            backgroundColor = .clear
        }
    }
}
