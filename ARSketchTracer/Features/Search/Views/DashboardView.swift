//
//  DashboardView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI
import UIKit
import Foundation

struct DashboardView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var isLoading = true
    @State private var isNavCollapsed = false

    private let collapseThreshold: CGFloat = 0

    private var navBarStyle: MainNavigationBar.Style {
        .expanded(
            title: "Discover",
            subtitle: "Your next drawing idea",
            leading: nil,
            trailing: nil
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                DS.Color.background
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    MainNavigationBar(style: navBarStyle, isCollapsed: isNavCollapsed)
                    if isLoading {
                        loadingState
                    } else {
                        dashboardContent
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            NSLog("🚀 DashboardView: Starting task...")
            await viewModel.load()
            NSLog("✅ DashboardView: Task completed")
            DispatchQueue.main.async {
                isLoading = false
                isNavCollapsed = false
            }
        }
        .background(Color.clear)
        .preferredColorScheme(.light)
    }
    
    private var loadingState: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading data...")
                .font(.headline)
            Text("Styles: \(viewModel.styles.count)")
            Text("Sections: \(viewModel.sections.count)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.Color.background)
    }
    
    private var dashboardContent: some View {
        TrackableScrollView(onOffsetChange: handleScroll) {
            VStack(spacing: 24) {
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
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Style Cards Section
                if !viewModel.styles.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Art Styles")
                                .font(.custom("Merriweather", size: 20, relativeTo: .title2))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(orderedStyles, id: \.key) { style in
                                    StyleChip(
                                        style: style,
                                        isSelected: viewModel.selectedStyleKey == style.key,
                                        action: {
                                            Task {
                                                await viewModel.selectStyle(style.key)
                                            }
                                        }
                                    )
                                }

                                if viewModel.styles.count > 1 {
                                    Chip(
                                        title: "All",
                                        isSelected: viewModel.selectedStyleKey == nil,
                                        action: {
                                            Task {
                                                await viewModel.selectStyle(nil)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                
                // Category Sections
                ForEach(viewModel.sections, id: \.category.id) { section in
                    VStack(alignment: .leading, spacing: 16) {
                        NavigationLink(destination: CategoryDetailView(category: section.category)) {
                            HStack(spacing: 8) {
                                Text(section.category.name)
                                    .font(.custom("Merriweather", size: 20, relativeTo: .title2))
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 20)
                        
                        ItemCardSlider(items: section.items) { item in
                            print("🎯 Item tapped: '\(item.name)' from section '\(section.category.name)'")
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.Color.background)
    }

    private var orderedStyles: [Style] {
        let defaultKey = CatalogRepositoryLive.defaultStyleKey
        return viewModel.styles.sorted { lhs, rhs in
            switch (lhs.key == defaultKey, rhs.key == defaultKey) {
            case (true, false):
                return true
            case (false, true):
                return false
            default:
                return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
        }
    }

    private func handleScroll(offset: CGFloat) {
        let clampedOffset = max(0, offset)
        let shouldCollapse = clampedOffset > collapseThreshold
        guard shouldCollapse != isNavCollapsed else { return }
        withAnimation(.easeInOut) {
            isNavCollapsed = shouldCollapse
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
                        .font(.custom("Merriweather", size: 16, relativeTo: .headline))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.custom("Merriweather", size: 14, relativeTo: .subheadline))
                        .fontWeight(.regular)
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

private struct TrackableScrollView<Content: View>: UIViewRepresentable {
    let onOffsetChange: (CGFloat) -> Void
    let content: Content

    init(onOffsetChange: @escaping (CGFloat) -> Void, @ViewBuilder content: () -> Content) {
        self.onOffsetChange = onOffsetChange
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onOffsetChange: onOffsetChange)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .clear

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear

        context.coordinator.hostingController = hostingController

        scrollView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.onOffsetChange = onOffsetChange
        context.coordinator.hostingController?.rootView = content
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        var onOffsetChange: (CGFloat) -> Void
        var hostingController: UIHostingController<Content>?

        init(onOffsetChange: @escaping (CGFloat) -> Void) {
            self.onOffsetChange = onOffsetChange
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            onOffsetChange(scrollView.contentOffset.y)
        }
    }
}

#Preview {
    DashboardView()
}
