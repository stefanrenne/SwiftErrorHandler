//
//  MockedAlert.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 26/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import UIKit
@testable import SwiftErrorHandler

class MockedAlert: ErrorAlert {
    
    func build(for error: Error, onHandled: OnErrorHandled) -> UIAlertController {
        let controller = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        return controller
    }
}
