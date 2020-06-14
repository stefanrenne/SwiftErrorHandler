//
//  ErrorMatcherTests.swift
//  ErrorHandlerTests
//
//  Created by Stefan Renne on 22/07/2019.
//  Copyright © 2019 stefanrenne. All rights reserved.
//

import XCTest
@testable import SwiftErrorHandler

class ErrorMatcherTests: XCTestCase {
    
    func testItCanMatchError() throws {
        let matcher = ErrorMatcher.type(MatcherError1.error1)
        let searchError = MatcherError1.error1
        XCTAssertTrue(matcher.catches(searchError))
    }
    
    func testItCanMatchErrorCodes() throws {
        let matcher = ErrorMatcher.code(400)
        let searchError = NSError(domain: "damain", code: 400, userInfo: ["data": "value"])
        XCTAssertTrue(matcher.catches(searchError))
    }
    
    func testItCanMatchErrorDomains() throws {
        let matcher = ErrorMatcher.domain("remote")
        let searchError = NSError(domain: "remote", code: 401, userInfo: ["data": "value"])
        XCTAssertTrue(matcher.catches(searchError))
    }

    func testItCanMatchWithBlock() throws {
        let matcher: ErrorMatcher = .isError3
        let searchError = MatcherError1.error3
        XCTAssertTrue(matcher.catches(searchError))
    }

    func testItCanMatchCompleteErrorSuites() throws {
        let matcher: ErrorMatcher = .isError2
        let searchError = MatcherError2.error4
        XCTAssertTrue(matcher.catches(searchError))
    }
}

private extension ErrorMatcher {
    static var isError2: ErrorMatcher {
        return .init(matcher: { $0 is ErrorMatcherTests.MatcherError2 })
    }

    static var isError3: ErrorMatcher {
        return .init(matcher: { error in
            guard
                let testError = error as? ErrorMatcherTests.MatcherError1,
                testError == .error3
            else {
                return false
            }
            return true
        })
    }
}

fileprivate extension ErrorMatcherTests {
    
    enum MatcherError1: Error {
        case error1
        case error2
        case error3
    }
    
    enum MatcherError2: Error {
        case error4
    }
}

extension ErrorMatcherTests {
    
    static var allTests = [
        ("testItCanMatchError", testItCanMatchError),
        ("testItCanMatchErrorCodes", testItCanMatchErrorCodes),
        ("testItCanMatchErrorDomains", testItCanMatchErrorDomains),
        ("testItCanMatchWithBlock", testItCanMatchWithBlock),
        ("testItCanMatchCompleteErrorSuites", testItCanMatchCompleteErrorSuites)
    ]
}
