//
//  MovieDetailViewModel.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 18/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

@objc protocol MovieDetailDelegate {
    func loadVideo()
}

class MovieDetailViewModel: NSObject {
    
    var movieDetail: Movie?
    weak var controller: UIViewController?
    weak var delegate: MovieDetailDelegate?

    // MARK: - Life Cycle Method
    convenience init(_ movie: Movie, controller: UIViewController) {
        self.init()
        movieDetail = movie
        self.controller = controller
    }
    
    func fetchMovieVideoUrlFromApi() {
        let url = "movie/\(movieDetail?.id ?? 0)/videos?api_key=\(Constant.apiKeyMovieDB)&language=en-US"
        NetworkManager.sharedInstance.requestFor(path: url, param: nil, httpMethod: .get, includeHeader: false, success: { [weak self] (response) in
            print(response)
            self?.parseVideoUrl(response: response)
            self?.controller?.hideProgressView()
        }) { (response, error) in
            self.controller?.hideProgressView()
            guard let errorMsg = error else {
                return
            }
            print(errorMsg.localizedDescription)
            self.controller?.showAlert(title: "Something went wrong", message: "", buttons: ["Okay"], actions: nil)
        }
    }
    
    func parseVideoUrl(response: [String: Any]) {
        if let resultArr = response["results"] as? [[String: Any]], resultArr.count > 0 {
            let data = resultArr[0]
            movieDetail?.videoUrl = data["key"] as? String ?? ""
            delegate?.loadVideo()
        }
    }
}
