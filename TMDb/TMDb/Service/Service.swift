//
//  Service.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import Foundation

protocol Service {
    
    /// Should handle errors on requests to the API
    var errorHandler: ErrorHandler? { set get }
}
