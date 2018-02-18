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
        showHideSearchOrFilterView(isFilterView: false)
    }
    @IBAction func filterTapped(_ sender: Any) {
        showHideSearchOrFilterView(isFilterView: true)
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.title = "Most Popular"
    }
    
    deinit {
        movieListViewModel = nil
    }
    
    // MARK: - Other Methods
    func showHideSearchOrFilterView(isFilterView: Bool) {
        movieSearchBar.resignFirstResponder()
        if searchViewHeightConstraint.constant == 56 {
            if movieSearchBar.isHidden == false && isFilterView == true {
                movieSearchBar.isHidden = true
            } else if movieSearchBar.isHidden == true && isFilterView == false {
                movieSearchBar.isHidden = false
            } else {
                searchViewHeightConstraint.constant = 0
            }
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            searchViewHeightConstraint.constant = 56
            movieSearchBar.isHidden = isFilterView
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    func setupDropDown() {
        dropdown.direction = .bottom
        dropdown.anchorView = filterLbl
        dropdown.bottomOffset = CGPoint(x: 0, y: 56)
        dropdown.dataSource = ["Most Popular", "Top Rated"]
        dropdown.selectionAction = { [unowned self] (index, item) in
            self.filterLbl.text = item
            self.navigationItem.title = item
            self.showProgressView(with: "Fetching movies")
            self.movieListViewModel?.currentPage = 1
            self.showHideSearchOrFilterView(isFilterView: true)
            if index == 0  {
                self.movieListViewModel? .fetchMoviesFromApi(filter: MovieFilterType.mostPopular.rawValue)
            } else {
                self.movieListViewModel? .fetchMoviesFromApi(filter: MovieFilterType.HighestRated.rawValue)
            }
        }
    }
}

extension MovieListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        movieListViewModel?.resetAllSearchVariables()
        showHideSearchOrFilterView(isFilterView: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            view.endEditing(true)
            movieListViewModel?.resetAllSearchVariables(reload: false)
            self.showProgressView(with: "Searching movies")
            movieListViewModel?.fetchSearchMatchingMoviesFromApi(querry: searchBar.text ?? "")
        }
    }
}
