import XCTest
@testable import AppleMonkeyTester

final class MonkeyTesterTests: XCTestCase {
    func testConfigurationDefaults() {
        let configuration = MonkeyTester.Configuration()

        XCTAssertEqual(configuration.eventCount, 1000)
    }

    func testConfigurationIsCustomizable() {
        let configuration = MonkeyTester.Configuration(eventCount: 42, seed: 7)

        XCTAssertEqual(configuration.eventCount, 42)
        XCTAssertEqual(configuration.seed, 7)
    }
}
