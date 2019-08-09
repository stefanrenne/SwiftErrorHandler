//
//  DispatchGroup+Enter.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 26/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

extension DispatchGroup {
    class func enter(number: Int) -> DispatchGroup {
        let group = DispatchGroup()
        if number > 0 {
            for _ in 1...number {
                group.enter()
            }
        }
        return group
    }
}
