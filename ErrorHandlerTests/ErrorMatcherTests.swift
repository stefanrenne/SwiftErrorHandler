//
//  ErrorMatcherTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import ErrorHandler

fileprivate enum TestError1: Error {
    case randomError1
    case randomError2
    case randomError3
}

fileprivate enum TestError2: Error {
    case randomError4
}

class ErrorMatcherTests: XCTestCase {
    
    func testItCanMatchError() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.error(TestError1.randomError2), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.error(TestError2.randomError4), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.error(TestError1.randomError1), ActionHandler.custom({ _ in return true }))
        ]
        
        let searchError = TestError1.randomError1
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
            XCTFail("Couldn't find action handler for TestError1.randomError1")
            return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
    }
    
    func testItCanMatchErrorCodes() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.error(TestError1.randomError2), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.error(TestError2.randomError4), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.code(404), .custom({ _ in return false })),
            (ErrorMatcher.code(400), .custom({ _ in return true })),
            (ErrorMatcher.error(TestError1.randomError1), ActionHandler.custom({ _ in return false }))
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
            (ErrorMatcher.error(TestError1.randomError2), ActionHandler.custom({ _ in return false })),
            (ErrorMatcher.code(404), .custom({ _ in return false })),
            (ErrorMatcher.match({ error in
                guard let testError = error as? TestError1, testError == .randomError3 else { return true }
                return true
            }), ActionHandler.custom({ _ in return true })),
        ]
        
        let searchError = TestError1.randomError3
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for TestError1.randomError3")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
        
    }
    
    func testItCanMatchCompleteErrorSuites() throws {
        
        let matchers: [(ErrorMatcher, ActionHandler)] = [
            (ErrorMatcher.match({ $0 is TestError2 }), ActionHandler.custom({ _ in return true })),
        ]
        
        let searchError = TestError2.randomError4
        
        // Find the validator for this error
        guard let actionHandler = matchers.firstAction(for: searchError),
            case ActionHandler.custom(let handler) = actionHandler else {
                XCTFail("Couldn't find action handler for TestError2")
                return
        }
        
        //Validate if this handler returns true
        XCTAssertTrue(handler(nil))
    }

}
