import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var aboutExpanded = false
    @State private var setupExpanded = true

    var body: some View {
        NavigationStack {
            ZStack {
                R4Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Button("← Back") { dismiss() }
                            .foregroundStyle(R4Theme.green)
                            .padding(.top, 16)

                        Text("Settings and info")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.bottom, 6)

                        expandableCard(title: "About R4", expanded: $aboutExpanded) {
                            Text("R4 is a local message archive designed to keep frequently used text immediately available while you stay in another app. Create and manage messages in R4, then switch to R4 Keyboard in any normal text field. Tap a saved message title and R4 inserts the full text at the cursor. R4 preserves emoji, line breaks, blank lines and spaces, does not alter your text, and does not send anything on your behalf.")
                                .foregroundStyle(R4Theme.muted)
                                .font(.system(size: 15))
                        }

                        expandableCard(title: "R4 Keyboard setup", expanded: $setupExpanded) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("1. Open iPhone Settings\n2. General → Keyboard → Keyboards\n3. Tap Add New Keyboard…\n4. Select R4 Keyboard\n5. Open R4 Keyboard in the keyboard list\n6. Enable Allow Full Access")
                                    .foregroundStyle(R4Theme.muted)
                                    .font(.system(size: 15))

                                Text("Full Access allows the R4 keyboard extension to read the saved messages from R4's private shared App Group. R4 does not transmit your saved messages or unrelated keyboard input.")
                                    .foregroundStyle(R4Theme.muted)
                                    .font(.system(size: 14))

                                Button("Open R4 settings") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        openURL(url)
                                    }
                                }
                                .buttonStyle(R4PrimaryButtonStyle())
                            }
                        }

                        settingsCard(title: "Links") {
                            linkRow("Privacy policy", url: "https://morningcoffeelabs.no/r4/privacy")
                            linkRow("Terms of use", url: "https://morningcoffeelabs.no/r4/terms")
                            linkRow("Contact", url: "mailto:post@morningcoffeelabs.no")
                        }

                        Text("© 2026 Morning Coffee Labs")
                            .font(.system(size: 12))
                            .foregroundStyle(R4Theme.muted.opacity(0.72))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }

    private func expandableCard<Content: View>(title: String, expanded: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation { expanded.wrappedValue.toggle() }
            } label: {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: expanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .foregroundStyle(R4Theme.green)
                }
            }
            .buttonStyle(.plain)

            if expanded.wrappedValue {
                content()
            }
        }
        .padding(16)
        .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(R4Theme.border, lineWidth: 1)
        }
    }

    private func settingsCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            content()
        }
        .padding(16)
        .background(R4Theme.surface, in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(R4Theme.border, lineWidth: 1)
        }
    }

    private func linkRow(_ title: String, url: String) -> some View {
        Button {
            if let url = URL(string: url) {
                openURL(url)
            }
        } label: {
            HStack {
                Text(title)
                    .foregroundStyle(R4Theme.green)
                Spacer()
                Text("›")
                    .foregroundStyle(R4Theme.green)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}
