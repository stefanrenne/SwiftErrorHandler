//
//  ErrorHandlerTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import SwiftErrorHandler

class ErrorHandlerTests: XCTestCase {
    
    func testItCanHandleSpecificErrors() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedOnHandled: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCantHandleSpecificErrorsWhereThereAreNoSpecificHandlers() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedOnHandled: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
        
        XCTAssertFalse(handler.handle(error: HandlerError1.error2, onHandled: view.onHandled))
        
        XCTAssertFalse(view.didHandleResult())
    }
    
    func testItCanFallbackToADefaultHandler() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedOnHandled: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.unexpectedHandlerExecuted))
            .onNoMatch(.perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error2, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItPrefersASpecficHandlerAboveTheDefaultHandler() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedOnHandled: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.unexpectedHandlerExecuted))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCanExecuteMultupleMatches() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 2, numberExpectedOnHandled: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.unexpectedHandlerExecuted))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCanHaveHandlersThatAlwaysGetExecuted() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 2, numberExpectedOnHandled: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.unexpectedHandlerExecuted))
            .always(.perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCanHaveMultipleAlwaysHandlers() {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 3, numberExpectedOnHandled: 0)
        let handler = ErrorHandler(for: view)
            .always(.perform(action: view.customHandler))
            .always(.perform(action: view.customHandler))
            .always(.perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: nil))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCanHaveMultipleDefaultHandlers() {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 3, numberExpectedOnHandled: 0)
        let handler = ErrorHandler(for: view)
            .onNoMatch(.perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: nil))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
}

extension ErrorHandlerTests {
    private enum HandlerError1: Error {
        case error1
        case error2
        case error3
    }
    
    private enum HandlerError2: Error {
        case error4
    }

}

extension ErrorHandlerTests {
    
    static var allTests = [
        ("testItCanHandleSpecificErrors", testItCanHandleSpecificErrors),
        ("testItCantHandleSpecificErrorsWhereThereAreNoSpecificHandlers", testItCantHandleSpecificErrorsWhereThereAreNoSpecificHandlers),
        ("testItCanFallbackToADefaultHandler", testItCanFallbackToADefaultHandler),
        ("testItPrefersASpecficHandlerAboveTheDefaultHandler", testItPrefersASpecficHandlerAboveTheDefaultHandler),
        ("testItCanExecuteMultupleMatches", testItCanExecuteMultupleMatches),
        ("testItCanHaveHandlersThatAlwaysGetExecuted", testItCanHaveHandlersThatAlwaysGetExecuted),
        ("testItCanHaveMultipleAlwaysHandlers", testItCanHaveMultipleAlwaysHandlers),
        ("testItCanHaveMultipleDefaultHandlers", testItCanHaveMultipleDefaultHandlers)
    ]
}
