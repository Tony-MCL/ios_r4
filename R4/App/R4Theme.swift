import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

enum R4Theme {
    static let background = Color(hex: 0x0E1113)
    static let surface = Color(hex: 0x14181B)
    static let border = Color(hex: 0x30363A)
    static let green = Color(hex: 0x8ED12E)
    static let muted = Color(hex: 0xADB3B8)
}
