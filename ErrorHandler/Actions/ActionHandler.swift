//
//  ActionHandler.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public typealias CustomActionHandler = (_ error: Error, _ onHandled: OnErrorHandled) -> Bool

public enum ActionHandler {
    case doNothing
    case present(alert: ErrorAlert)
    case perform(action: CustomActionHandler)
}

extension ActionHandler {
    func perform(on view: ErrorHandlerView, for error: Error, onHandled: OnErrorHandled) -> Bool {
        switch self {
        case .doNothing:
            onHandled?()
            return true
        case .present(let alert):
            let alertController = alert.build(for: error, onHandled: onHandled)
            view.present(alertController, animated: true, completion: nil)
            return true
        case .perform(let action):
            return action(error, onHandled)
        }
    }
}
