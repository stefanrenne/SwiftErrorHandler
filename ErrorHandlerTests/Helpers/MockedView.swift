//
//  MockedView.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 26/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation
@testable import ErrorHandler

class MockedView: ErrorHandlerView {
    
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
    
    func customHandler(for error: Error, onHandled: OnErrorHandled) -> Bool {
        group.leave()
        onHandled?()
        return true
    }
    
    func didHandleResult() -> Bool {
        return group.wait(timeout: .now() + .milliseconds(200)) == .success
    }
}
