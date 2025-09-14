import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DS.Typography.button)
            .foregroundStyle(.white)
            .padding(.vertical, DS.Space.m)
            .padding(.horizontal, DS.Space.l)
            .frame(maxWidth: .infinity)
            .background(DS.Color.primary, in: .capsule)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DS.Typography.subtitle)
            .foregroundStyle(DS.Color.primary)
            .padding(.vertical, DS.Space.s + 2)
            .padding(.horizontal, DS.Space.m + 4)
            .background(
                Capsule()
                    .stroke(DS.Color.border, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
