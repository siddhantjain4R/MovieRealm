//
//  MovieDetailVC.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 18/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class MovieDetailVC: UIViewController {
    
    // MARK: - Variable
    var movie: Movie?
    var movieDetailVM: MovieDetailViewModel?
    // MARK: - Outlets
    
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var releasDateLbl: UILabel!
    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var movieDescriptionTxtView: UITextView!
    @IBOutlet weak var trailorView: YTPlayerView!

    @IBOutlet weak var ratingLbl: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailVM = MovieDetailViewModel(movie!, controller: self)
        movieDetailVM?.delegate = self
        assignValuesAndUpdateUI()
        showProgressView(with: "Fetching trailer")
        movieDetailVM?.fetchMovieVideoUrlFromApi()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        trailorView.stopVideo()
    }

    // MARK: - Setup and Assign
    func assignValuesAndUpdateUI() {
        movieTitleLbl.text = movie?.movieTitle
        releasDateLbl.text = movie?.releaseDate
        ratingView.rating = Float(movie?.rating ?? 0)
        ratingLbl.text = "\(movie?.rating ?? 0.0)/10"
        if let posterUrl = movie?.posterUrl {
            let imageUrl = Constant.movieDBImageURL + posterUrl
            movieImgView.setImage(withUrlString: imageUrl, placeHolderImage: UIImage(named: "poster-placeholder"))
        }
        movieDescriptionTxtView.text = movie?.movieOverview
    }
    
    func loadVideo() {
        if let key = movieDetailVM?.movieDetail?.videoUrl {
            trailorView.load(withVideoId: key)
        }
    }

}

extension MovieDetailVC: MovieDetailDelegate {
    
}
