//
//  ResultErrorHandlerTests.swift
//  SwiftErrorHandlerTests
//
//  Created by Stefan Renne on 30/12/2019.
//

import XCTest
@testable import SwiftErrorHandler

class ResultErrorHandlerTests: XCTestCase {

    func testItWontHandleSuccessResults() throws {
        let view = MockedView()
        let handler = ErrorHandler(for: view)

        let result: Result<String, HandlerError1> = .success("win")
        XCTAssertNotNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))
    }

    func testItCanHandleSpecificErrors() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedonCompleted: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error1)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))

        XCTAssertTrue(view.didHandleResult())
    }

    func testItCantHandleSpecificErrorsWhereThereAreNoSpecificHandlers() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedonCompleted: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error2)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))

        XCTAssertFalse(view.didHandleResult())
    }

    func testItCanFallbackToADefaultHandler() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedonCompleted: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.unexpectedHandlerExecuted))
            .onNoMatch(.perform(action: view.customHandler))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error2)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))

        XCTAssertTrue(view.didHandleResult())
    }

    func testItPrefersASpecficHandlerAboveTheDefaultHandler() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedonCompleted: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.unexpectedHandlerExecuted))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error1)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))

        XCTAssertTrue(view.didHandleResult())
    }

    func testItCanExecuteMultupleMatches() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 2, numberExpectedonCompleted: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.unexpectedHandlerExecuted))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error1)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))

        XCTAssertTrue(view.didHandleResult())
    }

    func testItCanHaveHandlersThatAlwaysGetExecuted() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 2, numberExpectedonCompleted: 1)
        let handler = ErrorHandler(for: view)
            .on(error: .type(HandlerError1.error1), then: .perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.unexpectedHandlerExecuted))
            .always(.perform(action: view.customHandler))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error1)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: view.onCompleted))

        XCTAssertTrue(view.didHandleResult())
    }

    func testItCanHaveMultipleAlwaysHandlers() {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 3, numberExpectedonCompleted: 0)
        let handler = ErrorHandler(for: view)
            .always(.perform(action: view.customHandler))
            .always(.perform(action: view.customHandler))
            .always(.perform(action: view.customHandler))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error1)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: nil))

        XCTAssertTrue(view.didHandleResult())
    }

    func testItCanHaveMultipleDefaultHandlers() {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 3, numberExpectedonCompleted: 0)
        let handler = ErrorHandler(for: view)
            .onNoMatch(.perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.customHandler))
            .onNoMatch(.perform(action: view.customHandler))

        let result: Result<Bool, HandlerError1> = .failure(HandlerError1.error1)
        XCTAssertNil(result.get(onError: handler, onErrorCompleted: nil))

        XCTAssertTrue(view.didHandleResult())
    }
}

extension ResultErrorHandlerTests {
    private enum HandlerError1: Error {
        case error1
        case error2
        case error3
    }

    private enum HandlerError2: Error {
        case error4
    }

}

extension ResultErrorHandlerTests {

    static var allTests = [
        ("testItWontHandleSuccessResults", testItWontHandleSuccessResults),
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
