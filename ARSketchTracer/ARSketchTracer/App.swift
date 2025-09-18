import SwiftUI

@main
struct ARSketchTracerApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()  // ← Now shows DashboardView
                .tint(DS.Color.primary)
        }
    }
}
