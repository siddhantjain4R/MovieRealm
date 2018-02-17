//
//  UIViewController+Extension.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Setting Up UI of navigation Bar
     
     - parameter navControl:  Object of Navigation Controller
     - parameter navItem: Object of Navigation Item
     - parameter title:   Title of Navigation Bar
     */
     func setUpNavigationBar(title: NSString, transperant isTrans: Bool, hidden isHidden: Bool, barColor: UIColor, fontColor: UIColor, barStyle: UIStatusBarStyle = .default) {
        let navControl = self.navigationController!
        let navItem = self.navigationItem
        UIApplication.shared.statusBarStyle = barStyle
        if  !isHidden {
            navControl.navigationBar.isHidden = false
            if isTrans {
                navControl.navigationBar.shadowImage = UIImage()
            } else {
                navControl.view.backgroundColor = barColor
            }
            navItem.title = title as String
            navControl.navigationBar.isTranslucent = isTrans
            navControl.navigationBar.barTintColor = barColor
            navControl.navigationBar.tintColor = fontColor
            navControl.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: fontColor]
        } else {
            navControl.navigationBar.isHidden = true
        }
    }
    
    /// Use to show alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: description of the alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /// Makes a particular view controller as root
    ///
    /// - Parameters:
    ///   - viewController: pass the VC that needs to become root
    func setRootViewController(viewController: UIViewController, animated: Bool = false) {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let navigationController = appDelegate?.window?.rootViewController as? UINavigationController {
            navigationController.setViewControllers([viewController], animated: animated)
        }
    }
}
