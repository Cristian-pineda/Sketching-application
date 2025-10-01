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
            HStack(alignment: .top, spacing: DS.Space.l) { // 16px spacing between cards, top-aligned
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
                itemId: UUID(),
                name: "Cute Kitten",
                slug: "cute-kitten",
                categoryId: UUID(),
                tracePath: "previews/kitten.png",
                description: "Adorable kitten tracing reference.",
                tags: ["kitten", "animal"],
                difficulty: 1,
                styleId: nil,
                styleKey: "line-art",
                createdAt: "2024-05-10T12:00:00Z"
            ),
            Item(
                id: UUID(),
                itemId: UUID(),
                name: "Vintage Car",
                slug: "vintage-car",
                categoryId: UUID(),
                tracePath: "previews/vintage-car.png",
                description: "Detailed vintage vehicle for tracing.",
                tags: ["car", "vintage"],
                difficulty: 2,
                styleId: nil,
                styleKey: "line-art",
                createdAt: "2024-04-22T12:00:00Z"
            ),
            Item(
                id: UUID(),
                itemId: UUID(),
                name: "Forest Scene",
                slug: "forest-scene",
                categoryId: UUID(),
                tracePath: "previews/forest-scene.png",
                description: "Layered trees with depth guidelines.",
                tags: ["forest", "landscape"],
                difficulty: 1,
                styleId: nil,
                styleKey: "line-art",
                createdAt: "2024-03-01T12:00:00Z"
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
                itemId: UUID(),
                name: "Item \(index + 1) - Some Very Long Name That Might Wrap",
                slug: "item-\(index)",
                categoryId: UUID(),
                tracePath: "previews/item-\(index).png",
                description: "Placeholder description for preview item \(index + 1).",
                tags: ["preview"],
                difficulty: (index % 3) + 1,
                styleId: nil,
                styleKey: "line-art",
                createdAt: "2024-01-01T00:00:00Z"
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
                itemId: UUID(),
                name: "Item \(index + 1) - Some Very Long Name That Might Wrap",
                slug: "item-\(index)",
                categoryId: UUID(),
                tracePath: "previews/item-\(index).png",
                description: "Placeholder description for preview item \(index + 1).",
                tags: ["preview"],
                difficulty: (index % 3) + 1,
                styleId: nil,
                styleKey: "line-art",
                createdAt: "2024-01-01T00:00:00Z"
            )
        },
        onItemTapped: { item in
            print("Item tapped: \(item.name)")
        }
    )
}
