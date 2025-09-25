//
//  MainTabView.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Search Tab
            DashboardView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(0)
            
            // My Work Tab
            MyWorkView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("My Work")
                }
                .tag(1)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .tint(DS.Color.primary) // Use design system primary color for tab selection
        .background(DS.Color.background) // Apply design system background
        .preferredColorScheme(.light) // Force light mode for tab view
    }
}

// MARK: - Placeholder Views

struct MyWorkView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: DS.Space.xl) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 60))
                    .foregroundColor(DS.Color.textTertiary)
                
                Text("My Work")
                    .font(DS.Typography.title)
                    .foregroundColor(DS.Color.textPrimary)
                
                Text("Your saved sketches and projects will appear here.")
                    .font(DS.Typography.body)
                    .foregroundColor(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .navigationTitle("My Work")
            .background(DS.Color.background)
            .preferredColorScheme(.light)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: DS.Space.xl) {
                Image(systemName: "gear.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(DS.Color.textTertiary)
                
                Text("Settings")
                    .font(DS.Typography.title)
                    .foregroundColor(DS.Color.textPrimary)
                
                Text("App preferences and configuration options will be available here.")
                    .font(DS.Typography.body)
                    .foregroundColor(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .navigationTitle("Settings")
            .background(DS.Color.background)
            .preferredColorScheme(.light)
        }
    }
}

#Preview {
    MainTabView()
}
