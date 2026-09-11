import XCTest
@testable import AppleMonkeyTester

final class SeededGeneratorTests: XCTestCase {
    func testSameSeedProducesSameSequence() {
        var a = SeededGenerator(seed: 1234)
        var b = SeededGenerator(seed: 1234)

        let sequenceA = (0..<50).map { _ in a.next() }
        let sequenceB = (0..<50).map { _ in b.next() }

        XCTAssertEqual(sequenceA, sequenceB)
    }

    func testDifferentSeedsProduceDifferentSequences() {
        var a = SeededGenerator(seed: 1)
        var b = SeededGenerator(seed: 2)

        let sequenceA = (0..<10).map { _ in a.next() }
        let sequenceB = (0..<10).map { _ in b.next() }

        XCTAssertNotEqual(sequenceA, sequenceB)
    }

    func testZeroSeedDoesNotDegenerate() {
        var generator = SeededGenerator(seed: 0)

        let values = Set((0..<50).map { _ in generator.next() })

        // A degenerate generator would keep returning the same value.
        XCTAssertGreaterThan(values.count, 1)
    }

    func testUsableWithStandardLibraryRandomAPIs() {
        var generator = SeededGenerator(seed: 99)

        let values = (0..<100).map { _ in Int.random(in: 0..<10, using: &generator) }

        XCTAssertTrue(values.allSatisfy { (0..<10).contains($0) })
    }
}
