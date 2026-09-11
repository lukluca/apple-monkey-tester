// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AppleMonkeyTester",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "AppleMonkeyTester",
            targets: ["AppleMonkeyTester"]
        ),
    ],
    targets: [
        .target(
            name: "AppleMonkeyTester",
            linkerSettings: [
                .linkedFramework("XCTest"),
            ]
        ),
        .testTarget(
            name: "AppleMonkeyTesterTests",
            dependencies: ["AppleMonkeyTester"]
        ),
    ]
)
