//
//  ActionHandlerTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import ErrorHandler

fileprivate enum SimpleError: Error {
    case error1
}


class ActionHandlerTests: XCTestCase {
    
    func testItCanHandleTheEmptyAction() throws {
        let view = MockedView(numberExpectedResults: 1)
        
        XCTAssertTrue(ActionHandler.doNothing.perform(on: view, for: SimpleError.error1, onHandled: view.onHandled))
        
        XCTAssertTrue(view.didHandleResult())
    }
    
    func testItCanHandleTheAlertAction() throws {
        let view = MockedView(numberExpectedResults: 1)
        let alert = MockedAlert()

        XCTAssertTrue(ActionHandler.present(alert: alert).perform(on: view, for: SimpleError.error1, onHandled: nil))
        
        XCTAssertTrue(view.didHandleResult())
        
        let alertController = view.lastResult as? UIAlertController
        XCTAssertEqual(alertController?.title, "title")
        XCTAssertEqual(alertController?.message, "message")
        XCTAssertEqual(alertController?.actions.count, 1)
        XCTAssertEqual(alertController?.actions[0].title, "cancel")
        XCTAssertEqual(alertController?.actions[0].style, .cancel)
        XCTAssertEqual(alertController?.actions[0].isEnabled, true)
    }
    
    func testItCanHandleAConfirmableAlertAction() throws {
        let view = MockedView(numberExpectedResults: 1)
        let alert = ConfirmableAlert(title: "title", message: "message", confirmTitle: "confirm", confirmAction: nil)
        
        XCTAssertTrue(ActionHandler.present(alert: alert).perform(on: view, for: SimpleError.error1, onHandled: nil))
        
        XCTAssertTrue(view.didHandleResult())
        
        let alertController = view.lastResult as? UIAlertController
        XCTAssertEqual(alertController?.title, "title")
        XCTAssertEqual(alertController?.message, "message")
        XCTAssertEqual(alertController?.actions.count, 1)
        XCTAssertEqual(alertController?.actions[0].title, "confirm")
        XCTAssertEqual(alertController?.actions[0].style, .default)
        XCTAssertEqual(alertController?.actions[0].isEnabled, true)
    }
    
    func testItCanHandleARejectableAlertAction() throws {
        let view = MockedView(numberExpectedResults: 1)
        let alert = RejectableAlert(title: "title", message: "message", confirmTitle: "YES", rejectTitle: "NO", confirmAction: nil, rejectAction: nil)
        
        XCTAssertTrue(ActionHandler.present(alert: alert).perform(on: view, for: SimpleError.error1, onHandled: nil))
        
        XCTAssertTrue(view.didHandleResult())
        
        let alertController = view.lastResult as? UIAlertController
        XCTAssertEqual(alertController?.title, "title")
        XCTAssertEqual(alertController?.message, "message")
        XCTAssertEqual(alertController?.actions.count, 2)
        XCTAssertEqual(alertController?.actions[0].title, "YES")
        XCTAssertEqual(alertController?.actions[0].style, .default)
        XCTAssertEqual(alertController?.actions[0].isEnabled, true)
        XCTAssertEqual(alertController?.actions[1].title, "NO")
        XCTAssertEqual(alertController?.actions[1].style, .cancel)
        XCTAssertEqual(alertController?.actions[1].isEnabled, true)
    }

    func testItCanHandleTheCustomAction() throws {
        let view = MockedView(numberExpectedResults: 2)
        
        let didHandleAction = ActionHandler.perform(action: { _, onHandled in
            view.group.leave()
            onHandled?()
            return true
        }).perform(on: view, for: SimpleError.error1, onHandled: view.onHandled)
        XCTAssertTrue(didHandleAction)
        
        XCTAssertTrue(view.didHandleResult())
    }
    
}
