import SwiftUI

@main
struct ARSketchTracerApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .tint(DS.Color.primary)
        }
    }
}
