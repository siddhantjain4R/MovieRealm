//
//  BasicExtensions.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import Foundation
import UIKit

/// UIColor Extensions
extension UIColor {
    /// init UIColor with hex string
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue: CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
}

/// String extensions
extension String {
    /// Converts string to hex
    func toHexIntValue() -> Int {
        return Int.init(self.replacingOccurrences(of: "#", with: ""), radix: 16)!
    }
    var isContainsNumbers: Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let testCase     = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: self)
    }
    var containsOnlyNumbers: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var notContainsSpecialCharacters: Bool {
        let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.'"
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = (self.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        return (self == filtered)
    }
    
    func stringToData() -> Data? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data
    }
}

/// Scrollview status
extension UIScrollView {
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

extension UIImageView {
    func roundedRect() {
        layer.cornerRadius = frame.width/2
        layer.masksToBounds = true
    }
}
extension UIButton {
    func roundedRectButton() {
        layer.cornerRadius = frame.width/2
        layer.masksToBounds = true
       // clipsToBounds = true
    }
}

// MARK: - Data
extension Data {
    func dataToString() -> String? {
        guard let returnedString = String(data: self, encoding: String.Encoding.utf8) else {
            return nil
        }
        return returnedString
    }
}
