import SwiftUI

struct MessageEditorView: View {
    @Environment(\.dismiss) private var dismiss

    let existingMessage: R4Message?
    let onSave: (String, String) -> Void

    @State private var title: String
    @State private var text: String

    init(existingMessage: R4Message?, onSave: @escaping (String, String) -> Void) {
        self.existingMessage = existingMessage
        self.onSave = onSave
        _title = State(initialValue: existingMessage?.title ?? "")
        _text = State(initialValue: existingMessage?.text ?? "")
    }

    var body: some View {
        NavigationStack {
            ZStack {
                R4Theme.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {
                    Text(R4L10n.string(existingMessage == nil ? "editor.new_title" : "editor.edit_title"))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)

                    Text(R4L10n.string("editor.format_preserved"))
                        .font(.system(size: 14))
                        .foregroundStyle(R4Theme.muted)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(R4L10n.string("editor.title_label"))
                            .foregroundStyle(R4Theme.muted)
                        TextField(R4L10n.string("editor.title_placeholder"), text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(title.isEmpty ? R4Theme.border : R4Theme.green, lineWidth: 1)
                            }
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(R4L10n.string("editor.text_label"))
                            .foregroundStyle(R4Theme.muted)
                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(R4Theme.border, lineWidth: 1)
                            }
                    }
                    .frame(maxHeight: .infinity)

                    HStack(spacing: 10) {
                        Button(R4L10n.string("common.cancel")) { dismiss() }
                            .buttonStyle(R4SecondaryButtonStyle())

                        Button(R4L10n.string("common.save")) {
                            onSave(title, text)
                        }
                        .buttonStyle(R4PrimaryButtonStyle())
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1)
                    }
                }
                .padding(20)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

struct R4SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(R4Theme.border, lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
