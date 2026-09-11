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
public struct MonkeyTester {
    /// Configuration for a monkey-testing run.
    public struct Configuration {
        /// Number of random events to generate before stopping.
        public var eventCount: Int

        /// Seed for the pseudo-random generator, for reproducible runs.
        public var seed: UInt64

        public init(eventCount: Int = 1000, seed: UInt64 = .random(in: .min ... .max)) {
            self.eventCount = eventCount
            self.seed = seed
        }
    }

    private let application: XCUIApplication
    private let configuration: Configuration

    public init(application: XCUIApplication, configuration: Configuration = Configuration()) {
        self.application = application
        self.configuration = configuration
    }

    /// Runs the configured number of random tap/swipe/gesture events
    /// against `application`.
    ///
    /// - Note: Not implemented yet — this is the scaffold the actual
    ///   event-generation logic will be built against.
    public func run() {
        // TODO: generate a pseudo-random stream of taps, swipes, and
        // gestures against `application`'s element tree, seeded from
        // `configuration.seed` for reproducibility.
    }
}
