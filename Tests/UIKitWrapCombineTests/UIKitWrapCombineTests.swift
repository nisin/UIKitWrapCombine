import XCTest
@testable import UIKitWrapCombine

final class UIKitWrapCombineTests: XCTestCase {
    func testExample() {
        
        XCTAssertTrue(UIControl().wrap is WrapCombine.Wrapper)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
