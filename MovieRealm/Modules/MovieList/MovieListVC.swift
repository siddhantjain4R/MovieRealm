//
//  MovieListVC.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit
import DropDown

class MovieListVC: UIViewController {
    
    // MARK: - Variables
    var movieListViewModel: MovieListViewModel?
    let dropdown: DropDown = DropDown()
    
    // MARK: - Outlets
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterLbl: UILabel!
    
    // MARK: - User Actions
    @IBAction func searchTapped(_ sender: Any) {
        showHideSearchOrFilterView(isSearchView: false)
    }
    @IBAction func filterTapped(_ sender: Any) {
        showHideSearchOrFilterView(isSearchView: true)
    }
    
    @IBAction func showHideFilterTapped(_ sender: Any) {
        dropdown.show()
    }
    
    // MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListViewModel = MovieListViewModel( movieListCollectionView, controller: self)
        setupDropDown()
        self.showProgressView(with: "Fetching Movies")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.movieListViewModel? .fetchMoviesFromApi(filter: MovieFilterType.mostPopular.rawValue)
        }
        self.navigationItem.title = "Most Popular"
    }
    
    deinit {
        movieListViewModel = nil
    }
    
    // MARK: - Other Methods
    func showHideSearchOrFilterView(isSearchView: Bool) {
        if searchViewHeightConstraint.constant == 56 {
            if movieSearchBar.isHidden == false && isSearchView == true {
                movieSearchBar.isHidden = true
            } else if movieSearchBar.isHidden == true && isSearchView == false {
                movieSearchBar.isHidden = false
            } else {
                searchViewHeightConstraint.constant = 0
            }
        } else {
            searchViewHeightConstraint.constant = 56
            movieSearchBar.isHidden = isSearchView
        }
    }
    
    func setupDropDown() {
        dropdown.direction = .any
        dropdown.anchorView = filterLbl
        dropdown.dataSource = ["Most Popular", "Highest Rated"]
        dropdown.selectionAction = { [unowned self] (index, item) in
            self.filterLbl.text = item
            self.navigationItem.title = item
            self.showProgressView(with: "Fetching movies")
            self.movieListViewModel?.currentPage = 1
            if index == 0  {
                self.movieListViewModel? .fetchMoviesFromApi(filter: MovieFilterType.mostPopular.rawValue)
            } else {
                self.movieListViewModel? .fetchMoviesFromApi(filter: MovieFilterType.HighestRated.rawValue)
            }
        }
    }
}
