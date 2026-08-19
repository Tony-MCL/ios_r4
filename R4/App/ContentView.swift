import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    @State private var messages: [R4Message] = R4MessageStore.loadMessages()
    @State private var showMessages = false
    @State private var showingEditor = false
    @State private var showingSettings = false
    @State private var editingMessage: R4Message?
    @State private var pendingDelete: R4Message?
    @State private var saveError: String?
    @AppStorage("r4.firstRunShown") private var firstRunShown = false

    var body: some View {
        NavigationStack {
            ZStack {
                R4Theme.background.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 10) {
                        header
                        actionCard(icon: "+", title: "New message", subtitle: "Create a new message") {
                            editingMessage = nil
                            showingEditor = true
                        }
                        actionCard(icon: "☷", title: "My messages", subtitle: "Manage your messages (\(messages.count))") {
                            withAnimation { showMessages.toggle() }
                        }

                        if showMessages {
                            messageArchive
                        }

                        keyboardCard
                        copyrightFooter
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditor) {
            MessageEditorView(existingMessage: editingMessage) { title, text in
                saveMessage(title: title, text: text)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .alert("Delete message?", isPresented: Binding(
            get: { pendingDelete != nil },
            set: { if !$0 { pendingDelete = nil } }
        )) {
            Button("Cancel", role: .cancel) { pendingDelete = nil }
            Button("Delete", role: .destructive) { deletePendingMessage() }
        } message: {
            Text("“\(pendingDelete?.title ?? "")” will be permanently deleted from this device.")
        }
        .alert("How R4 works on iPhone", isPresented: Binding(
            get: { !firstRunShown },
            set: { if !$0 { firstRunShown = true } }
        )) {
            Button("Got it") { firstRunShown = true }
        } message: {
            Text("Save the messages you use often in R4. Then add R4 Keyboard in Settings → General → Keyboard → Keyboards → Add New Keyboard. Enable Allow Full Access, switch to R4 Keyboard in any normal text field, and tap a message title to insert the full text.")
        }
        .alert("Could not save", isPresented: Binding(
            get: { saveError != nil },
            set: { if !$0 { saveError = nil } }
        )) {
            Button("OK", role: .cancel) { saveError = nil }
        } message: {
            Text(saveError ?? "Unknown error")
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                reloadMessages()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 2) {
            HStack(alignment: .top) {
                Spacer()
                    .frame(maxWidth: .infinity)

                Image("R4Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                    .frame(maxWidth: 260)
                    .accessibilityLabel("R4")

                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundStyle(R4Theme.green)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 14)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Settings and info")
            }
            .padding(.top, 16)

            Text("FLOAT · SAVE · SEND · EASY!!")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    private var messageArchive: some View {
        if messages.isEmpty {
            Text("No messages yet. Create the first one by writing or pasting the text you want to save.")
                .font(.system(size: 15))
                .foregroundStyle(R4Theme.muted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
        } else {
            ForEach(messages) { message in
                messageCard(message)
            }
        }
    }

    private var keyboardCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                iconBox(systemName: "keyboard")

                VStack(alignment: .leading, spacing: 4) {
                    Text("R4 Keyboard")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Use your saved messages in other apps")
                        .font(.system(size: 15))
                        .foregroundStyle(R4Theme.muted)
                }
            }

            Text("Add R4 Keyboard in iPhone Settings, enable Allow Full Access, then switch keyboards from any normal text field.")
                .font(.system(size: 14))
                .foregroundStyle(R4Theme.muted)

            Button("Keyboard setup") {
                showingSettings = true
            }
            .buttonStyle(R4PrimaryButtonStyle())
        }
        .r4Card()
    }

    private func actionCard(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(R4Theme.green.opacity(0.05))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(R4Theme.green.opacity(0.25), lineWidth: 1)
                        }
                    Text(icon)
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(R4Theme.green)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundStyle(R4Theme.muted)
                }

                Spacer()
                Text("›")
                    .font(.system(size: 34))
                    .foregroundStyle(R4Theme.green)
            }
            .padding(16)
            .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(R4Theme.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func messageCard(_ message: R4Message) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message.title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: 18) {
                Button("Edit") {
                    editingMessage = message
                    showingEditor = true
                }
                .foregroundStyle(R4Theme.green)

                Button("Delete") {
                    pendingDelete = message
                }
                .foregroundStyle(R4Theme.muted)
            }
            .font(.system(size: 15, weight: .medium))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(R4Theme.border, lineWidth: 1)
        }
    }

    private func iconBox(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 25))
            .foregroundStyle(R4Theme.green)
            .frame(width: 56, height: 56)
            .background(R4Theme.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(R4Theme.green.opacity(0.25), lineWidth: 1)
            }
    }

    private var copyrightFooter: some View {
        Text("© 2026 Morning Coffee Labs")
            .font(.system(size: 12))
            .foregroundStyle(R4Theme.muted.opacity(0.72))
            .frame(maxWidth: .infinity)
            .padding(.top, 6)
    }

    private func saveMessage(title: String, text: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        if let editingMessage,
           let index = messages.firstIndex(where: { $0.id == editingMessage.id }) {
            messages[index].title = trimmedTitle
            messages[index].text = text
            messages[index].updatedAt = Date()
        } else {
            messages.append(R4Message(title: trimmedTitle, text: text))
        }

        do {
            try R4MessageStore.saveMessages(messages)
            showingEditor = false
            self.editingMessage = nil
        } catch {
            saveError = error.localizedDescription
            reloadMessages()
        }
    }

    private func deletePendingMessage() {
        guard let pendingDelete else { return }
        let previous = messages
        messages.removeAll { $0.id == pendingDelete.id }

        do {
            try R4MessageStore.saveMessages(messages)
            self.pendingDelete = nil
        } catch {
            messages = previous
            saveError = error.localizedDescription
        }
    }

    private func reloadMessages() {
        messages = R4MessageStore.loadMessages()
    }
}

private extension View {
    func r4Card() -> some View {
        self
            .padding(16)
            .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(R4Theme.border, lineWidth: 1)
            }
    }
}

struct R4PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(R4Theme.green.opacity(configuration.isPressed ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 10))
    }
}
