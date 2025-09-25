//
//  ItemCardSlider.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

/// Horizontal scrollable slider containing up to 8 AtomicItemCard components
/// Built using atomic design principles - composed of smaller AtomicItemCard components
struct ItemCardSlider: View {
    let items: [Item]
    let onItemTapped: (Item) -> Void
    
    /// Maximum number of items to display in the slider
    private let maxItems = 8
    
    /// Items to display (limited to maxItems)
    private var displayItems: [Item] {
        Array(items.prefix(maxItems))
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.Space.l) { // 16px spacing between cards
                ForEach(displayItems, id: \.id) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        AtomicItemCard(item: item)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button styling
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            onItemTapped(item)
                        }
                    )
                }
            }
            .padding(.horizontal, DS.Space.xl) // 24px padding on sides
        }
    }
}

#Preview("Item Card Slider - Few Items") {
    ItemCardSlider(
        items: [
            Item(
                id: UUID(),
                name: "Cute Kitten",
                slug: "cute-kitten",
                category_id: UUID(),
                primary_style_id: UUID(),
                hero_image_url: "catalog/items/kitten.jpg",
                thumb_url: nil,
                published: true
            ),
            Item(
                id: UUID(),
                name: "Vintage Car",
                slug: "vintage-car",
                category_id: UUID(),
                primary_style_id: UUID(),
                hero_image_url: "catalog/items/vintage-car.jpg",
                thumb_url: nil,
                published: true
            ),
            Item(
                id: UUID(),
                name: "Forest Scene",
                slug: "forest-scene",
                category_id: UUID(),
                primary_style_id: UUID(),
                hero_image_url: "catalog/items/forest.jpg",
                thumb_url: nil,
                published: true
            )
        ],
        onItemTapped: { item in
            print("Item tapped: \(item.name)")
        }
    )
}

#Preview("Item Card Slider - Max Items") {
    ItemCardSlider(
        items: Array(0..<12).map { index in
            Item(
                id: UUID(),
                name: "Item \(index + 1) - Some Very Long Name That Might Wrap",
                slug: "item-\(index)",
                category_id: UUID(),
                primary_style_id: UUID(),
                hero_image_url: "catalog/items/item-\(index).jpg",
                thumb_url: nil,
                published: true
            )
        },
        onItemTapped: { item in
            print("Item tapped: \(item.name)")
        }
    )
}

#Preview("Slider with 8+ items (shows only first 8)") {
    ItemCardSlider(
        items: Array(0..<12).map { index in
            Item(
                id: UUID(),
                name: "Item \(index + 1) - Some Very Long Name That Might Wrap",
                slug: "item-\(index)",
                category_id: UUID(),
                primary_style_id: UUID(),
                hero_image_url: "catalog/items/item-\(index).jpg",
                thumb_url: nil,
                published: true
            )
        },
        onItemTapped: { item in
            print("Item tapped: \(item.name)")
        }
    )
}
