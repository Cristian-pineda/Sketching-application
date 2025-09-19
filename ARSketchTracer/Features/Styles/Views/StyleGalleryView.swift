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
                    ForEach(0..<viewModel.entries.count, id: \.self) { index in
                        let (item, variant) = viewModel.entries[index]
                        
                        NavigationLink(destination: destinationView(for: item, variant: variant)) {
                            StyleVariantCard(item: item, variant: variant)
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
    
    private func destinationView(for item: Item, variant: ItemStyleVariant) -> some View {
        if let traceURL = resolveTraceURL(variant.trace_url) {
            print("🎨 Style variant tapped: '\(item.name)' - Trace URL: \(variant.trace_url ?? "nil")")
            return AnyView(CameraView(overlayURL: traceURL))
        } else {
            print("❌ Failed to resolve trace URL for '\(item.name)': \(variant.trace_url ?? "nil")")
            // Return a fallback view or empty camera view
            return AnyView(CameraView())
        }
    }
    
    private func resolveTraceURL(_ tracePath: String?) -> URL? {
        guard let tracePath, !tracePath.isEmpty else { return nil }
        let trimmed = tracePath.hasPrefix("catalog/") ? String(tracePath.dropFirst("catalog/".count)) : tracePath
        do {
            return try SupabaseManager.shared.client.storage.from("catalog").getPublicURL(path: trimmed)
        } catch {
            print("Error generating public URL for catalog path '\(trimmed)': \(error)")
            return nil
        }
    }
}

// MARK: - Supporting Views

private struct StyleVariantCard: View {
    let item: Item
    let variant: ItemStyleVariant
    
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
            // Variant thumbnail image
            AsyncImage(url: buildPublicURL(for: variant.thumb_url)) { image in
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
                
                if let styleKey = variant.style_key {
                    Text(styleKey)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
