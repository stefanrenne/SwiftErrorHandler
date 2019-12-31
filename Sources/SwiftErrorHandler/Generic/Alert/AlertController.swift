//
//  AlertController.swift
//  SwiftErrorHandler
//
//  Created by Stefan Renne on 31/12/2019.
//

import Foundation

public enum AlertControllerStyle {

    case actionSheet

    case alert
}

public class AlertController {

    internal let title: String?

    internal let message: String?

    internal let preferredStyle: AlertControllerStyle
    
    internal var actions = [AlertAction]()

    public init(title: String?, message: String?, preferredStyle: AlertControllerStyle) {
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
    }

    public func addAction(_ action: AlertAction) {
        actions.append(action)
    }
}
