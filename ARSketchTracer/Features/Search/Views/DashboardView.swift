//
//  DashboardView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
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
                    ForEach(viewModel.sections, id: \.category.id) { section in
                        CategorySectionView(section: section)
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search drawings...")
            .onSubmit(of: .search) {
                // TODO: Implement search functionality
            }
        }
        .task {
            await viewModel.load()
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
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
}
