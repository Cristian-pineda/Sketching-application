import SwiftUI

// MARK: - Hex Color Extension
extension SwiftUI.Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension DS {
    enum Color {
        // Primary brand color from Assets.xcassets
        static let primary = SwiftUI.Color("Primary")
        
        // Background colors
        static let background = SwiftUI.Color.white
        static let surface = SwiftUI.Color(hex: "#F7F7F8")
        
        // Text colors
        static let textPrimary = SwiftUI.Color.black
        static let textSecondary = SwiftUI.Color(hex: "#6E6E73")
        static let textTertiary = SwiftUI.Color(hex: "#A1A1AA")
        
        // Interactive states
        static let accent = SwiftUI.Color(hex: "#3E3E3E")
        static let highlight = SwiftUI.Color(hex: "#EBEBEB")
        static let selection = SwiftUI.Color(hex: "#D1D1D1")
        
        // Structural elements
        static let border = SwiftUI.Color(hex: "#E3E3E3")
        static let divider = SwiftUI.Color(hex: "#E5E5E5")
    }
}

