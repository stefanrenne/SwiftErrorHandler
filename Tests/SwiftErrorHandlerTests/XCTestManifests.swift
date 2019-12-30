import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ActionHandlerTests.allTests),
        testCase(ErrorHandlerTests.allTests),
        testCase(ResultErrorHandlerTests.allTests),
        testCase(ErrorMatcherTests.allTests)
    ]
}
#endif
