//
//  SelectLevelViewController.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 10/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class SelectLevelViewController: CustomViewController {
    var selectedWorld: Int!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kGameViewControllerSegue" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let destination = segue.destination as! GameViewController
            destination.selectedWorld = selectedWorld
            destination.selectedLevel = indexPath.row
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectLevelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LevelManager.shared.worlds[selectedWorld].levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let level = LevelManager.shared.worlds[selectedWorld].levels[indexPath.row]
        
        if let score = LevelManager.shared.getScore(worldID: selectedWorld, levelID: indexPath.row) {
            let finishedLevelCell = tableView.dequeueReusableCell(withIdentifier: "kFinishedLevelTableViewCell") as! FinishedLevelTableViewCell
            finishedLevelCell.titleLabel.text = level.name
            finishedLevelCell.bestMovesLabel.text = "BEST MOVES: \(score)"
            cell = finishedLevelCell
        } else {
            let unfinishedLevelCell = tableView.dequeueReusableCell(withIdentifier: "kUnfinishedLevelTableViewCell") as! UnfinishedLevelTableViewCell
            unfinishedLevelCell.titleLabel.text = level.name
            cell = unfinishedLevelCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat!
        if LevelManager.shared.getScore(worldID: selectedWorld, levelID: indexPath.row) != nil {
            height =  FinishedLevelTableViewCell.height
        } else {
            height =  UnfinishedLevelTableViewCell.height
        }
        return height 
    }
}

extension SelectLevelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

