//
//  Result+ErrorHandler.swift
//  SwiftErrorHandler
//
//  Created by Stefan Renne on 30/12/2019.
//

import Foundation

public extension Result {

    func get(onError handler: ErrorHandler, onErrorCompleted: OnErrorHandled = nil) -> Success? {
        do {
            return try get()
        } catch {
            handler.handle(error: error, onCompleted: onErrorCompleted)
            return nil
        }
    }
}
