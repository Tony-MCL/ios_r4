import SwiftUI

struct ContentView: View {
    @State private var statusMessage = "No shared test message saved yet."
    @State private var showResult = false

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
                    saveTestMessage()
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
            .alert("R4 App Group test", isPresented: $showResult) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(statusMessage)
            }
        }
    }

    private func saveTestMessage() {
        do {
            try SharedTestMessage.save(
                title: "Shared Bear",
                text: "Shared test message from R4"
            )

            guard let loaded = SharedTestMessage.load() else {
                statusMessage = "The file was written, but R4 could not read it back."
                showResult = true
                return
            }

            statusMessage = "Saved and read back: \(loaded.title)"
        } catch {
            statusMessage = "Save failed: \(error.localizedDescription)"
        }

        showResult = true
    }
}

#Preview {
    ContentView()
}
