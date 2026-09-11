import SwiftUI

/// Page 2 — deliberately unsafe. The "Crash" button reads past the end of
/// an array, which traps and terminates the app. This is the bug
/// `MonkeyTester`'s random taps/swipes are meant to stumble into.
struct CrashPage: View {
    private let items = [1, 2, 3]

    var body: some View {
        VStack(spacing: 24) {
            Text("This page is unsafe on purpose.")
                .multilineTextAlignment(.center)

            Button("Crash") {
                // Deliberate out-of-bounds access — index 10 doesn't exist
                // in a 3-element array, so this traps.
                let value = items[10]
                print(value)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .accessibilityIdentifier("crashButton")
        }
        .padding()
        .navigationTitle("Crash")
    }
}

#Preview {
    CrashPage()
}
