import SwiftUI

extension DS {
    enum Gradients {
        static let appBackground = LinearGradient(
            colors: [DS.Color.primary.opacity(0.25), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

