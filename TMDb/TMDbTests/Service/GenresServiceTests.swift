//
//  GenresServiceTests.swift
//  TMDbTests
//
//  Created by Lucas dos Santos on 07/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import XCTest
@testable import TMDb

class GenresServiceTests: XCTestCase {

    var service: GenresService!
    
    override func setUp() {
        super.setUp()
        
        service = GenresService()
    }

    override func tearDown() {
        service = nil
        
        super.tearDown()
    }

    func testRequestGenresList() {
        let expectation = XCTestExpectation(description: "Did load genres list")
        var expectedGenres = [Genre]()
        
        service.requestGenresList { genres in
            expectedGenres = genres
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(expectedGenres.count > 0)
    }

}
