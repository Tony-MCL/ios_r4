import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("R4Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .accessibilityLabel("R4")

                Text("iOS foundation build")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("R4")
        }
    }
}

#Preview {
    ContentView()
}
