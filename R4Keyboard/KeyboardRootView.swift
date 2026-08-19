import SwiftUI

struct KeyboardRootView: View {
    let insertText: (String) -> Void
    let nextKeyboard: () -> Void

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

            Button {
                insertText("Test message from R4")
            } label: {
                HStack {
                    Text("Bear")
                        .font(.body.weight(.semibold))
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)
        }
        .padding(12)
    }
}
