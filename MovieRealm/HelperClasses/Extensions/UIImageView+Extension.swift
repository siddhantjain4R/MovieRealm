//
//  UIImageView+Extension.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 18/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(withUrlString url: String, placeHolderImage: UIImage?) {
        self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .continueInBackground) { (image, _, cache, _) in
            if let downLoadedImage = image, cache == .none {
                UIView.transition(with: self,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.image = downLoadedImage
                }, completion: nil)
            } else {
                self.image = image != nil ? image : placeHolderImage
            }
        }
    }
}
