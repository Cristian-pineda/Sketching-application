import SwiftUI

extension DS {
    enum Color {
        // Primary brand and background from Assets.xcassets
        static let primary = SwiftUI.Color("Primary")
        static let background = SwiftUI.Color("Background")

        // Neutral and text colors tuned for sharp contrast (Notion-like)
        static let surface = SwiftUI.Color(.secondarySystemBackground)
        static let textPrimary = SwiftUI.Color.primary
        static let textSecondary = SwiftUI.Color.secondary
        static let border = primary.opacity(0.4)
    }
}

