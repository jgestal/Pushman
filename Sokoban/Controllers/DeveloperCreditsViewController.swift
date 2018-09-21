//
//  DeveloperCreditsViewController.swift
//  Pushman
//
//  Created by Juan Gestal Romani on 20/09/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit


class DeveloperCreditsViewController: UIViewController {
    
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        openURL(urlString: "mailto:juan@gestal.es")
    }
    
    @IBAction func webButtonTapped(_ sender: UIButton) {
        openURL(urlString: "https://www.gestal.es")
    }
}
