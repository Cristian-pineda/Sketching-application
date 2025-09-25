//
//  DashboardView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI
import Foundation

struct DashboardView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var isLoading = true
    
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
                        .padding(.horizontal, DS.Space.xl)
                        .padding(.top, DS.Space.l)
                        
                        // Style Cards Section
                        if !viewModel.styles.isEmpty {
                            VStack(alignment: .leading, spacing: DS.Space.l) {
                                HStack {
                                    Text("Art Styles")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, DS.Space.xl)
                                
                                ScrollChipCollection(items: viewModel.styles) { style in
                                    NavigationLink(destination: StyleGalleryView(styleKey: style.key)) {
                                        StyleChip(
                                            style: style, 
                                            isSelected: false, 
                                            action: {}
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        // Category Sections - Use simplified sections directly
                        ForEach(viewModel.sections, id: \.category.id) { section in
                            VStack(alignment: .leading, spacing: 16) {
                                // Section header
                                HStack {
                                    Text(section.category.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: CategoryDetailView(category: section.category)) {
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
                                
                                // Use the new ItemCardSlider component
                                ItemCardSlider(items: section.items) { item in
                                    // For now, just print - navigation will be handled in the component itself
                                    print("🎯 Item tapped: '\(item.name)' from section '\(section.category.name)'")
                                }
                            }
                        }
                    }
                }
            }
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
            .background(.regularMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
}