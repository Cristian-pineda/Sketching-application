//
//  StyleChip.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

struct StyleChip: View {
    let style: Style
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(style.name)
                .font(DS.Typography.subtitle)
                .foregroundStyle(isSelected ? DS.Color.background : DS.Color.textPrimary)
                .padding(.horizontal, DS.Space.l)
                .padding(.vertical, DS.Space.m)
                .background(
                    Capsule()
                        .fill(isSelected ? DS.Color.primary : DS.Color.surface)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? DS.Color.primary : DS.Color.border,
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Style Chip Selected") {
    StyleChip(
        style: Style(
            id: UUID(),
            name: "Watercolor",
            key: "watercolor"
        ),
        isSelected: true,
        action: { }
    )
    .padding()
}

#Preview("Style Chip Unselected") {
    StyleChip(
        style: Style(
            id: UUID(),
            name: "Sketching",
            key: "sketching"
        ),
        isSelected: false,
        action: { }
    )
    .padding()
}
