//
//  StyleCategoriesView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

struct StyleCategoriesView: View {
    let style: Style
    @StateObject private var viewModel = StyleCategoriesViewModel()
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Style header info
                    VStack(spacing: 12) {
                        // Style preview
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 120)
                            .cornerRadius(16)
                            .overlay(
                                Text(style.key.uppercased())
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(8)
                            )
                        
                        VStack(spacing: 4) {
                            Text(style.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Browse categories available in this art style")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if viewModel.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Loading categories...")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                    } else if viewModel.categoriesWithItems.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "folder.badge.questionmark")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            
                            Text("No Categories Available")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text("No categories have items in the \(style.name) style yet. Check back later!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        // Categories grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.categoriesWithItems, id: \.category.id) { categoryData in
                                NavigationLink(destination: CategoryDetailView(
                                    category: categoryData.category,
                                    initialStyleKey: style.key,
                                    onItemTapped: { item in
                                        print("🎯 Item tapped: '\(item.name)' from style \(style.name)")
                                    }
                                )) {
                                    StyleCategoryCard(
                                        category: categoryData.category,
                                        itemCount: categoryData.itemCount,
                                        style: style
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("\(style.name) Style")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.loadCategoriesForStyle(styleKey: style.key)
        }
    }
}

// MARK: - Supporting Views

private struct StyleCategoryCard: View {
    let category: Category
    let itemCount: Int
    let style: Style
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category preview with style gradient
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.purple.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 100)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: categoryIcon(for: category.name))
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(itemCount) item\(itemCount == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let description = category.description, !description.isEmpty {
                    Text(description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func categoryIcon(for categoryName: String) -> String {
        let lowercased = categoryName.lowercased()
        switch lowercased {
        case _ where lowercased.contains("animal"): return "pawprint.fill"
        case _ where lowercased.contains("car"), _ where lowercased.contains("vehicle"): return "car.fill"
        case _ where lowercased.contains("flower"), _ where lowercased.contains("plant"): return "leaf.fill"
        case _ where lowercased.contains("building"), _ where lowercased.contains("house"): return "building.2.fill"
        case _ where lowercased.contains("food"): return "fork.knife"
        case _ where lowercased.contains("people"), _ where lowercased.contains("person"): return "person.fill"
        case _ where lowercased.contains("nature"), _ where lowercased.contains("landscape"): return "mountain.2.fill"
        case _ where lowercased.contains("abstract"): return "scribble.variable"
        default: return "folder.fill"
        }
    }
}

#Preview {
    StyleCategoriesView(style: Style(
        id: UUID(),
        name: "Watercolor",
        key: "watercolor"
    ))
}
