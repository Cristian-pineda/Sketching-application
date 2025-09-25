//
//  Chip.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

/// A generic, reusable chip component using design system tokens
struct Chip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    init(
        title: String,
        isSelected: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Typography.button)
                .foregroundStyle(isSelected ? DS.Color.background : DS.Color.textPrimary)
                .padding(.horizontal, DS.Space.l)
                .padding(.vertical, DS.Space.m)
                .background(
                    RoundedRectangle(cornerRadius: DS.Radius.pill)
                        .fill(isSelected ? DS.Color.primary : DS.Color.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: DS.Radius.pill)
                                .stroke(
                                    isSelected ? DS.Color.primary : DS.Color.border,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            Chip(title: "Unselected") { }
            Chip(title: "Selected", isSelected: true) { }
        }
        
        HStack(spacing: 12) {
            Chip(title: "Animals") { }
            Chip(title: "Nature") { }
            Chip(title: "Abstract") { }
        }
    }
    .padding()
}
