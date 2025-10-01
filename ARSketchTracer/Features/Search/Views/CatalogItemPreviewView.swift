//
//  CatalogItemPreviewView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/19/25.
//

import SwiftUI
import UIKit

struct CatalogItemPreviewView: View {
    let item: Item
    
    private var traceImageURL: URL? {
        SupabaseManager.shared.client.publicImageURL(from: item.tracePath)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Image
                AsyncImage(url: traceImageURL) { image in
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
                        
                        if let description = item.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
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
                
                if let overlayURL = traceImageURL {
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
            item: Item(
                id: UUID(),
                itemId: UUID(),
                name: "Classic Car",
                slug: "classic-car",
                categoryId: UUID(),
                tracePath: "previews/classic-car.png",
                description: "Detailed tracing lines for the classic car illustration.",
                tags: ["car", "classic"],
                difficulty: 2,
                styleId: nil,
                styleKey: "line-art",
                createdAt: "2024-07-12T10:00:00Z"
            )
        )
    }
}
