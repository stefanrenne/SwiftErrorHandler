//
//  MockedAlert.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 26/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation
@testable import SwiftErrorHandler

class MockedAlert: ErrorAlert {
    
    func build(for error: Error, onCompleted: OnErrorHandled) -> AlertController {
        let controller = AlertController(title: "title", message: "message", preferredStyle: .alert)
        controller.addAction(AlertAction(title: "cancel", style: .cancel, handler: nil))
        return controller
    }
}
