//
//  CatalogItemCardView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI
import UIKit

struct CatalogItemCardView: View {
    let item: Item
    
    private var imageURL: URL? {
        SupabaseManager.shared.client.publicImageURL(from: item.tracePath)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Item image
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 140)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    CatalogItemCardView(item: Item(
        id: UUID(),
        itemId: UUID(),
        name: "Sample Drawing",
        slug: "sample-item",
        categoryId: UUID(),
        tracePath: "previews/sample-item.png",
        description: "Preview description for the catalog item preview.",
        tags: ["sample", "preview"],
        difficulty: 1,
        styleId: nil,
        styleKey: "line-art",
        createdAt: "2024-09-01T12:00:00Z"
    ))
    .padding()
}
