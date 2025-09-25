//
//  StyleGalleryView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI
import Foundation

struct StyleGalleryView: View {
    let styleKey: String
    @StateObject private var viewModel = StyleGalleryViewModel()
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.entries, id: \.id) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            StyleItemCard(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Style Gallery")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.load(styleKey: styleKey)
        }
    }
}

// MARK: - Supporting Views

private struct StyleItemCard: View {
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Item thumbnail image
            AsyncImage(url: buildPublicURL(for: item.thumb_url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title2)
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
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    StyleGalleryView(styleKey: "watercolor")
}
