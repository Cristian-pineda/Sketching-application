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
        VStack(alignment: .leading, spacing: 8) {
            // Item image
            AsyncImage(url: bestImageURL) { image in
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
        name: "Sample Drawing",
        slug: "sample-item",
        category_id: UUID(),
        primary_style_id: UUID(),
        hero_image_url: "",
        thumb_url: nil,
        published: true
    ))
    .padding()
}
