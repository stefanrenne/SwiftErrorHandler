//
//  AlertAction.swift
//  SwiftErrorHandler
//
//  Created by Stefan Renne on 31/12/2019.
//

import Foundation

public enum AlertActionStyle {

    case `default`

    case cancel
}

public class AlertAction {

    internal let title: String?

    internal let style: AlertActionStyle
    
    internal let handler: ((AlertAction) -> Void)?

    public init(title: String?, style: AlertActionStyle, handler: ((AlertAction) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
