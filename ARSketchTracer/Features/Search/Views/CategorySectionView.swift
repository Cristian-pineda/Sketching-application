//
//  CategorySectionView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI

struct CategorySectionView: View {
    let section: CategorySection
    let onItemTapped: (Item) -> Void
    
    init(section: CategorySection, onItemTapped: @escaping (Item) -> Void = { _ in }) {
        self.section = section
        self.onItemTapped = onItemTapped
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text(section.category.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: CategoryDetailView(category: section.category, onItemTapped: onItemTapped)) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            
            // Horizontal scroll of items
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(section.items, id: \.id) { item in
                        Button(action: {
                            // TODO: Resolve item's selected style variant → fetch overlay_url → open ARCameraView
                            print("🎯 Item tapped: '\(item.name)' (slug: \(item.slug))")
                            onItemTapped(item)
                        }) {
                            CatalogItemCardView(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    CategorySectionView(
        section: CategorySection(
            category: Category(
                id: UUID(),
                slug: "animals",
                name: "Animals",
                description: "Animal drawings and sketches",
                thumb_url: nil,
                published: true
            ),
            items: [
                Item(
                    id: UUID(),
                    category_id: UUID(),
                    slug: "cat-1",
                    name: "Cute Cat",
                    description: "A lovely cat drawing",
                    thumb_url: nil,
                    hero_image_url: nil,
                    published: true
                ),
                Item(
                    id: UUID(),
                    category_id: UUID(),
                    slug: "dog-1",
                    name: "Happy Dog",
                    description: "A cheerful dog sketch",
                    thumb_url: nil,
                    hero_image_url: nil,
                    published: true
                )
            ]
        ),
        onItemTapped: { item in
            print("Preview: Item tapped - \(item.name)")
        }
    )
    .padding(.vertical)
}
