//
//  ErrorAlert.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public protocol ErrorAlert {
    func build(for error: Error, onCompleted: OnErrorHandled) -> AlertController
}
