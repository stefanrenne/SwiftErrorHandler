//
//  MockedView.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 26/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import SwiftErrorHandler

class MockedView: ErrorHandlerView {
    
    private let presentedAlertsGroups: DispatchGroup
    private let customHandlersGroup: DispatchGroup
    private let onCompletedGroups: DispatchGroup
    var lastResult: AlertController?
    
    init(numberExpectedPresentedAlerts: Int = 0, numberExpectedCustomHandlers: Int = 0, numberExpectedonCompleted: Int = 0) {
        presentedAlertsGroups = DispatchGroup.enter(number: numberExpectedPresentedAlerts)
        customHandlersGroup = DispatchGroup.enter(number: numberExpectedCustomHandlers)
        onCompletedGroups = DispatchGroup.enter(number: numberExpectedonCompleted)
    }
    
    func present(alert: AlertController) {
        lastResult = alert
        presentedAlertsGroups.leave()
    }
    
    func onCompleted() {
        onCompletedGroups.leave()
    }
    
    func unexpectedHandlerExecuted(for error: Error, onCompleted: OnErrorHandled) {
        XCTFail("Unexpected Handler Executed")
    }
    
    func customHandler(for error: Error, onCompleted: OnErrorHandled) {
        customHandlersGroup.leave()
        onCompleted?()
    }
    
    func didHandleResult() -> Bool {
        let timeout: DispatchTime = .now() + .milliseconds(200)
        return presentedAlertsGroups.wait(timeout: timeout) == .success &&
               customHandlersGroup.wait(timeout: timeout) == .success &&
               onCompletedGroups.wait(timeout: timeout) == .success
    }
}
