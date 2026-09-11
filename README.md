# apple-monkey-tester

A small, XCUITest-based random-input ("monkey") testing tool for **iOS, iPadOS, and macOS**.

## Why

Monkey testing — throwing a pseudo-random stream of taps, swipes, and gestures at a running app to surface crashes nobody thought to script a test for — has good off-the-shelf support on Android (`adb shell monkey`, part of the Android SDK) but not on Apple platforms:

- **CrashMonkey** is built on Apple's UIAutomation framework, which Apple removed from Xcode years ago — it doesn't run on any current toolchain.
- **SwiftMonkey**, the one credible modern option, has been archived/unmaintained since December 2022.

Rather than depend on an abandoned project, this repo builds a small, focused replacement on top of `XCUITest` (`XCUIApplication` / `XCUIElement`) — Apple's own stable, currently-supported public testing API, the same one SwiftMonkey itself wrapped. XCUITest covers iOS, iPadOS, and macOS from one API, so one tool targets all three.

## Scope

This is a generic, reusable Swift Package — not tied to any specific app. It works against any app that exposes the standard accessibility/XCUITest element tree (Flutter, UIKit, SwiftUI, AppKit, ...).

## Status

Early scaffold. The `MonkeyTester` API surface exists; the actual random event-generation logic is not implemented yet.

## Usage

```swift
import AppleMonkeyTester
import XCTest

let app = XCUIApplication()
app.launch()

let tester = MonkeyTester(
    application: app,
    configuration: .init(eventCount: 1000)
)
tester.run()
```

## License

MIT — see [LICENSE](LICENSE).
