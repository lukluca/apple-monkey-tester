/// A deterministic, seedable pseudo-random number generator.
///
/// Swift's `SystemRandomNumberGenerator` cannot be seeded, which makes a
/// crashing monkey-testing run impossible to reproduce. This is a small
/// splitmix64 generator instead — not cryptographically secure, but fast,
/// well-distributed, and fully reproducible from a given seed.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        // 0 is a fixed point for splitmix64 (it would keep producing 0);
        // fall back to a arbitrary non-zero constant in that case.
        state = seed == 0 ? 0x9E3779B97F4A7C15 : seed
    }

    mutating func next() -> UInt64 {
        state = state &+ 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
