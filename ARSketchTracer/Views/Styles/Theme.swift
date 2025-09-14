import SwiftUI

enum AppTheme {
    static let primary = Color("Primary")
    static let background = Color("Background")

    static let gradient = LinearGradient(colors: [primary.opacity(0.25), .clear],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 14))
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

extension View {
    func cardBackground() -> some View { modifier(CardBackground()) }
}

