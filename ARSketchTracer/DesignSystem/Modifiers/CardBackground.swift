import SwiftUI

struct DSCardBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .padding(DS.Space.l)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: DS.Radius.medium))
            .shadow(color: DS.Elevation.cardShadow(colorScheme), radius: 8, y: 4)
    }
}

extension View {
    func dsCard() -> some View { modifier(DSCardBackground()) }
}
