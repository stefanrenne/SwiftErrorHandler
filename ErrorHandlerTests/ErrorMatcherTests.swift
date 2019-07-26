//
//  ErrorMatcherTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import ErrorHandler

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
            (ErrorMatcher.error(MatcherError1.error2), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.error(MatcherError2.error4), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.error(MatcherError1.error1), ActionHandler.custom({ _ in return true }))
        ]
        
        let searchError = MatcherError1.error1
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
            XCTFail("Couldn't find action handler for MatcherError1.error1")
            return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
    }
    
    func testItCanMatchErrorCodes() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.error(MatcherError1.error2), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.error(MatcherError2.error4), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.code(404), .custom({ _ in return false })),
            (ErrorMatcher.code(400), .custom({ _ in return true })),
            (ErrorMatcher.error(MatcherError1.error1), ActionHandler.custom({ _ in return false }))
        ]
        
        let searchError = NSError(domain: "damain", code: 400, userInfo: ["data": "value"])
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for error code 400")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
        
    }
    
    func testItCanMatchWithBlock() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.error(MatcherError1.error2), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.code(404), .custom({ _ in return false })),
            (ErrorMatcher.match({ error in
                guard let testError = error as? MatcherError1, testError == .error3 else { return true }
                return true
            }), ActionHandler.custom({ _ in return true })),
        ]
        
        let searchError = MatcherError1.error3
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for MatcherError1.error3")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
        
    }
    
    func testItCanMatchCompleteErrorSuites() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.match({ $0 is MatcherError2 }), ActionHandler.custom({ _ in return true })),
        ]
        
        let searchError = MatcherError2.error4
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for MatcherError2")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
    }

}
