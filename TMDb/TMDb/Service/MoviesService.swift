//
//  MoviesService.swift
//  TMDb
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation
import Cache

/// Handles requests to movie based endpoints on IMDb API
struct MoviesService: Service {
    var errorHandler: ErrorHandler?
    
    /// Requests for upcoming movies on IMDb API
    ///
    /// - Parameters:
    ///   - page: Page to be requested
    ///   - completion: Closure to be called on success
    func requestUpcomingMovies(at page: Int = 1, _ completion: @escaping ([Movie]) -> Void) {
        let endpoint: ResourcesEndpoint = .upcomingMovies
        
        guard let url = URL(string: endpoint.completeEndpoint(with: ["page": page])) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                self.errorHandler?.handleErrorMessage(error?.localizedDescription)
                return
            }
            
            do {
                let upcomingMovies = try JSONDecoder().decode(UpcomingMovies.self, from: data)
                completion(upcomingMovies.results)
            } catch {
                let apiError = try? JSONDecoder().decode(APIError.self, from: data)
                self.errorHandler?.handleErrorMessage(apiError?.message)
                print("Error: \(error)")
            }
        }.resume()
    }
    
    /// Requests for backdrop image for determined movie
    ///
    /// - Parameters:
    ///   - movie: Movie to request image for
    ///   - completion: Closure to be called on success
    func requestBackdropImage(for movie: Movie, _ completion: @escaping (Data) -> Void) {
        guard let path = movie.backdropPath else { return }
        
        requestImage(at: path, completion)
    }
    
    /// Requests for poster image for determined movie
    ///
    /// - Parameters:
    ///   - movie: Movie to request poster image for
    ///   - completion: Closure to be called on succes
    func requestPosterImage(for movie: Movie, _ completion: @escaping (Data) -> Void) {
        guard let path = movie.posterPath else { return }
        
        requestImage(at: path, completion)
    }
    
    /// Requests for image based on informed path
    ///
    /// - Parameters:
    ///   - path: Path for image provided by IMDb API
    ///   - completion: Closure to be called on success
    private func requestImage(at path: String, _ completion: @escaping (Data) -> Void) {
        let endpoint: ImagesEndpoint = .image(path: path)
        
        guard let url = URL(string: endpoint.completeEndpoint()) else { return }
        
        if let cachedImageData = (try? ImageCacheHandler.shared.storage?.object(forKey: path)).flatMap({ $0 }) {
            completion(cachedImageData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                self.errorHandler?.handleErrorMessage(error?.localizedDescription)
                return
            }
            
            try? ImageCacheHandler.shared.storage?.setObject(data, forKey: path)
            completion(data)
        }.resume()
    }
}
