//
//  ConfirmableAlert.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation
import UIKit

public struct ConfirmableAlert: ErrorAlert {
    let title: String
    let message: String?
    let confirmTitle: String
    let confirmAction: ((Error) -> Void)?
    
    public init(title: String, message: String? = nil, confirmTitle: String, confirmAction: ((Error) -> Void)? = nil) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.confirmAction = confirmAction
    }
    
    public func build(for error: Error, onCompleted: OnErrorHandled) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: confirmTitle, style: .default) { _ in
            self.confirmAction?(error)
            onCompleted?()
        }
        controller.addAction(confirmButton)
        return controller
    }
}
