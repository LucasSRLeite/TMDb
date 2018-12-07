//
//  TMDbTests.swift
//  TMDbTests
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import XCTest
@testable import TMDb

class EndpointTests: XCTestCase {

    func testResourcesEndpoint() {
        let upcomingMovies: ResourcesEndpoint = .upcomingMovies
        let genres: ResourcesEndpoint = .genres
        
        XCTAssert(upcomingMovies.completeEndpoint().contains("/movie/upcoming"))
        XCTAssert(upcomingMovies.completeEndpoint(with: ["page": 1]).contains("&page=1"))
        XCTAssert(genres.completeEndpoint().contains("/genre/movie/list"))
    }
    
    func testImagesEndpoint() {
        let path = "a1b2c3d4e5"
        let image: ImagesEndpoint = .image(path: path)
        
        XCTAssert(image.completeEndpoint().contains("/\(path)"))
    }

}
