//
//  ScrollChipCollection.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import SwiftUI

/// A reusable horizontal scrolling collection for chip-style components
struct ScrollChipCollection<T: Identifiable, Content: View>: View {
    let items: [T]
    let spacing: CGFloat
    let content: (T) -> Content
    
    init(
        items: [T], 
        spacing: CGFloat = DS.Space.m,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: spacing) {
                ForEach(items, id: \.id) { item in
                    content(item)
                }
            }
            .padding(.horizontal, DS.Space.xl)
        }
    }
}
