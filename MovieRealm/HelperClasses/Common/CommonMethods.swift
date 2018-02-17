//
//  CommonMethods.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

class CommonMethods: NSObject {
    
    // MARK: Variables
    static var navControl: UINavigationController?
    
    // MARK: Navigation Methdods
    
    /**
     This methods manage the navigation.
     
     - parameter destinationVC:        destination view controller
     - parameter navigationController: navigation controller object
     - parameter animated:             Animation (true/false)
     */
    class func navigateTo(_ destinationVC: UIViewController, inNavigationViewController navigationController: UINavigationController, animated: Bool ) {
        //Assign to global value
        var VCFound: Bool = false
        let viewControllers: NSArray = navigationController.viewControllers as NSArray
        var indexofVC: NSInteger = 0
        for vc in navigationController.viewControllers {
            if vc.nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        
        DispatchQueue.main.async(execute: {
            if VCFound == true {
                navigationController.popToViewController((viewControllers.object(at: indexofVC) as? UIViewController)!, animated: animated)
            } else {
                navigationController.pushViewController(destinationVC, animated: animated)
            }
        })
    }
    
    /**
     This methods is used to get reference of already present viewcontroller object.
     
     - parameter destinationVC:        destination view controller
     - parameter navigationController: navigation controller object
     
     - returns: Object of destination view controller
     */
    class func findViewControllerRefInStack(_ destinationVC: UIViewController, inNavigationViewController navigationController: UINavigationController) -> UIViewController {
        var VCFound = false
        var viewControllers = navigationController.viewControllers
        var indexofVC = 0
        for vc: UIViewController in viewControllers {
            if vc.nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        if VCFound == true {
            return viewControllers[indexofVC]
        } else {
            return destinationVC
        }
    }
    
    
    
    // MARK: Validation Methods
    class func emailAdrressValidation(strEmail: String) -> Bool {
        if strEmail.isEmpty {
            return false
        }
        let emailRegEx = "[.0-9a-zA-Z_-]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: strEmail) {
            return false
        }
        return true
    }
    
    class func setUIButtonBorderColor(input: UIButton, borderColor: UIColor) {
        input.layer.cornerRadius = 5.0
        input.layer.borderColor = borderColor.cgColor
        input.layer.borderWidth = 1.0
        input.layer.masksToBounds = true
    }
}

@IBDesignable
class TextFieldLayout: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}


