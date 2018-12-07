//
//  ConfigTests.swift
//  TMDbTests
//
//  Created by Lucas dos Santos on 07/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import XCTest
@testable import TMDb

class ConfigTests: XCTestCase {
    
    func testValuesForConfig() {
        let apiKey: Config = .apiKey
        let apiURL: Config = .apiURL
        let imagesURL: Config = .imagesURL
        
        XCTAssert(apiKey.getValue() != nil)
        XCTAssert(apiURL.getValue() != nil)
        XCTAssert(imagesURL.getValue() != nil)
    }
    
}
