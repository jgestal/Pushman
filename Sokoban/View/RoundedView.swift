//
//  RoundedView.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 15/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8.0
    }
    
    
}
