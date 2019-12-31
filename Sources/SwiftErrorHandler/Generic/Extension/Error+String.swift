//
//  Error+String.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 05/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

extension Error {
    var reflectedString: String {
        return String(reflecting: self)
    }
}
