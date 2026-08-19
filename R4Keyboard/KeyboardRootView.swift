import SwiftUI

struct KeyboardRootView: View {
    let insertText: (String) -> Void
    let nextKeyboard: () -> Void

    @State private var sharedMessage: SharedTestMessagePayload?

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("R4")
                    .font(.headline)

                Spacer()

                Button(action: nextKeyboard) {
                    Image(systemName: "globe")
                        .font(.title3)
                }
                .accessibilityLabel("Next keyboard")
            }

            if let sharedMessage {
                Button {
                    insertText(sharedMessage.text)
                } label: {
                    HStack {
                        Text(sharedMessage.title)
                            .font(.body.weight(.semibold))
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            } else {
                Text("No shared R4 message found")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .onAppear(perform: reloadSharedMessage)
    }

    private func reloadSharedMessage() {
        sharedMessage = SharedTestMessage.load()
    }
}
