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
                        Button(R4L10n.string("common.back")) { dismiss() }
                            .foregroundStyle(R4Theme.green)
                            .padding(.top, 16)

                        Text(R4L10n.string("settings.title"))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.bottom, 6)

                        expandableCard(title: R4L10n.string("settings.about_title"), expanded: $aboutExpanded) {
                            Text(R4L10n.string("settings.about_body"))
                                .foregroundStyle(R4Theme.muted)
                                .font(.system(size: 15))
                        }

                        expandableCard(title: R4L10n.string("settings.keyboard_setup_title"), expanded: $setupExpanded) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(R4L10n.string("settings.keyboard_setup_steps"))
                                    .foregroundStyle(R4Theme.muted)
                                    .font(.system(size: 15))

                                Text(R4L10n.string("settings.full_access_explanation"))
                                    .foregroundStyle(R4Theme.muted)
                                    .font(.system(size: 14))

                                Button(R4L10n.string("settings.open_r4_settings")) {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        openURL(url)
                                    }
                                }
                                .buttonStyle(R4PrimaryButtonStyle())
                            }
                        }

                        settingsCard(title: R4L10n.string("settings.links_title")) {
                            linkRow(R4L10n.string("settings.privacy_policy"), url: "https://morningcoffeelabs.no/r4/privacy")
                            linkRow(R4L10n.string("settings.terms_of_use"), url: "https://morningcoffeelabs.no/r4/terms")
                            linkRow(R4L10n.string("settings.contact"), url: "mailto:post@morningcoffeelabs.no")
                        }

                        Text(R4L10n.string("footer.copyright"))
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
