//
//  GenresService.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

/// Handles requests to genre based endpoints on IMDb API
struct GenresService: Service {
    var errorHandler: ErrorHandler?
    
    /// Requests for list of genres on IMDb API
    ///
    /// - Parameter completion: Closure to be called on success
    func requestGenresList(_ completion: @escaping ([Genre]) -> Void) {
        let endpoint: ResourcesEndpoint = .genres
        
        guard let url = URL(string: endpoint.completeEndpoint()) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                self.errorHandler?.handleErrorMessage(error?.localizedDescription)
                return
            }
            
            do {
                let genres = try JSONDecoder().decode(Genres.self, from: data)
                completion(genres.genres)
            } catch {
                print("Error")
            }
        }.resume()
    }
}
