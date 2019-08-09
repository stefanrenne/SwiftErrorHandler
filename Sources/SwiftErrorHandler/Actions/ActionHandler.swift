//
//  ActionHandler.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public typealias CustomActionHandler = (_ error: Error, _ onCompleted: OnErrorHandled) -> Void

public enum ActionHandler {
    case doNothing
    case present(alert: ErrorAlert)
    case perform(action: CustomActionHandler)
}

extension ActionHandler {
    func perform(on view: ErrorHandlerView, for error: Error, onCompleted: OnErrorHandled) -> () -> Void {
        switch self {
        case .doNothing:
            return { onCompleted?() }
        case .present(let alert):
            let alertController = alert.build(for: error, onCompleted: onCompleted)
            return { view.present(alert: alertController) }
        case .perform(let action):
            return { action(error, onCompleted) }
        }
    }
}
