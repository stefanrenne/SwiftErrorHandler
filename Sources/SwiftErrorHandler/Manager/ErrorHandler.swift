//
//  ErrorHandler.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 05/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public typealias OnErrorHandled = (() -> Void)?

open class ErrorHandler {
    
    private let view: ErrorHandlerView
    public init(for errorHandlerView: ErrorHandlerView) {
        self.view = errorHandlerView
    }
    
    private var specificErrorActions = [(ErrorMatcher, ActionHandler)]()
    private var alwaysActions = [ActionHandler]()
    private var defaultActions = [ActionHandler]()
    
    /// adds an error handler for a specific error to the ErrorHandler
    ///
    /// - Parameters:
    ///   - error: The error matcher
    ///   - then action: The action that needs to be performed when the error matches
    /// - Returns: an instance of self (for chaining purposes)
    @discardableResult
    public func on(error errors: ErrorMatcher..., then action: ActionHandler) -> ErrorHandler {
        errors.forEach { (error) in
            specificErrorActions.append((error, action))
        }
        return self
    }
    /// adds a default error handler to the ErrorHandler
    ///
    /// - Parameters:
    ///   - action: the catch-all action that needs to be performed when no other match can be found
    /// - Returns: an instance of self (for chaining purposes)
    @discardableResult
    public func onNoMatch(_ action: ActionHandler) -> ErrorHandler {
        defaultActions.append(action)
        return self
    }
    
    /// adds a error handler that will be executed on every error
    ///
    /// - Parameters:
    ///   - action: The action that always needs to be performed
    /// - Returns: an instance of self (for chaining purposes)
    @discardableResult
    public func always(_ action: ActionHandler) -> ErrorHandler {
        alwaysActions.append(action)
        return self
    }
    
    /// This function is called to handle an error
    ///
    /// - Parameter error: The error that should be handled
    /// - Parameter onCompleted: The optional block that gets executed after the error has been handled successfully
    /// - Returns: an boolean inidication if the error was handled successfully
    @discardableResult
    public func handle(error: Error, onCompleted: OnErrorHandled) -> Bool {
        
        // Check if we have a handler for this error:
        let specificErrorHandlers: [ActionHandler] = specificErrorActions.actions(for: error)
        
        let actions: [ActionHandler]
        if specificErrorHandlers.count > 0 {
            actions = specificErrorHandlers + alwaysActions
        } else {
            actions = defaultActions + alwaysActions
        }
        
        // Chain the on completion actions to trigger the next error handler
        let chainedActions = actions
            .reversed()
            .reduce(into: [() -> Void]()) { (result, action) in
                let previousAction = result.last ?? onCompleted
                let actionRow = action.perform(on: view, for: error, onCompleted: previousAction)
                result.append(actionRow)
            }
            .reversed()
        
        // Perform First Action
        chainedActions.first?()
        
        let handled = chainedActions.count > 0
        
        return handled
    }
    
    /// This convenience function is called to handle an error
    /// The main reason for this function is to handle RxSwift errors inline
    /// Example: subscribe(onError: errorHandler.handle)
    ///
    /// - Parameter error: The error that should be handled
    public func handle(error: Error) {
        handle(error: error, onCompleted: nil)
    }
}
