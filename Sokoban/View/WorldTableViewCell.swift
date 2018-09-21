//
//  WorldTableViewCell.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 11/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class WorldTableViewCell: CustomTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setValues(title: String, author: String, completedPercent: String, descriptionText: String) {
        titleLabel.text = title.uppercased()
        authorLabel.text = "BY \(author.uppercased())"
        completedLabel.text = completedPercent
        descriptionLabel.text = descriptionText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
