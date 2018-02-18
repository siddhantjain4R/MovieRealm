//
//  MovieListViewModel.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class MovieListViewModel: NSObject {
    
    // MARK: - Variable
    var movieArr = [Movie]()
    var totalPages = 0
    var currentPage = 1
    var cellSize: CGSize = CGSize.zero
    var currentFilter = MovieFilterType.mostPopular.rawValue
    var isSearchRequest = false
    var searchString = ""
    var searchMovieArr = [Movie]()
    var searchTotalPages = 0
    var searchCurrentPage = 1
    let bottomRefreshController = UIRefreshControl()
    weak var controller: UIViewController?
    weak var collectionView: UICollectionView?
    
    
    // MARK: - Life Cycle Method
    convenience init(_ collectionView: UICollectionView, controller: UIViewController) {
        self.init()
        self.collectionView = collectionView
        self.controller = controller
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let numberOfCellPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3
        let cellWidth: CGFloat = UIScreen.main.bounds.size.width / numberOfCellPerRow
        cellSize = CGSize(width: cellWidth, height: cellWidth * 1.5)
        bottomRefreshController.triggerVerticalOffset = 50
        bottomRefreshController.addTarget(self, action: #selector(fetchMoreMovie), for: .valueChanged)
        collectionView?.bottomRefreshControl = bottomRefreshController
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.controller?.hideProgressView()
            self?.collectionView?.bottomRefreshControl?.endRefreshing()
            if self?.currentPage == 1 {
                self?.collectionView?.contentOffset = CGPoint(x: 0, y: 0)
            }
            self?.collectionView?.reloadData()
        }
    }
    
    func resetAllSearchVariables(reload: Bool = true) {
        searchString = ""
        searchMovieArr.removeAll()
        searchTotalPages = 0
        searchCurrentPage = 1
        isSearchRequest = false
        if reload {
            reloadCollectionView()
        }
    }
    
    // MARK: - Api and Parse method
    @objc func fetchMoreMovie() {
        if isSearchRequest {
            if searchCurrentPage < searchTotalPages {
                searchCurrentPage += 1
                fetchSearchMatchingMoviesFromApi(pageCount: searchCurrentPage, querry: searchString)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView?.bottomRefreshControl?.endRefreshing()
                }
                
            }
        } else {
            if currentPage < totalPages {
                currentPage += 1
                fetchMoviesFromApi(pageCount: currentPage, filter: currentFilter)
            }else {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView?.bottomRefreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func fetchMoviesFromApi(pageCount: Int = 1, filter: String = MovieFilterType.mostPopular.rawValue) {
        isSearchRequest = false
        currentFilter = filter
        let url = "movie/\(filter)?api_key=\(Constant.apiKeyMovieDB)&language=en-US&page=\(pageCount)"
        NetworkManager.sharedInstance.requestFor(path: url, param: nil, httpMethod: .get, includeHeader: false, success: { [weak self] (response) in
            print(response)
            self?.parseResponseFromMovieListApi(response: response)
            self?.reloadCollectionView()
        }) { (response, error) in
            guard let errorMsg = error else {
                return
            }
            print(errorMsg.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.bottomRefreshControl?.endRefreshing()
                self?.controller?.hideProgressView()
            }
        }
    }
    
    func fetchSearchMatchingMoviesFromApi(pageCount: Int = 1, querry: String) {
        isSearchRequest = true
        searchString = querry
        let url = "search/movie?api_key=\(Constant.apiKeyMovieDB)&language=en-US&query=\(querry)&page=\(pageCount)&include_adult=false"
        NetworkManager.sharedInstance.requestFor(path: url, param: nil, httpMethod: .get, includeHeader: false, success: { [weak self] (response) in
            print(response)
            self?.parseResponseFromMovieListApi(response: response)
            self?.reloadCollectionView()
        }) { (response, error) in
            guard let errorMsg = error else {
                return
            }
            print(errorMsg.localizedDescription)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.bottomRefreshControl?.endRefreshing()
                self?.controller?.hideProgressView()
            }
        }
    }
    
    
    func parseResponseFromMovieListApi(response: [String: Any]) {
        if currentPage == 1, !isSearchRequest {
            movieArr.removeAll()
        } else if searchCurrentPage == 1, isSearchRequest{
            searchMovieArr.removeAll()
        }
        if let resultArr = response["results"] as? [[String: Any]] {
            resultArr.forEach({ (movieData) in
                let movie = Movie(movie: movieData)
                isSearchRequest ? searchMovieArr.append(movie) : movieArr.append(movie)
            })
        }
        if isSearchRequest {
            searchTotalPages = response["total_pages"] as? Int ?? 0
        } else {
            totalPages = response["total_pages"] as? Int ?? 0
        }
    }
}

extension MovieListViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  isSearchRequest ? searchMovieArr.count : movieArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = isSearchRequest ? searchMovieArr[indexPath.item] : movieArr[indexPath.item]
        if movie.posterUrl != "" {
            let imageUrl = Constant.movieDBImageURL + movie.posterUrl
            movieCell.movieImgView.setImage(withUrlString: imageUrl, placeHolderImage: UIImage(named: "poster-placeholder"))
        }
        movieCell.movieTitleLbl.text = movie.movieTitle
        movieCell.movieYearLbl.text = movie.releaseDate
        return movieCell
    }
}

extension MovieListViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = controller?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            detailVC.movie = isSearchRequest ? searchMovieArr[indexPath.row] : movieArr[indexPath.row]
            controller?.navigationController!.pushViewController(detailVC, animated: true)
        }
    }
}

extension MovieListViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
