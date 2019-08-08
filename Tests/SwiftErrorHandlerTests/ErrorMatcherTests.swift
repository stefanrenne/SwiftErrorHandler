//
//  ErrorMatcherTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import SwiftErrorHandler

fileprivate enum MatcherError1: Error {
    case error1
    case error2
    case error3
}

fileprivate enum MatcherError2: Error {
    case error4
}

class ErrorMatcherTests: XCTestCase {
    
    func testItCanMatchError() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.isEqual(to: MatcherError1.error2), ActionHandler.perform(action: { (_, _) in return false })),
            (ErrorMatcher.isEqual(to: MatcherError2.error4), ActionHandler.perform(action: { (_, _) in return false })),
            (ErrorMatcher.isEqual(to: MatcherError1.error1), ActionHandler.perform(action: { (_, _) in return true }))
        ]
        
        let searchError = MatcherError1.error1
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.perform(action: let handler) = actionHandler else {
            XCTFail("Couldn't find action handler for MatcherError1.error1")
            return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(searchError, nil))
    }
    
    func testItCanMatchErrorCodes() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.isEqual(to: MatcherError1.error2), ActionHandler.perform(action: { (_, _) in return false })),
            (ErrorMatcher.isEqual(to: MatcherError2.error4), ActionHandler.perform(action: { (_, _) in return false })),
            (ErrorMatcher.has(code: 404), .perform(action: { (_, _) in return false })),
            (ErrorMatcher.has(code: 400), .perform(action: { (_, _) in return true })),
            (ErrorMatcher.isEqual(to: MatcherError1.error1), ActionHandler.perform(action: { (_, _) in return false }))
        ]
        
        let searchError = NSError(domain: "damain", code: 400, userInfo: ["data": "value"])
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for error code 400")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(searchError, nil))
        
    }
    
    func testItCanMatchWithBlock() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.isEqual(to: MatcherError1.error2), ActionHandler.perform(action: { (_, _) in return false })),
            (ErrorMatcher.has(code: 404), .perform(action: { (_, _) in return false })),
            (ErrorMatcher.matches({ error in
                guard let testError = error as? MatcherError1, testError == .error3 else { return true }
                return true
            }), ActionHandler.perform(action: { (_, _) in return true })),
        ]
        
        let searchError = MatcherError1.error3
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for MatcherError1.error3")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(searchError, nil))
        
    }
    
    func testItCanMatchCompleteErrorSuites() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.matches({ $0 is MatcherError2 }), ActionHandler.perform(action: { (_, _) in return true })),
        ]
        
        let searchError = MatcherError2.error4
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.perform(action: let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for MatcherError2")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(searchError, nil))
    }
}

extension ErrorMatcherTests {
    
    static var allTests = [
        ("testItCanMatchError", testItCanMatchError),
        ("testItCanMatchErrorCodes", testItCanMatchErrorCodes),
        ("testItCanMatchWithBlock", testItCanMatchWithBlock),
        ("testItCanMatchCompleteErrorSuites", testItCanMatchCompleteErrorSuites)
    ]
}
