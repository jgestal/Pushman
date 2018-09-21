//
//  UIViewController+Extension.swift
//  Pushman
//
//  Created by Juan Gestal Romani on 20/09/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

extension UIViewController {
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

