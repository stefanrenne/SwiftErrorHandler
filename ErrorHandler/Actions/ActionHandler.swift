//
//  ActionHandler.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public typealias CustomActionHandler = (_ onHandled: OnErrorHandled) -> Bool

public enum ActionHandler {
    case none
    case alert(ErrorAlert)
    case custom(CustomActionHandler)
}

extension ActionHandler {
    func perform(on view: ErrorHandlerView, onHandled: OnErrorHandled) -> Bool {
        switch self {
        case .none:
            onHandled?()
            return true
        case .alert(let alert):
            let alertController = alert.build(onHandled: onHandled)
            view.present(alertController, animated: true, completion: nil)
            return true
        case .custom(let action):
            return action(onHandled)
        }
    }
}
