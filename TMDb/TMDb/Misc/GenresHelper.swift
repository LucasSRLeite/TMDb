//
//  GenreHelper.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

/// Protocol to help handling genres list loading
protocol GenresHelperDelegate {
    
    /// Called when list of genres has finished loading
    func didFinishLoadingGenres()
}

/// Requests and provides genres list
class GenresHelper {
    let genresService = GenresService()
    var delegate: GenresHelperDelegate?
    
    var genres = [Int:String]()
    
    init() {
        genresService.requestGenresList { [weak self] genres in
            genres.forEach { self?.genres[$0.id] = $0.name }
            self?.delegate?.didFinishLoadingGenres()
        }
    }
    
    /// Genre for determined id
    ///
    /// - Parameter id: Identifier for genre
    /// - Returns: String value for requested id
    func genre(for id: Int) -> String? {
        return genres[id]
    }
    
    /// Tranforms and formats movie genres on a single String
    ///
    /// - Parameter ids: Array of genre identifiers
    /// - Returns: Formatted String of genres
    func formattedGenres(for ids: [Int]) -> String {
        let array = ids.compactMap { genre(for: $0) }
        return array.joined(separator: ", ")
    }
}
