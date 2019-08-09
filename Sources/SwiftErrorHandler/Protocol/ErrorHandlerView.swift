//
//  ErrorHandlerView.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import UIKit

public protocol ErrorHandlerView {
    func present(alert: UIAlertController)
}

extension UIViewController: ErrorHandlerView {
    public func present(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}
