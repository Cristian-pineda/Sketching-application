//
//  StyleCardView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI

struct StyleCardView: View {
    let style: Style
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Style preview image placeholder
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.3),
                        Color.purple.opacity(0.3)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 120)
                .cornerRadius(12)
                .overlay(
                    Text(style.key.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(6)
                        .padding(8),
                    alignment: .topTrailing
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(style.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                if let description = style.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    StyleCardView(style: Style(
        id: UUID(),
        key: "watercolor",
        name: "Watercolor",
        description: "Soft, flowing watercolor effects",
        sort_order: 1
    ))
    .padding()
}
