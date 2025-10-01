//
//  AtomicItemCard.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

/// Atomic Item Card component with 1:1 aspect ratio thumbnail and item name
/// - Thumbnail: 160px width/height (dynamic based on device)
/// - Corner radius: 8px
/// - Border: 1px outline color
/// - Item name: 13px Merriweather, 8px spacing below thumbnail
struct AtomicItemCard: View {
    let item: Item
    
    private var imageURL: URL? {
        SupabaseManager.shared.client.publicImageURL(from: item.tracePath)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Space.s) {
            // Thumbnail Image - 1:1 aspect ratio
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill) // 1:1 aspect ratio
            } placeholder: {
                Rectangle()
                    .fill(DS.Color.surface)
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(DS.Color.textSecondary)
                    )
            }
            .frame(width: 160, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.small)) // 8px corner radius
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.small)
                    .stroke(DS.Color.border, lineWidth: 1) // 1px border with outline color
            )
            
            // Item Name - 13px text, 8px spacing from thumbnail
            Text(item.name)
                .font(DS.Typography.itemLabel) // 13px Merriweather using design system token
                .foregroundStyle(DS.Color.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 160, alignment: .leading)
        }
    }
}

#Preview("Single Item Card") {
    AtomicItemCard(item: Item(
        id: UUID(),
        itemId: UUID(),
        name: "Beautiful Watercolor Cat",
        slug: "watercolor-cat",
        categoryId: UUID(),
        tracePath: "previews/watercolor-cat.png",
        description: "Soft watercolor strokes to trace.",
        tags: ["cat", "watercolor"],
        difficulty: 1,
        styleId: nil,
        styleKey: "line-art",
        createdAt: "2024-06-15T09:30:00Z"
    ))
    .padding()
}

#Preview("Multiple Item Cards") {
    HStack(spacing: 16) {
        AtomicItemCard(item: Item(
            id: UUID(),
            itemId: UUID(),
            name: "Classic Car Design",
            slug: "classic-car",
            categoryId: UUID(),
            tracePath: "previews/classic-car.png",
            description: "Crisp lines ready for tracing.",
            tags: ["car", "classic"],
            difficulty: 2,
            styleId: nil,
            styleKey: "line-art",
            createdAt: "2024-07-12T10:00:00Z"
        ))
        
        AtomicItemCard(item: Item(
            id: UUID(),
            itemId: UUID(),
            name: "Mountain Landscape",
            slug: "mountain-landscape",
            categoryId: UUID(),
            tracePath: "previews/mountain-landscape.png",
            description: "Dramatic peaks captured for your next sketch.",
            tags: ["mountain", "landscape"],
            difficulty: 2,
            styleId: nil,
            styleKey: "line-art",
            createdAt: "2024-05-03T18:45:00Z"
        ))
    }
    .padding()
}
