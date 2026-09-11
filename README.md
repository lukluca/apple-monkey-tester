# apple-monkey-tester

[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flukluca%2Fapple-monkey-tester%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/lukluca/apple-monkey-tester)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Flukluca%2Fapple-monkey-tester%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/lukluca/apple-monkey-tester)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A small, XCUITest-based random-input ("monkey") testing tool for **iOS, iPadOS, and macOS**.

## Why

Monkey testing — throwing a pseudo-random stream of taps, swipes, and gestures at a running app to surface crashes nobody thought to script a test for — has good off-the-shelf support on Android (`adb shell monkey`, part of the Android SDK) but not on Apple platforms:

- **CrashMonkey** is built on Apple's UIAutomation framework, which Apple removed from Xcode years ago — it doesn't run on any current toolchain.
- **SwiftMonkey**, the one credible modern option, has been archived/unmaintained since December 2022.

Rather than depend on an abandoned project, this repo builds a small, focused replacement on top of `XCUITest` (`XCUIApplication` / `XCUIElement`) — Apple's own stable, currently-supported public testing API, the same one SwiftMonkey itself wrapped. XCUITest covers iOS, iPadOS, and macOS from one API, so one tool targets all three.

## Scope

This is a generic, reusable Swift Package — not tied to any specific app. It works against any app that exposes the standard accessibility/XCUITest element tree (Flutter, UIKit, SwiftUI, AppKit, ...).

## Status

Working first implementation. `MonkeyTester` generates a pseudo-random stream of taps, double-taps, long-presses, and swipes (up/down/left/right) against the app's currently hittable elements, falling back to a random on-screen coordinate when no element is available or one has gone stale between events.

`MonkeyTester` only works inside a real XCUITest UI-testing session — an Xcode UI test target running against a launched app — not from a plain `swift test` run of this package on its own, since `XCUIApplication`/`XCUIElement` need the UI-testing runner infrastructure Xcode wires up. Call `run()` from your own `XCTestCase` UI test method, after `application.launch()`.

## Usage

```swift
import AppleMonkeyTester
import XCTest

final class MonkeyTests: XCTestCase {
    func testAppSurvivesRandomInput() {
        let app = XCUIApplication()
        app.launch()

        let tester = MonkeyTester(
            application: app,
            configuration: .init(eventCount: 1000, seed: 42)
        )
        tester.run()

        XCTAssertEqual(app.state, .runningForeground)
    }
}
```

Reuse the same `seed` to reproduce a run exactly — useful for replaying a crash a previous run found.

## License

MIT — see [LICENSE](LICENSE).
