import SwiftUI

struct DSCardBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(DS.Space.l)
            .background(DS.Color.surface, in: .rect(cornerRadius: DS.Radius.medium))
            .overlay {
                RoundedRectangle(cornerRadius: DS.Radius.medium)
                    .stroke(DS.Color.border, lineWidth: 1)
            }
            .shadow(color: DS.Elevation.cardShadow(colorScheme), radius: 8, y: 4)
    }
}

extension View {
    func dsCard() -> some View { modifier(DSCardBackground()) }
}

// MARK: - Additional Card Styles

struct DSCompactCardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(DS.Space.m)
            .background(DS.Color.surface, in: .rect(cornerRadius: DS.Radius.small))
            .overlay {
                RoundedRectangle(cornerRadius: DS.Radius.small)
                    .stroke(DS.Color.border, lineWidth: 1)
            }
    }
}

extension View {
    func dsCompactCard() -> some View { modifier(DSCompactCardBackground()) }
}
