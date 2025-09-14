import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("AR Sketch Tracer")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                Text("Trace sketches using AR overlay")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)

                NavigationLink("Start AR Tracing") {
                    CameraView()
                        .navigationTitle("Tracer")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                NavigationLink("Font Test") {
                    Text("Font Test Coming Soon")
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                        .navigationTitle("Font Test")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding()
            .background(DS.Color.background.ignoresSafeArea())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
