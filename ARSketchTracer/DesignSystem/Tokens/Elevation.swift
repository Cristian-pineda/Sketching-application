import SwiftUI

extension DS {
    enum Elevation {
        static func cardShadow(_ colorScheme: ColorScheme) -> SwiftUI.Color {
            DS.Color.textPrimary.opacity(colorScheme == .dark ? 0.4 : 0.1)
        }
        
        static let subtle = SwiftUI.Color(hex: "#00000008") // Very light shadow
        static let medium = SwiftUI.Color(hex: "#00000015") // Medium shadow
        static let strong = SwiftUI.Color(hex: "#00000025") // Strong shadow
    }
}

