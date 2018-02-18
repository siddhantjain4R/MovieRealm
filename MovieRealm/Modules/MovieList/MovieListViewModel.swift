//
//  MovieListViewModel.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

class MovieListViewModel: NSObject {

    var movieArr = [Movie]()
    var totalPages = 0

    func fetchMoviesFromApi(pageCount: Int = 1, filter: String = "now_playing") {
        let url = "\(filter)?api_key=\(Constant.apiKeyMovieDB)&language=en-US&page=\(pageCount)"
        NetworkManager.sharedInstance.requestFor(path: url, param: nil, httpMethod: .get, includeHeader: false, success: { (response) in
            print(response)
            self.parseResponseFromMovieListApi(response: response)
        }) { (response, error) in
            guard let errorMsg = error else {
                return
            }
            print(errorMsg.localizedDescription)
        }
    }
    
    func parseResponseFromMovieListApi(response: [String: Any]) {
        if let resultArr = response["results"] as? [[String: Any]] {
            resultArr.forEach({ (movieData) in
                let movie = Movie(movie: movieData)
                movieArr.append(movie)
            })
        }
        totalPages = response["total_pages"] as? Int ?? 0
        
    }
}
