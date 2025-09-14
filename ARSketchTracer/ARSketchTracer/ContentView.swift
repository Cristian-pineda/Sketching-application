import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("AR Sketch Tracer")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text("Trace sketches using AR overlay")
                    .foregroundStyle(.secondary)

                NavigationLink("Start AR Tracing") {
                    CameraView()
                        .navigationTitle("Tracer")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .background(AppTheme.background.ignoresSafeArea())
            .background(AppTheme.gradient)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
