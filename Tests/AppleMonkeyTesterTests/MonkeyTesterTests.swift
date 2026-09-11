import XCTest
@testable import AppleMonkeyTester

final class MonkeyTesterTests: XCTestCase {
    func testConfigurationDefaults() {
        let configuration = MonkeyTester.Configuration()

        XCTAssertEqual(configuration.eventCount, 1000)
        XCTAssertEqual(configuration.actionDelay, 0.1)
        XCTAssertEqual(configuration.elementRefreshInterval, 20)
    }

    func testConfigurationIsCustomizable() {
        let configuration = MonkeyTester.Configuration(
            eventCount: 42,
            seed: 7,
            actionDelay: 0,
            elementRefreshInterval: 5
        )

        XCTAssertEqual(configuration.eventCount, 42)
        XCTAssertEqual(configuration.seed, 7)
        XCTAssertEqual(configuration.actionDelay, 0)
        XCTAssertEqual(configuration.elementRefreshInterval, 5)
    }
}
