//
//  APIError.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

struct APIError: Codable {
    var code: Int
    var message: String
}

extension APIError {
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
    }
}
