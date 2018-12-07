//
//  Movie.swift
//  TMDb
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var genreIDs: [Int]
    var releaseDate: String
    var overview: String
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case releaseDate = "release_date"
    }
}
