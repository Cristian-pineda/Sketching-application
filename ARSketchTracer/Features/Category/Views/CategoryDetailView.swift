//
//  CategoryDetailView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI

// MARK: - Filter Option Model
private struct FilterOption: Identifiable {
    let id = UUID()
    let title: String
    let styleKey: String?
    let isSelected: Bool
}

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
            LazyVStack(spacing: DS.Space.xl) {
                // Style filter row
                if viewModel.hasStyles {
                    styleFilterSection
                }
                
                // Items grid
                itemsGridSection
                    .padding(.horizontal, DS.Space.xl)
            }
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
        ScrollChipCollection(items: allFilterOptions) { option in
            Chip(
                title: option.title,
                isSelected: option.isSelected
            ) {
                Task {
                    await viewModel.selectStyle(option.styleKey)
                }
            }
        }
    }
    
    private var allFilterOptions: [FilterOption] {
        var options = [FilterOption(title: "All", styleKey: nil, isSelected: viewModel.selectedStyleKey == nil)]
        let styleOptions = viewModel.styles.map { style in
            FilterOption(title: style.name, styleKey: style.key, isSelected: viewModel.selectedStyleKey == style.key)
        }
        options.append(contentsOf: styleOptions)
        return options
    }
    
    private var itemsGridSection: some View {
        VStack(alignment: .leading, spacing: DS.Space.xl) {
            HStack {
                Text("\(viewModel.items.count) Items")
                    .font(DS.Typography.headline)
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
                LazyVGrid(columns: columns, spacing: DS.Space.xl) {
                    ForEach(viewModel.items, id: \.id) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
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

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: DS.Space.xl) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(DS.Color.textSecondary)
            
            Text("No Items Found")
                .font(DS.Typography.headline)
                .fontWeight(.medium)
            
            Text("Try selecting a different style or check back later.")
                .font(DS.Typography.body)
                .foregroundColor(DS.Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, DS.Space.xxl)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationView {
        CategoryDetailView(
            category: Category(
                id: UUID(),
                name: "Animals",
                slug: "animals",
                description: "Animal drawings"
            ),
            onItemTapped: { item in
                print("Preview: Item tapped - \(item.name)")
            }
        )
    }
}
