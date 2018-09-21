//
//  CustomViewController.swift
//  Sokoban
//
//  Created by Juan Gestal Romani on 10/9/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
