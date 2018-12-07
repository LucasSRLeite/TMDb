//
//  GenreHelperTests.swift
//  TMDbTests
//
//  Created by Lucas dos Santos on 07/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import XCTest
@testable import TMDb

class GenresHelperTests: XCTestCase {

    var genresHelper: GenresHelper!
    var genresLoadingExpectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        genresLoadingExpectation = XCTestExpectation(description: "Genres list has loaded")
        genresHelper = GenresHelper()
        genresHelper.delegate = self
    }
    
    override func tearDown() {
        genresHelper = nil
        
        super.tearDown()
    }

    func testGenresListLoad() {
        wait(for: [genresLoadingExpectation], timeout: 5)
        
        XCTAssert(self.genresHelper.genres.count > 0)
        XCTAssert(self.genresHelper.genre(for: 28) == "Action")
        XCTAssert(self.genresHelper.formattedGenres(for: [12, 16, 18]) == "Adventure, Animation, Drama")
    }
    
}

extension GenresHelperTests: GenresHelperDelegate {
    func didFinishLoadingGenres() {
        genresLoadingExpectation.fulfill()
    }
}
