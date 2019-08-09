//
//  MockedView.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 26/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import UIKit
import XCTest
@testable import SwiftErrorHandler

class MockedView: ErrorHandlerView {
    
    private let presentedAlertsGroups: DispatchGroup
    private let customHandlersGroup: DispatchGroup
    private let onHandledGroups: DispatchGroup
    var lastResult: UIAlertController?
    
    init(numberExpectedPresentedAlerts: Int, numberExpectedCustomHandlers: Int, numberExpectedOnHandled: Int) {
        presentedAlertsGroups = DispatchGroup.enter(number: numberExpectedPresentedAlerts)
        customHandlersGroup = DispatchGroup.enter(number: numberExpectedCustomHandlers)
        onHandledGroups = DispatchGroup.enter(number: numberExpectedOnHandled)
    }
    
    func present(alert: UIAlertController) {
        lastResult = alert
        presentedAlertsGroups.leave()
    }
    
    func onHandled() {
        onHandledGroups.leave()
    }
    
    func unexpectedHandlerExecuted(for error: Error, onHandled: OnErrorHandled) {
        XCTFail("Unexpected Handler Executed")
    }
    
    func customHandler(for error: Error, onHandled: OnErrorHandled) {
        customHandlersGroup.leave()
        onHandled?()
    }
    
    func didHandleResult() -> Bool {
        let timeout: DispatchTime = .now() + .milliseconds(200)
        return presentedAlertsGroups.wait(timeout: timeout) == .success &&
               customHandlersGroup.wait(timeout: timeout) == .success &&
               onHandledGroups.wait(timeout: timeout) == .success
    }
}
