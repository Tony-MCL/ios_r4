import SwiftUI

struct ContentView: View {
    @State private var statusMessage = "No shared test message saved yet."

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("R4Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 220)
                    .accessibilityLabel("R4")

                Text("Phase 1 – App Group test")
                    .font(.headline)

                Button("Save test message") {
                    let saved = SharedTestMessage.save(
                        title: "Shared Bear",
                        text: "Shared test message from R4"
                    )

                    statusMessage = saved
                        ? "Saved to the R4 shared App Group."
                        : "Could not open the R4 shared App Group."
                }
                .buttonStyle(.borderedProminent)

                Text(statusMessage)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Text("After saving, open R4 Keyboard in another app. The keyboard should show Shared Bear.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("R4")
        }
    }
}

#Preview {
    ContentView()
}
