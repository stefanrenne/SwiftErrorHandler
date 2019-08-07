//
//  RejectableAlert.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public struct RejectableAlert: ErrorAlert {
    let title: String
    let message: String?
    let confirmTitle: String
    let confirmAction: ((Error) -> Void)?
    let rejectTitle: String
    let rejectAction: ((Error) -> Void)?
    
    public init(title: String, message: String? = nil, confirmTitle: String, rejectTitle: String, confirmAction: ((Error) -> Void)? = nil, rejectAction: ((Error) -> Void)? = nil) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.rejectTitle = rejectTitle
        self.confirmAction = confirmAction
        self.rejectAction = rejectAction
    }
    
    public func build(for error: Error, onHandled: OnErrorHandled) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: confirmTitle, style: .default) { _ in
            self.confirmAction?(error)
            onHandled?()
        }
        let rejectButton = UIAlertAction(title: rejectTitle, style: .cancel) { _ in
            self.rejectAction?(error)
            onHandled?()
        }
        
        controller.addAction(confirmButton)
        controller.addAction(rejectButton)
        return controller
    }
}
