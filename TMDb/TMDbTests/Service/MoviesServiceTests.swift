//
//  MoviesServiceTests.swift
//  TMDbTests
//
//  Created by Lucas dos Santos on 07/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import XCTest
@testable import TMDb

class MoviesServiceTests: XCTestCase {

    var movieWithPaths: Movie {
        return Movie(id: 283552, title: "The Light Between Oceans", posterPath: "/pEFRzXtLmxYNjGd0XqJDHPDFKB2.jpg", backdropPath: "/2Ah63TIvVmZM3hzUwR5hXFg2LEk.jpg", genreIDs: [18], releaseDate: "2016-09-02", overview: "A lighthouse keeper and his wife living off the coast of Western Australia raise a baby they rescue from an adrift rowboat.")
    }
    
    var service: MoviesService!
    
    override func setUp() {
        super.setUp()
        
        service = MoviesService()
    }

    override func tearDown() {
        service = nil
        
        super.tearDown()
    }
    
    func testRequestUpcomingMovies() {
        let expectation = XCTestExpectation(description: "Did load list of upcoming movies")
        var expectedMovies = [Movie]()
        
        service.requestUpcomingMovies { movies in
            expectedMovies = movies
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(expectedMovies.count > 0)
    }
    
    func testRequestBackdropImage() {
        let expectation = XCTestExpectation(description: "Did load backdrop image for movie")
        
        service.requestBackdropImage(for: movieWithPaths) { data in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRequestPosterImage() {
        let expectation = XCTestExpectation(description: "Did load poster image for movie")
        
        service.requestPosterImage(for: movieWithPaths) { data in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }

}
