//
//  SelectWorldViewController.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 10/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit


class SelectWorldViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        back()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kSelectLevelSegue" {
            let indexPath = tableView .indexPath(for: sender as! UITableViewCell)!
            let destination = segue.destination as! SelectLevelViewController
            destination.selectedWorld = indexPath.row
        }
    }
    
    private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        super.pressesBegan(presses, with: event)
        
        guard let keyCode = presses.first?.key?.keyCode else { return }

        switch (keyCode) {

        case .keyboardEscape:
            back();
        
        default:
            break
        }
    }
}

extension SelectWorldViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LevelManager.shared.worlds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kWorldTableViewCell") as! WorldTableViewCell
        let world = LevelManager.shared.worlds[indexPath.row]
        let completedPercent = LevelManager.shared.percentCompletedOfWorld(worldID: indexPath.row)
        
        cell.setValues(title: world.title, author: world.author, completedPercent: completedPercent, descriptionText: world.description)
        return cell
    }
}



