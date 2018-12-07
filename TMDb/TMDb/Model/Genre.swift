//
//  Genre.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

struct Genre: Codable {
    var id: Int
    var name: String
}

struct Genres: Codable {
    var genres: [Genre]
}
