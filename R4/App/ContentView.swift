import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("R4")
                    .font(.largeTitle.bold())

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
