//
//  DashboardView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI
import Supabase

struct DashboardView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var isLoading = true
    
    // Group dashboard items by category_id and match with category info
    private var dashboardCategories: [(category: Category, items: [DashboardItemDTO])] {
        let grouped = Dictionary(grouping: viewModel.dashboardItems) { $0.category_id }
        NSLog("🏗️ DashboardView: Grouped \(viewModel.dashboardItems.count) dashboard items into \(grouped.count) categories")
        NSLog("🏗️ DashboardView: Available sections: \(viewModel.sections.count)")
        NSLog("🏗️ DashboardView: Available styles: \(viewModel.styles.count)")
        
        // Match dashboard items with category info from sections
        var result: [(category: Category, items: [DashboardItemDTO])] = []
        for (categoryId, items) in grouped {
            if let categorySection = viewModel.sections.first(where: { $0.category.id.uuidString.lowercased() == categoryId.lowercased() }) {
                result.append((category: categorySection.category, items: items))
                NSLog("🏗️ DashboardView: Matched category '\(categorySection.category.name)' with \(items.count) items")
            } else {
                NSLog("❌ DashboardView: No category found for categoryId: \(categoryId)")
            }
        }
        return result.sorted { $0.category.name < $1.category.name }
    }
    
    var body: some View {
        NavigationView {
            if isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading data...")
                        .font(.headline)
                    Text("Styles: \(viewModel.styles.count)")
                    Text("Sections: \(viewModel.sections.count)")  
                    Text("Dashboard Items: \(viewModel.dashboardItems.count)")
                    Text("Dashboard Categories: \(dashboardCategories.count)")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Action Cards Section
                    VStack(spacing: 16) {
                        actionCard(
                            title: "Upload Your Own",
                            subtitle: "Trace from your photos",
                            icon: "photo.badge.plus",
                            gradientColors: [.blue, .cyan]
                        ) {
                            // TODO: Navigate to upload flow
                        }
                        
                        actionCard(
                            title: "Generate Something New",
                            subtitle: "AI-powered creation",
                            icon: "sparkles",
                            gradientColors: [.purple, .pink]
                        ) {
                            // TODO: Navigate to generation flow
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Style Cards Section
                    if !viewModel.styles.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Art Styles")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(viewModel.styles, id: \.id) { style in
                                        Button(action: {
                                            // TODO: Navigate to style view
                                        }) {
                                            StyleCardView(style: style)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    // Category Sections
                    ForEach(dashboardCategories, id: \.category.id) { categoryData in
                        let category = categoryData.category
                        let items = categoryData.items
                        
                        VStack(alignment: .leading, spacing: 16) {
                                // Section header
                                HStack {
                                    Text(category.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // TODO: Navigate to category detail
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("See All")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                        }
                                        .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Horizontal scroll of items
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(items, id: \.item_id) { item in
                                            Button(action: {
                                                print("🎯 Item tapped from dashboard: '\(item.name)' (slug: \(item.slug))")
                                            }) {
                                                DashboardItemCardView(item: item)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                }
            }
                
            Spacer()
        }
        .navigationTitle("Discover")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search drawings...")
        .onSubmit(of: .search) {
            // TODO: Implement search functionality
        }
        .task {
            NSLog("🚀 DashboardView: Starting task...")
            await viewModel.load()
            NSLog("✅ DashboardView: Task completed")
            isLoading = false
        }
    }
    
    private func actionCard(
        title: String,
        subtitle: String,
        icon: String,
        gradientColors: [Color],
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - DashboardItemCardView

private struct DashboardItemCardView: View {
    let item: DashboardItemDTO
    
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
            // Item image
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
        .frame(width: 140)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    DashboardView()
}
