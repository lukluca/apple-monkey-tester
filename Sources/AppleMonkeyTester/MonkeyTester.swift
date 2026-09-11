import CoreGraphics
import XCTest

/// A thin, XCUITest-based random-input ("monkey") tester.
///
/// Generates a pseudo-random stream of taps, swipes, and gestures against a
/// running `XCUIApplication`, using Apple's own stable, currently-supported
/// public testing API — the same one wrapped by prior art like SwiftMonkey,
/// just not tied to an unmaintained implementation.
///
/// Works against any app exposing the standard accessibility/XCUITest
/// element tree (Flutter, UIKit, SwiftUI, AppKit, ...) — nothing here is
/// framework-specific.
///
/// - Note: `MonkeyTester` calls straight into `XCUIElement`/`XCUIApplication`,
///   which only work inside a real XCUITest UI-testing session (an Xcode UI
///   test target running against a launched app) — not from a plain
///   `swift test` run of this package on its own. Call `run()` from your
///   own `XCTestCase` UI test method, after `application.launch()`.
public struct MonkeyTester {
    /// Configuration for a monkey-testing run.
    public struct Configuration {
        /// Number of random events to generate before stopping.
        public var eventCount: Int

        /// Seed for the pseudo-random generator. Reuse a seed to reproduce
        /// a run exactly (e.g. to replay a crash found by a previous run).
        public var seed: UInt64

        /// Delay between events, to give the app time to react before the
        /// next one fires. `0` fires events as fast as possible.
        public var actionDelay: TimeInterval

        /// How often (in number of events) to re-query the app's element
        /// tree. Querying `XCUIApplication.descendants(matching:)` is
        /// expensive, so the same snapshot of hittable elements is reused
        /// across several events rather than re-queried every time;
        /// elements that have gone stale in between are detected and
        /// skipped in favor of a random coordinate tap.
        public var elementRefreshInterval: Int

        public init(
            eventCount: Int = 1000,
            seed: UInt64 = .random(in: .min ... .max),
            actionDelay: TimeInterval = 0.1,
            elementRefreshInterval: Int = 20
        ) {
            self.eventCount = eventCount
            self.seed = seed
            self.actionDelay = actionDelay
            self.elementRefreshInterval = elementRefreshInterval
        }
    }

    private let application: XCUIApplication
    private let configuration: Configuration

    public init(application: XCUIApplication, configuration: Configuration = Configuration()) {
        self.application = application
        self.configuration = configuration
    }

    /// Runs the configured number of random tap/swipe/gesture events
    /// against `application`, stopping early if the app is no longer in
    /// the foreground (e.g. it crashed).
    public func run() {
        var rng = SeededGenerator(seed: configuration.seed)
        var candidates: [XCUIElement] = []
        let refreshInterval = max(configuration.elementRefreshInterval, 1)

        for eventIndex in 0..<max(configuration.eventCount, 0) {
            guard application.state == .runningForeground else { break }

            if eventIndex % refreshInterval == 0 {
                candidates = hittableElements()
            }

            let element = candidates.randomElement(using: &rng)
            let event = MonkeyEvent.allCases.randomElement(using: &rng) ?? .tap
            perform(event, on: element, using: &rng)

            if configuration.actionDelay > 0 {
                Thread.sleep(forTimeInterval: configuration.actionDelay)
            }
        }
    }

    /// All currently hittable elements in the app's element tree.
    ///
    /// Restricted to hittable elements so events land on something the
    /// user could actually reach — offscreen/disabled/covered elements are
    /// excluded.
    private func hittableElements() -> [XCUIElement] {
        application.descendants(matching: .any)
            .allElementsBoundByIndex
            .filter(\.isHittable)
    }

    private func perform(_ event: MonkeyEvent, on element: XCUIElement?, using rng: inout SeededGenerator) {
        // Re-check liveness right before acting: `element` may have gone
        // stale (removed/replaced) since the last tree refresh.
        let target = (element?.exists == true && element?.isHittable == true) ? element : nil

        switch event {
        case .tap:
            tap(target, using: &rng)
        case .doubleTap:
            if let target {
                target.doubleTap()
            } else {
                tap(nil, using: &rng)
            }
        case .longPress:
            if let target {
                target.press(forDuration: 0.6)
            } else {
                tap(nil, using: &rng)
            }
        case .swipeUp:
            (target ?? application).swipeUp()
        case .swipeDown:
            (target ?? application).swipeDown()
        case .swipeLeft:
            (target ?? application).swipeLeft()
        case .swipeRight:
            (target ?? application).swipeRight()
        }
    }

    /// Taps `element` if given and still valid, otherwise falls back to a
    /// random point within the app's window.
    private func tap(_ element: XCUIElement?, using rng: inout SeededGenerator) {
        if let element, element.exists, element.isHittable {
            element.tap()
        } else {
            randomCoordinate(using: &rng).tap()
        }
    }

    /// A random point within the app's window, kept away from the very
    /// edges (5%–95%) to avoid triggering OS-level edge gestures
    /// (notification shade, Control Center, back/home swipes) instead of
    /// exercising the app itself.
    private func randomCoordinate(using rng: inout SeededGenerator) -> XCUICoordinate {
        let dx = Double.random(in: 0.05...0.95, using: &rng)
        let dy = Double.random(in: 0.05...0.95, using: &rng)
        return application.coordinate(withNormalizedOffset: CGVector(dx: dx, dy: dy))
    }
}
