//
//  CatalogItemPreviewView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/19/25.
//

import SwiftUI

struct CatalogItemPreviewView: View {
    let item: DashboardItemDTO
    
    private var heroImageURL: URL? {
        // Prioritize hero_image_url, fallback to trace_url
        let imagePath = item.hero_image_url ?? item.trace_url
        guard let imagePath, !imagePath.isEmpty else { return nil }
        let trimmed = imagePath.hasPrefix("catalog/") ? String(imagePath.dropFirst("catalog/".count)) : imagePath
        do {
            return try SupabaseManager.shared.client.storage.from("catalog").getPublicURL(path: trimmed)
        } catch {
            print("Error generating public URL for catalog path '\(trimmed)': \(error)")
            return nil
        }
    }
    
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
        ScrollView {
            VStack(spacing: 24) {
                // Hero Image
                AsyncImage(url: heroImageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(4/3, contentMode: .fit)
                        .overlay(
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text("Loading image...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                .frame(maxHeight: 400)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                // Item Info
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        if let styleKey = item.style_key {
                            HStack {
                                Text("Style:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(styleKey.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.blue.opacity(0.1))
                                    )
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    // Item Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About this drawing")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Ready for AR tracing with optimized overlay positioning. This drawing has been prepared with the perfect trace lines to help you create beautiful artwork.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100) // Space for the button
            }
            .padding(.vertical, 20)
        }
        .overlay(alignment: .bottom) {
            // Start Drawing Button (floating at bottom)
            VStack {
                Spacer()
                
                if let traceURL = item.trace_url,
                   let overlayURL = buildPublicURL(for: traceURL) {
                    NavigationLink(destination: CameraView(overlayURL: overlayURL)) {
                        HStack(spacing: 12) {
                            Image(systemName: "arkit")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text("Start Drawing")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .background(
                        // Gradient fade effect
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(UIColor.systemBackground).opacity(0),
                                Color(UIColor.systemBackground).opacity(0.8),
                                Color(UIColor.systemBackground)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                    )
                } else {
                    // Fallback if no trace_url available
                    Button(action: {
                        print("⚠️ No trace URL available for item: \(item.name)")
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title2)
                            
                            Text("No Trace Available")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gray)
                        .clipShape(Capsule())
                    }
                    .disabled(true)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        CatalogItemPreviewView(
            item: DashboardItemDTO(
                item_id: "test-id",
                name: "Classic Car",
                slug: "classic-car",
                category_id: "automobiles",
                style_key: "realistic",
                thumb_url: "catalog/items/car-thumb.jpg",
                trace_url: "catalog/items/car-trace.jpg",
                hero_image_url: "catalog/items/car-hero.jpg"
            )
        )
    }
}
