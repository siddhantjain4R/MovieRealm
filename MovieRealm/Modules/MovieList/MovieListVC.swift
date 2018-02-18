//
//  MovieListVC.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {

    // MARK: - Variables
    var movieListViewModel: MovieListViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListViewModel = MovieListViewModel( movieListCollectionView, controller: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showProgressView(with: "Fetching Movies")
            self.movieListViewModel? .fetchMoviesFromApi(filter: MovieFilterType.mostPopular.rawValue)
        }
    }
    
    deinit {
        movieListViewModel = nil
    }
}
