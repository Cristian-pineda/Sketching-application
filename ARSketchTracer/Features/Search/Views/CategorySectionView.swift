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
            
            // Use the new ItemCardSlider component
            ItemCardSlider(items: section.items, onItemTapped: onItemTapped)
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
                    itemId: UUID(),
                    name: "Cute Cat",
                    slug: "cat-1",
                    categoryId: UUID(),
                    tracePath: "previews/cat-1.png",
                    description: "Fun feline tracing guide.",
                    tags: ["cat", "animal"],
                    difficulty: 1,
                    styleId: nil,
                    styleKey: "line-art",
                    createdAt: "2024-06-01T12:00:00Z"
                ),
                Item(
                    id: UUID(),
                    itemId: UUID(),
                    name: "Happy Dog",
                    slug: "dog-1", 
                    categoryId: UUID(),
                    tracePath: "previews/dog-1.png",
                    description: "Smiling dog ready for tracing.",
                    tags: ["dog", "animal"],
                    difficulty: 1,
                    styleId: nil,
                    styleKey: "line-art",
                    createdAt: "2024-05-15T12:00:00Z"
                )
            ]
        ),
        onItemTapped: { item in
            print("Preview: Item tapped - \(item.name)")
        }
    )
    .padding(.vertical)
}
