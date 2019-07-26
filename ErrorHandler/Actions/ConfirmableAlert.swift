//
//  ConfirmableAlert.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public struct ConfirmableAlert: ErrorAlert {
    let title: String
    let message: String?
    let confirmTitle: String
    let confirmAction: (() -> Void)?
    
    public init(title: String, message: String? = nil, confirmTitle: String, confirmAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.confirmAction = confirmAction
    }
    
    public func build(onHandled: OnErrorHandled) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: confirmTitle, style: .default) { _ in
            self.confirmAction?()
            onHandled?()
        }
        controller.addAction(confirmButton)
        return controller
    }
}
