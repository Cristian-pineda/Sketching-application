//
//  CategoryDetailView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI

struct CategoryDetailView: View {
    @StateObject private var viewModel: CategoryDetailViewModel
    let onItemTapped: (Item) -> Void
    
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    init(category: Category, initialStyleKey: String? = nil, onItemTapped: @escaping (Item) -> Void = { _ in }) {
        self._viewModel = StateObject(wrappedValue: CategoryDetailViewModel(
            category: category,
            initialStyleKey: initialStyleKey
        ))
        self.onItemTapped = onItemTapped
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Style filter row
                if viewModel.hasStyles {
                    styleFilterSection
                }
                
                // Items grid
                itemsGridSection
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle(viewModel.categoryName)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadData()
        }
        .overlay {
            if viewModel.isLoading && viewModel.items.isEmpty {
                ProgressView("Loading items...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    private var styleFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter by Style")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // "All" chip
                    StyleFilterChip(
                        title: "All",
                        isSelected: viewModel.selectedStyleKey == nil
                    ) {
                        Task {
                            await viewModel.selectStyle(nil as String?)
                        }
                    }
                    
                    // Style chips
                    ForEach(viewModel.styles, id: \.id) { style in
                        StyleFilterChip(
                            title: style.name,
                            isSelected: viewModel.selectedStyleKey == style.key
                        ) {
                            Task {
                                await viewModel.selectStyle(style.key)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var itemsGridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(viewModel.items.count) Items")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if viewModel.items.isEmpty && !viewModel.isLoading {
                EmptyStateView()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items, id: \.id) { item in
                        Button(action: {
                            // TODO: Resolve item's selected style variant → fetch overlay_url → open ARCameraView
                            print("🎯 Item tapped in category '\(viewModel.categoryName)': '\(item.name)' (slug: \(item.slug))")
                            onItemTapped(item)
                        }) {
                            CatalogItemCardView(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

private struct StyleFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No Items Found")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Try selecting a different style or check back later.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        CategoryDetailView(
            category: Category(
                id: UUID(),
                slug: "animals",
                name: "Animals",
                description: "Animal drawings",
                thumb_url: nil as String?,
                published: true
            ),
            onItemTapped: { item in
                print("Preview: Item tapped - \(item.name)")
            }
        )
    }
}
