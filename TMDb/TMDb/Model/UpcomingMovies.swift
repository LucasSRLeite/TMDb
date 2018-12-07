//
//  UpcomingMovies.swift
//  TMDb
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

struct UpcomingMovies: Codable {
    var results: [Movie]
    var page: Int
    var totalPages: Int
}

extension UpcomingMovies {
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
    }
}
