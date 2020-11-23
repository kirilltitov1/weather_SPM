import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(loadImageUsingUrlStringTests.allTests),
    ]
}
#endif
