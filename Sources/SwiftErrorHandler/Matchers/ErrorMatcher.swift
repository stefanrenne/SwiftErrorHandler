//
//  ErrorMatcher.swift
//  ErrorHandler
//
//  Created by Stefan Renne on 19/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import Foundation

public struct ErrorMatcher {

    private let matcher: ((Error) -> Bool)

    public init(matcher: @escaping ((Error) -> Bool)) {
        self.matcher = matcher
    }

    public func catches(_ error: Error) -> Bool {
        return matcher(error)
    }
}

public extension ErrorMatcher {

    static func type(_ error: Error) -> ErrorMatcher {
        return .init(matcher: { $0.reflectedString == error.reflectedString })
    }

    static func code(_ code: Int) -> ErrorMatcher {
        return .init(matcher: { $0._code == code })
    }

    static func domain(_ domain: String) -> ErrorMatcher {
        return .init(matcher: { $0._domain == domain })
    }

    @available(*, deprecated, message: "Create an extension on ErrorMatcher instead")
    static func match(_ matcher: @escaping ((Error) -> Bool)) -> ErrorMatcher {
        return .init(matcher: matcher)
    }
}
