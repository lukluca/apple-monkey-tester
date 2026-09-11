import SwiftUI

/// Page 1 — safe content only. Every action here is meant to survive
/// `MonkeyTester` hammering it with random taps.
struct HomePage: View {
    @State private var tapCount = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Tap count: \(tapCount)")
                    .font(.title2)
                    .accessibilityIdentifier("tapCountLabel")

                Button("Tap me") {
                    tapCount += 1
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("safeTapButton")

                NavigationLink("Go to the crashing page") {
                    CrashPage()
                }
                .accessibilityIdentifier("goToCrashPageLink")
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomePage()
}
