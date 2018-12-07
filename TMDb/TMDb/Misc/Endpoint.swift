//
//  Endpoint.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    /// Base URL for requests
    var apiURL: String { get }
    
    /// Complete endpoint for determined resource
    ///
    /// - Parameter parameters: Dictionary for parameters on URL
    /// - Returns: Endpoint ready to be requested
    func completeEndpoint(with parameters: [String: Any]?) -> String
}

/// Handles endpoints for resources provided by IMDb API
enum ResourcesEndpoint: String {
    case upcomingMovies = "movie/upcoming"
    case genres = "genre/movie/list"
}

extension ResourcesEndpoint: Endpoint {
    var apiKey: String {
        return Config.apiKey.getValue() ?? ""
    }
    
    var apiURL: String {
        return Config.apiURL.getValue() ?? ""
    }
    
    func completeEndpoint(with parameters: [String : Any]? = nil) -> String {
        var base = "\(apiURL)\(rawValue)?api_key=\(apiKey)"
        parameters?.forEach { base += "&\($0)=\($1)" }
        return base
    }
}

/// Handles images with paths provided by IMDb API
enum ImagesEndpoint: Endpoint {
    case image(path: String)
    
    var apiURL: String {
        return Config.imagesURL.getValue() ?? ""
    }
    
    func completeEndpoint(with parameters: [String : Any]? = nil) -> String {
        switch self {
        case .image(let path):
            return "\(apiURL)\(path)"
        }
    }
}
