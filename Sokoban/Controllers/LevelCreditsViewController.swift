//
//  LevelCreditsViewController.swift
//  Pushman
//
//  Created by Juan Gestal Romani on 18/09/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class LevelCreditsViewController: UIViewController {
    
    @IBAction func linkButtonTapped(_ sender: UIButton) {
        openURL(urlString: "http://www.sourcecode.se/sokoban/levels")
    }
}


extension LevelCreditsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LevelManager.shared.worlds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LevelCreditsTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let world = LevelManager.shared.worlds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LevelCreditsTableViewCell.identifier) as! LevelCreditsTableViewCell
        cell.worldLabel.text = world.title
        cell.authorLabel.text = world.author
        cell.emailLabel.text = world.email
        return cell
    }
}

extension LevelCreditsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let email = LevelManager.shared.worlds[indexPath.row].email {
            openURL(urlString: "mailto:\(email)")
        }
    }
}
