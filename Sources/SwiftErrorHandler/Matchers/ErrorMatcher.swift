//
//  ErrorMatcher.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public enum ErrorMatcher {
    case isEqual(to: Error)
    case has(code: Int)
    case matches((Error) -> Bool)
}

extension Array where Element == (ErrorMatcher, ActionHandler) {
    func firstAction(for error: Error) -> ActionHandler? {
        for (onError, action) in self {
            switch onError {
            case .has(let code) where code == error._code:
                return action
            case .isEqual(let matcher) where matcher.reflectedString == error.reflectedString:
                return action
            case .matches(let matcher) where matcher(error):
                return action
            default:
                continue
            }
        }
        return nil
    }
}
