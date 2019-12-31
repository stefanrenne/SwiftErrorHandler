//
//  ActionHandlerTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import SwiftErrorHandler

class ActionHandlerTests: XCTestCase {
    
    func testItCanHandleTheEmptyAction() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 0, numberExpectedonCompleted: 1)
        
        let didHandleAction = ActionHandler.doNothing.perform(on: view, for: SimpleError.error1, onCompleted: view.onCompleted)
        didHandleAction()
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCanHandleTheAlertAction() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 1, numberExpectedCustomHandlers: 0, numberExpectedonCompleted: 0)
        let alert = MockedAlert()

        let didHandleAction = ActionHandler.present(alert: alert).perform(on: view, for: SimpleError.error1, onCompleted: nil)
        didHandleAction()
        
        XCTAssertTrue(view.didHandleResult())
        
        XCTAssertEqual(view.lastResult?.title, "title")
        XCTAssertEqual(view.lastResult?.message, "message")
        XCTAssertEqual(view.lastResult?.actions.count, 1)
        XCTAssertEqual(view.lastResult?.actions[0].title, "cancel")
        XCTAssertEqual(view.lastResult?.actions[0].style, .cancel)
    }
    
    func testItCanHandleAConfirmableAlertAction() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 1, numberExpectedCustomHandlers: 0, numberExpectedonCompleted: 0)
        let alert = ConfirmableAlert(title: "title", message: "message", confirmTitle: "confirm", confirmAction: nil)
        
        let didHandleAction = ActionHandler.present(alert: alert).perform(on: view, for: SimpleError.error1, onCompleted: nil)
        didHandleAction()
        
        XCTAssertTrue(view.didHandleResult())
        
        XCTAssertEqual(view.lastResult?.title, "title")
        XCTAssertEqual(view.lastResult?.message, "message")
        XCTAssertEqual(view.lastResult?.actions.count, 1)
        XCTAssertEqual(view.lastResult?.actions[0].title, "confirm")
        XCTAssertEqual(view.lastResult?.actions[0].style, .default)
    }
    
    func testItCanHandleARejectableAlertAction() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 1, numberExpectedCustomHandlers: 0, numberExpectedonCompleted: 0)
        let alert = RejectableAlert(title: "title", message: "message", confirmTitle: "YES", rejectTitle: "NO", confirmAction: nil, rejectAction: nil)
        
        let didHandleAction = ActionHandler.present(alert: alert).perform(on: view, for: SimpleError.error1, onCompleted: nil)
        didHandleAction()
        
        XCTAssertTrue(view.didHandleResult())
        
        XCTAssertEqual(view.lastResult?.title, "title")
        XCTAssertEqual(view.lastResult?.message, "message")
        XCTAssertEqual(view.lastResult?.actions.count, 2)
        XCTAssertEqual(view.lastResult?.actions[0].title, "YES")
        XCTAssertEqual(view.lastResult?.actions[0].style, .default)
        XCTAssertEqual(view.lastResult?.actions[1].title, "NO")
        XCTAssertEqual(view.lastResult?.actions[1].style, .cancel)
    }

    func testItCanHandleTheCustomAction() throws {
        let view = MockedView(numberExpectedPresentedAlerts: 0, numberExpectedCustomHandlers: 1, numberExpectedonCompleted: 1)
        
        let didHandleAction = ActionHandler.perform(action: view.customHandler).perform(on: view, for: SimpleError.error1, onCompleted: view.onCompleted)
        didHandleAction()
        
        XCTAssertTrue(view.didHandleResult())
    }
    
}

private extension ActionHandlerTests {
    enum SimpleError: Error {
        case error1
    }
}

extension ActionHandlerTests {
    
    static var allTests = [
        ("testItCanHandleTheEmptyAction", testItCanHandleTheEmptyAction),
        ("testItCanHandleTheAlertAction", testItCanHandleTheAlertAction),
        ("testItCanHandleAConfirmableAlertAction", testItCanHandleAConfirmableAlertAction),
        ("testItCanHandleARejectableAlertAction", testItCanHandleARejectableAlertAction),
        ("testItCanHandleTheCustomAction", testItCanHandleTheCustomAction)
    ]
}
