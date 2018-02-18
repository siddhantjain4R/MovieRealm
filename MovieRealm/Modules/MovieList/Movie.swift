//
//  Movie.swift
//  MovieRealm
//
//  Created by Siddhant Jain on 17/02/18.
//  Copyright © 2018 Siddhant. All rights reserved.
//

import UIKit

class Movie: NSObject {
    
    var id = 0
    var movieTitle = ""
    var movieOverview = ""
    var releaseDate = ""
    var rating = 0.0
    var posterUrl = ""
    var isAdult = false
    
    convenience init(movie data: [String: Any]) {
        self.init()
        
        id = data["id"] as? Int ?? 0
        movieTitle = data["title"] as? String ?? "No title"
        movieOverview = data["overview"] as? String ?? "No overview available."
        releaseDate = data["release_date"] as? String ?? "Coming Soon"
        rating = data["vote_average"] as? Double ?? 0.0
        posterUrl = data["poster_path"] as? String ?? ""
        isAdult = false
    }
}
