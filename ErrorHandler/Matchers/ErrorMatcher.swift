//
//  ErrorMatcher.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public enum ErrorMatcher {
    case error(Error)
    case code(Int)
    case match((Error) -> Bool)
}

extension Array where Element == (ErrorMatcher, ActionHandler) {
    func firstAction(for error: Error) -> ActionHandler? {
        for (onError, action) in self {
            switch onError {
            case .code(let codeMatched) where codeMatched == error._code:
                return action
            case .error(let errorMatcher) where errorMatcher.reflectedString == error.reflectedString:
                return action
            case .match(let errorMatcher) where errorMatcher(error):
                return action
            default:
                continue
            }
        }
        return nil
    }
}
