//
//  UIViewController+Extension.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVFoundation
import AVKit

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
    
    /// Show progress view over current VC
    func showProgressView(with title: String) {
        hideProgressView()
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        DispatchQueue.main.async(execute: {
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.contentColor = UIColor.white
            hud.bezelView.alpha = 1.0
            hud.bezelView.color = UIColor.clear
            hud.bezelView.style = .solidColor
            hud.backgroundView.color = UIColor.black
            hud.backgroundView.alpha = 0.6
            hud.backgroundView.style = .solidColor
            hud.label.text = title
            //hud.detailsLabel.text = description
        })
    }
    
    /// Hide progress view over current VC
    func hideProgressView() {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        DispatchQueue.main.async(execute: {
            MBProgressHUD.hide(for: window, animated: true)
        })
    }
    
    
    /// Video Player
    ///
    /// - Parameter strUrl: pass the video Url
    @objc func playVideo(strUrl: String) {
        guard strUrl != "" else { return }
        if NetworkManager.sharedInstance.isReachable == true {
            guard let videoURL = URL(string: strUrl) else {
                return
            }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            if #available(iOS 9.0, *) {
                playerViewController.allowsPictureInPicturePlayback = true
            } else {
                // Fallback on earlier versions
            }
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }
}
