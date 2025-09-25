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
                name: "Animals",
                slug: "animals",
                description: "Animal drawings and sketches"
            ),
            items: [
                Item(
                    id: UUID(),
                    name: "Cute Cat",
                    slug: "cat-1",
                    category_id: UUID(),
                    primary_style_id: UUID(),
                    hero_image_url: "",
                    thumb_url: nil,
                    published: true
                ),
                Item(
                    id: UUID(),
                    name: "Happy Dog",
                    slug: "dog-1", 
                    category_id: UUID(),
                    primary_style_id: UUID(),
                    hero_image_url: "",
                    thumb_url: nil,
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
