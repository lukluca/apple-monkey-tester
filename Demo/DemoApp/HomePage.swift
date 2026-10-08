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

                // `-busy`: a screen with many elements, like a real app's
                // forms and lists, for the throughput benchmark — the
                // default two-button screen hides the cost of walking a
                // big element tree.
                if CommandLine.arguments.contains("-busy") {
                    ScrollView {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible()), count: 4)
                        ) {
                            ForEach(0..<60, id: \.self) { index in
                                Button("\(index)") { tapCount += 1 }
                                    .buttonStyle(.bordered)
                                    .accessibilityIdentifier("busyButton\(index)")
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomePage()
}
