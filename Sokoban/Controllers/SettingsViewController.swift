//
//  SettingsViewController.swift
//  Pushman
//
//  Created by Juan Gestal Romani on 17/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isMusicEnabled = !UserDefaults.standard.bool(forKey: "isMusicDisabled")
        let isSoundEnabled = !UserDefaults.standard.bool(forKey: "isSoundDisabled")
        
        musicSwitch.setOn(isMusicEnabled, animated: false)
        soundSwitch.setOn(isSoundEnabled, animated: false)
    }
    
    @IBAction func musicSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(!sender.isOn, forKey: "isMusicDisabled")
        UserDefaults.standard.synchronize()
        if sender.isOn {
            SoundManager.shared.playMenuMusic()
        } else {
            SoundManager.shared.stopMusic()
        }
    }
    
    @IBAction func soundSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(!sender.isOn, forKey: "isSoundDisabled")
        UserDefaults.standard.synchronize()
    }

}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
    
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                rateInAppStore()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                clearScores()
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                gameDeveloperCredits()
            } else if indexPath.row == 1 {
                levelAuthorsCredits()
            }
        }
    }
    
    func rateInAppStore() {
        openURL(urlString: "itms-apps:itunes.apple.com/us/app/apple-store/id1435725051?mt=8&action=write-review")
    }
    
    func clearScores() {
        let alertController = UIAlertController(title: "Clear scores", message: "You will lose your progress. Are you sure?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            LevelManager.shared.clearScores()
        }
        
        let action2 = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gameDeveloperCredits() {
        performSegue(withIdentifier: "kDeveloperCreditsViewControllerSegueID", sender: self)
    }
    
    func levelAuthorsCredits() {
        performSegue(withIdentifier: "kLevelCreditsViewControllerSegueID", sender: self)
    }
}

