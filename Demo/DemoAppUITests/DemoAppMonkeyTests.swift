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
}
