import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DS.Typography.button)
            .foregroundStyle(DS.Color.background)
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

// MARK: - Additional Button Styles

struct TertiaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DS.Typography.subtitle)
            .foregroundStyle(DS.Color.textSecondary)
            .padding(.vertical, DS.Space.s)
            .padding(.horizontal, DS.Space.m)
            .background(DS.Color.highlight, in: .capsule)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DS.Typography.button)
            .foregroundStyle(DS.Color.background)
            .padding(.vertical, DS.Space.m)
            .padding(.horizontal, DS.Space.l)
            .frame(maxWidth: .infinity)
            .background(SwiftUI.Color(hex: "#DC2626"), in: .capsule) // Red-600
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
