//
//  ErrorMatcher.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public enum ErrorMatcher {
    case type(Error)
    case code(Int)
    case match((Error) -> Bool)
}

extension Array where Element == (ErrorMatcher, ActionHandler) {
    func actions(for error: Error) -> [ActionHandler] {
        return compactMap { (onError, action) -> ActionHandler? in
            switch onError {
            case .code(let code) where code == error._code:
                return action
            case .type(let matcher) where matcher.reflectedString == error.reflectedString:
                return action
            case .match(let matcher) where matcher(error):
                return action
            default:
                return nil
            }
        }
    }
}
