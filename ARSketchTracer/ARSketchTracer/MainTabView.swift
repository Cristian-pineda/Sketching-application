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
        .tint(.blue) // Customize tab selection color
    }
}

// MARK: - Placeholder Views

struct MyWorkView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "folder.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("My Work")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your saved sketches and projects will appear here.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .navigationTitle("My Work")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "gear.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("App preferences and configuration options will be available here.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    MainTabView()
}
