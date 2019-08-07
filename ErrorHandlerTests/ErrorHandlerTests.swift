//
//  ErrorHandlerTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import ErrorHandler

fileprivate enum HandlerError1: Error {
    case error1
    case error2
    case error3
}

fileprivate enum HandlerError2: Error {
    case error4
}

class ErrorHandlerTests: XCTestCase {
    
    func testItCanHandleSpecificErrors() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .if(error: .isEqual(to: HandlerError1.error1), then: .perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCantHandleSpecificErrorsWhereThereAreNoSpecificHandlers() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .if(error: .isEqual(to: HandlerError1.error1), then: .perform(action: view.customHandler))
        
        XCTAssertFalse(handler.handle(error: HandlerError1.error2, onHandled: view.onHandled))
        
        XCTAssertFalse(view.didHandleResult())
    }
    
    func testItCanFallbackToADefaultHandler() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .if(error: .isEqual(to: HandlerError1.error1), then: .perform(action: { (_, _) in XCTFail("Unexpected Handler Executed"); return false }))
            .else(then: .perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error2, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItPrefersASpecficHandlerAboveTheDefaultHandler() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .if(error: .isEqual(to: HandlerError1.error1), then: .perform(action: view.customHandler))
            .else(then: .perform(action: { (_, _) in XCTFail("Unexpected Handler Executed"); return false }))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItPrefersTheFirstMatchedHandler() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .if(error: .isEqual(to: HandlerError1.error1), then: .perform(action: view.customHandler))
            .if(error: .isEqual(to: HandlerError1.error1), then: .perform(action: { (_, _) in XCTFail("Unexpected Handler Executed"); return false }))
            .else(then: .perform(action: { (_, _) in XCTFail("Unexpected Handler Executed"); return false }))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
        
    }
    

}
