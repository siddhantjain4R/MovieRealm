//
//  MovieListCollectionViewCell.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 18/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieYearLbl: UILabel!
    @IBOutlet weak var imgBorderView: UIView!
    
    // MARK: - Life Cycle methods
    override func awakeFromNib() {
        movieImgView.clipsToBounds = true
        movieImgView.layer.cornerRadius = 4.0
        imgBorderView.layer.masksToBounds = false
        imgBorderView.layer.cornerRadius = 4.0
        imgBorderView.layer.shadowColor = UIColor.black.cgColor
        imgBorderView.layer.shadowRadius = 1.5
        imgBorderView.layer.shadowOpacity = 0.4
        imgBorderView.layer.shadowOffset = CGSize.zero
    }
}
