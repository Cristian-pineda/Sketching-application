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
    
    private func buildPublicURL(for path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        let trimmed = path.hasPrefix("catalog/") ? String(path.dropFirst("catalog/".count)) : path
        do {
            return try SupabaseManager.shared.client.storage.from("catalog").getPublicURL(path: trimmed)
        } catch {
            print("Error generating public URL for catalog path '\(trimmed)': \(error)")
            return nil
        }
    }
    
    private var bestImageURL: URL? {
        // Use best image available (thumb or hero)
        if let thumb = item.thumb_url {
            return buildPublicURL(for: thumb)
        }
        return buildPublicURL(for: item.hero_image_url)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Space.s) {
            // Thumbnail Image - 1:1 aspect ratio
            AsyncImage(url: bestImageURL) { image in
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
        name: "Beautiful Watercolor Cat",
        slug: "watercolor-cat",
        category_id: UUID(),
        primary_style_id: UUID(),
        hero_image_url: "catalog/items/cat-hero.jpg",
        thumb_url: "catalog/items/cat-thumb.jpg",
        published: true
    ))
    .padding()
}

#Preview("Multiple Item Cards") {
    HStack(spacing: 16) {
        AtomicItemCard(item: Item(
            id: UUID(),
            name: "Classic Car Design",
            slug: "classic-car",
            category_id: UUID(),
            primary_style_id: UUID(),
            hero_image_url: "catalog/items/car-hero.jpg",
            thumb_url: nil,
            published: true
        ))
        
        AtomicItemCard(item: Item(
            id: UUID(),
            name: "Mountain Landscape",
            slug: "mountain-landscape",
            category_id: UUID(),
            primary_style_id: UUID(),
            hero_image_url: "catalog/items/mountain-hero.jpg",
            thumb_url: "catalog/items/mountain-thumb.jpg",
            published: true
        ))
    }
    .padding()
}
