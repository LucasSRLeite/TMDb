//
//  TMDbUITests.swift
//  TMDbUITests
//
//  Created by Lucas dos Santos on 05/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import XCTest

class TMDbUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        let cells = app.cells
        let cellsCountPredicate = NSPredicate(format: "count > 0")
        
        expectation(for: cellsCountPredicate, evaluatedWith: cells, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDynamicUpdateUpcomingMovies() {
        let initialCount = app.cells.count
        
        for _ in (0...5) {
            app.tables.firstMatch.swipeUp()
        }
        
        XCTAssert(app.cells.count > initialCount)
    }
    
    func testDetailUpcomingMovie() {
        app.cells.firstMatch.swipeUp()
        
        let count = UInt32(app.cells.count)
        let randomIndex = Int(arc4random_uniform(count))
        
        let currentCell = app.cells.element(boundBy: randomIndex)
        let title = currentCell.staticTexts.element(matching: .staticText, identifier: "Title").label
        currentCell.tap()
        
        XCTAssert(app.navigationBars[title].exists)
    }
    
    func testSearchAndDetailMovie() {
        let searchText = "Aq"
        
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText(searchText)
        
        let firstCell = app.cells.firstMatch
        let title = firstCell.staticTexts.element(matching: .staticText, identifier: "Title").label
        firstCell.tap()
        
        XCTAssert(title.contains(searchText))
        XCTAssert(app.navigationBars[title].exists)
    }
    
}
