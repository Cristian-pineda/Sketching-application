import SwiftUI

extension DS {
    enum Elevation {
        static func cardShadow(_ colorScheme: ColorScheme) -> SwiftUI.Color {
            SwiftUI.Color.black.opacity(colorScheme == .dark ? 0.4 : 0.1)
        }
    }
}

