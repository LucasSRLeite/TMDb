//
//  ErrorHandler.swift
//  TMDb
//
//  Created by Lucas dos Santos on 06/12/18.
//  Copyright © 2018 LL. All rights reserved.
//

import UIKit

/// Protocol to handle errors on API requests
protocol ErrorHandler {
    func handleErrorMessage(_ String: String?)
    func updateAfterError()
}

extension ErrorHandler where Self: UIViewController {
    func handleErrorMessage(_ message: String?) {
        let message = message ?? "Unknown error"
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.updateAfterError()
        }
        
        alertController.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
