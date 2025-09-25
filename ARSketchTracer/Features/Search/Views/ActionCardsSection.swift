//
//  ActionCardsSection.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

struct ActionCardsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            ActionCard(
                title: "Upload Your Own",
                subtitle: "Trace from your photos",
                icon: "photo.badge.plus",
                gradientColors: [.blue, .cyan]
            ) {
                // TODO: Navigate to upload flow
            }
            
            ActionCard(
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
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradientColors: [Color]
    let action: () -> Void
    
    var body: some View {
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
    ActionCardsSection()
}
