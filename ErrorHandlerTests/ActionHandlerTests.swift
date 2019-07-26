//
//  ActionHandlerTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import ErrorHandler

fileprivate class TestErrorHandlerView: ErrorHandlerView {
    
    let group: DispatchGroup
    var lastResult: UIViewController?
    
    init(numberExpectedResults: Int) {
        group = DispatchGroup.enter(number: numberExpectedResults)
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        lastResult = viewControllerToPresent
        group.leave()
        completion?()
    }
    
    func onHandled() {
        group.leave()
    }
    
    func waitForResult() -> DispatchTimeoutResult {
        return group.wait(timeout: .now() + .milliseconds(200))
    }
}

fileprivate class TestAlert: ErrorAlert {
    func build(onHandled: OnErrorHandled) -> UIAlertController {
        let controller = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        return controller
    }
}

class ActionHandlerTests: XCTestCase {
    
    func testItCanHandleTheEmptyAction() throws {
        let testView = TestErrorHandlerView(numberExpectedResults: 1)
        
        XCTAssertTrue(ActionHandler.none.perform(on: testView, onHandled: testView.onHandled))
        
        XCTAssertTrue(testView.waitForResult() == .success)
    }
    
    func testItCanHandleTheAlertAction() throws {
        let testView = TestErrorHandlerView(numberExpectedResults: 1)
        let testAlert = TestAlert()

        XCTAssertTrue(ActionHandler.alert(testAlert).perform(on: testView, onHandled: nil))
        
        XCTAssertTrue(testView.waitForResult() == .success)

        XCTAssertEqual((testView.lastResult as? UIAlertController)?.title, "title")
        XCTAssertEqual((testView.lastResult as? UIAlertController)?.message, "message")
        XCTAssertEqual((testView.lastResult as? UIAlertController)?.actions.count, 1)
    }

    func testItCanHandleTheCustomAction() throws {
        let testView = TestErrorHandlerView(numberExpectedResults: 2)
        
        let didHandleAction = ActionHandler.custom({ onHandled in
            testView.group.leave()
            onHandled?()
            return true
        }).perform(on: testView, onHandled: testView.onHandled)
        XCTAssertTrue(didHandleAction)
        
        XCTAssertTrue(testView.waitForResult() == .success)
    }
    
}
