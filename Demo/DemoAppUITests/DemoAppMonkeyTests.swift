import AppleMonkeyTester
import XCTest

/// End-to-end check for the package itself: run `MonkeyTester` against a
/// two-page app where page 2 has a button that deliberately crashes
/// (array out-of-bounds), and confirm the app is no longer running in the
/// foreground afterwards — i.e. the monkey found the crash.
final class DemoAppMonkeyTests: XCTestCase {
    func testMonkeyFindsTheCrash() {
        let app = XCUIApplication()
        app.launch()

        let tester = MonkeyTester(
            application: app,
            configuration: .init(eventCount: 500, seed: 42, actionDelay: 0)
        )
        tester.run()

        XCTAssertNotEqual(
            app.state,
            .runningForeground,
            "expected MonkeyTester's random taps to have reached the Crash button and crashed the app"
        )
    }

    /// Not a correctness test: prints how long a fixed number of events
    /// takes, on a screen with many elements and with the crash disabled, so
    /// a change to `MonkeyTester` can be compared before and after on the
    /// same simulator. Read the `THROUGHPUT` line in the test output.
    func testThroughput() {
        let app = XCUIApplication()
        app.launchArguments = ["-noCrash", "-busy"]
        app.launch()

        let events = 300
        let tester = MonkeyTester(
            application: app,
            configuration: .init(eventCount: events, seed: 42, actionDelay: 0)
        )
        let start = Date()
        tester.run()
        let elapsed = Date().timeIntervalSince(start)

        print(String(
            format: "THROUGHPUT: %d events in %.1f s (%.2f s/event)",
            events, elapsed, elapsed / Double(events)
        ))
        XCTAssertEqual(app.state, .runningForeground)
    }
}
