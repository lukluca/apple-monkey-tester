/// A single kind of random input event `MonkeyTester` can generate.
enum MonkeyEvent: CaseIterable {
    case tap
    case doubleTap
    case longPress
    case swipeUp
    case swipeDown
    case swipeLeft
    case swipeRight
}
