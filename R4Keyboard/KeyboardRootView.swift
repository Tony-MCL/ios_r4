import SwiftUI

struct KeyboardRootView: View {
    let insertText: (String) -> Void
    let nextKeyboard: () -> Void

    @State private var messages: [R4Message] = []

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("R4")
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Button(action: reloadMessages) {
                    Image(systemName: "arrow.clockwise")
                        .font(.body)
                        .foregroundStyle(R4Theme.green)
                }
                .accessibilityLabel("Refresh messages")

                Button(action: nextKeyboard) {
                    Image(systemName: "globe")
                        .font(.title3)
                        .foregroundStyle(R4Theme.green)
                }
                .accessibilityLabel("Next keyboard")
            }

            if messages.isEmpty {
                Text("No saved messages")
                    .foregroundStyle(R4Theme.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            Button {
                                insertText(message.text)
                            } label: {
                                HStack {
                                    Text(message.title)
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(.white)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    Text("›")
                                        .font(.title3)
                                        .foregroundStyle(R4Theme.green)
                                }
                                .padding(.vertical, 11)
                                .padding(.horizontal, 14)
                                .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(R4Theme.border, lineWidth: 1)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(R4Theme.background)
        .onAppear(perform: reloadMessages)
    }

    private func reloadMessages() {
        messages = R4MessageStore.loadMessages()
    }
}
