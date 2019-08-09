//
//  ErrorMatcherTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import SwiftErrorHandler

class ErrorMatcherTests: XCTestCase {
    
    func testItCanMatchError() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.type(MatcherError1.error2), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.type(MatcherError2.error4), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.type(MatcherError1.error1), ActionHandler.perform(action: correctHandlerExecuted))
        ]
        
        let searchError = MatcherError1.error1
        
        // Find the validator for this error
        let actionHandlers = matchers.actions(for: searchError)
        guard actionHandlers.count == 1,
            let actionHandler = actionHandlers.first,
            case ActionHandler.perform(action: let handler) = actionHandler else {
            XCTFail("Couldn't find action handler for MatcherError1.error1")
            return
        }
        
        // Validate if the correct handler is executed
        handler(searchError, nil)
    }
    
    func testItCanMatchErrorCodes() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.type(MatcherError1.error2), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.type(MatcherError2.error4), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.code(404), .perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.code(400), .perform(action: correctHandlerExecuted)),
            (ErrorMatcher.type(MatcherError1.error1), ActionHandler.perform(action: unexpectedHandlerExecuted))
        ]
        
        let searchError = NSError(domain: "damain", code: 400, userInfo: ["data": "value"])
        
        // Find the validator for this error
        let actionHandlers = matchers.actions(for: searchError)
        guard actionHandlers.count == 1,
            let actionHandler = actionHandlers.first,
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for error code 400")
                return
        }
        
        // Validate if the correct handler is executed
        handler(searchError, nil)
        
    }
    
    func testItCanMatchErrorDomains() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.type(MatcherError1.error2), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.type(MatcherError2.error4), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.domain("remote"), .perform(action: correctHandlerExecuted)),
            (ErrorMatcher.code(400), .perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.type(MatcherError1.error1), ActionHandler.perform(action: unexpectedHandlerExecuted))
        ]
        
        let searchError = NSError(domain: "remote", code: 401, userInfo: ["data": "value"])
        
        // Find the validator for this error
        let actionHandlers = matchers.actions(for: searchError)
        guard actionHandlers.count == 1,
            let actionHandler = actionHandlers.first,
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for error code 400")
                return
        }
        
        // Validate if the correct handler is executed
        handler(searchError, nil)
        
    }
    
    func testItCanMatchWithBlock() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.type(MatcherError1.error2), ActionHandler.perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.code(404), .perform(action: unexpectedHandlerExecuted)),
            (ErrorMatcher.match({ error in
                guard let testError = error as? MatcherError1, testError == .error3 else { return true }
                return true
            }), ActionHandler.perform(action: correctHandlerExecuted))
        ]
        
        let searchError = MatcherError1.error3
        
        // Find the validator for this error
        let actionHandlers = matchers.actions(for: searchError)
        guard actionHandlers.count == 1,
            let actionHandler = actionHandlers.first,
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for MatcherError1.error3")
                return
        }
        
        // Validate if the correct handler is executed
        handler(searchError, nil)
        
    }
    
    func testItCanMatchCompleteErrorSuites() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.match({ $0 is MatcherError2 }), ActionHandler.perform(action: correctHandlerExecuted))
        ]
        
        let searchError = MatcherError2.error4
        
        // Find the validator for this error
        let actionHandlers = matchers.actions(for: searchError)
        guard actionHandlers.count == 1,
            let actionHandler = actionHandlers.first,
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for MatcherError2")
                return
        }
        
        // Validate if the correct handler is executed
        handler(searchError, nil)
    }
}

extension ErrorMatcherTests {
    
    func correctHandlerExecuted(for error: Error, onHandled: OnErrorHandled) { }
    
    func unexpectedHandlerExecuted(for error: Error, onHandled: OnErrorHandled) {
        XCTFail("Unexpected Handler Executed")
    }
    
    private enum MatcherError1: Error {
        case error1
        case error2
        case error3
    }
    
    private enum MatcherError2: Error {
        case error4
    }
}

extension ErrorMatcherTests {
    
    static var allTests = [
        ("testItCanMatchError", testItCanMatchError),
        ("testItCanMatchErrorCodes", testItCanMatchErrorCodes),
        ("testItCanMatchErrorDomains", testItCanMatchErrorDomains),
        ("testItCanMatchWithBlock", testItCanMatchWithBlock),
        ("testItCanMatchCompleteErrorSuites", testItCanMatchCompleteErrorSuites)
    ]
}
