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
            .on(.error(HandlerError1.error1), do: .custom(view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCantHandleSpecificErrorsWhereThereAreNoSpecificHandlers() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .on(.error(HandlerError1.error1), do: .custom(view.customHandler))
        
        XCTAssertFalse(handler.handle(error: HandlerError1.error2, onHandled: view.onHandled))
        
        XCTAssertFalse(view.didHandleResult())
    }
    
    func testItCanFallbackToADefaultHandler() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .on(.error(HandlerError1.error1), do: .custom({ _ in XCTFail("Unexpected Handler Executed"); return false }))
            .else(do: .custom(view.customHandler))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error2, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItPrefersASpecficHandlerAboveTheDefaultHandler() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .on(.error(HandlerError1.error1), do: .custom(view.customHandler))
            .else(do: .custom({ _ in XCTFail("Unexpected Handler Executed"); return false }))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItPrefersTheFirstMatchedHandler() throws {
        let view = MockedView(numberExpectedResults: 2)
        let handler = ErrorHandler(for: view)
            .on(.error(HandlerError1.error1), do: .custom(view.customHandler))
            .on(.error(HandlerError1.error1), do: .custom({ _ in XCTFail("Unexpected Handler Executed"); return false }))
            .else(do: .custom({ _ in XCTFail("Unexpected Handler Executed"); return false }))
        
        XCTAssertTrue(handler.handle(error: HandlerError1.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
        
    }
    

}
