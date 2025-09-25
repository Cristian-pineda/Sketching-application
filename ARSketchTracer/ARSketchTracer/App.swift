import SwiftUI

@main
struct ARSketchTracerApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(DS.Color.primary)
                .preferredColorScheme(.light) // Force light mode
                .background(DS.Color.background) // Apply design system background
        }
    }
}
