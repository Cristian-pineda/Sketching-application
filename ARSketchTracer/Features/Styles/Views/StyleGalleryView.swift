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
    @State private var styleDisplayName: String = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: DS.Space.xl) {
                ForEach(viewModel.entries, id: \.id) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        AtomicItemCard(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, DS.Space.xl)
        }
        .navigationTitle(styleDisplayName.isEmpty ? styleKey.capitalized : styleDisplayName)
        .navigationBarTitleDisplayMode(.large)
        .task {
            // Set initial display name from styleKey (formatted)
            styleDisplayName = formatStyleKey(styleKey)
            await viewModel.load(styleKey: styleKey)
        }
    }
    
    // Helper function to format styleKey into a readable name
    private func formatStyleKey(_ key: String) -> String {
        return key.replacingOccurrences(of: "_", with: " ")
                  .replacingOccurrences(of: "-", with: " ")
                  .split(separator: " ")
                  .map { $0.capitalized }
                  .joined(separator: " ")
    }
}

#Preview {
    StyleGalleryView(styleKey: "watercolor")
}
