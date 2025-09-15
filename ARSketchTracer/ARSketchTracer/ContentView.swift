import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: DS.Space.xl) {
                // Header section
                VStack(spacing: DS.Space.m) {
                    Text("AR Sketch Tracer")
                        .font(DS.Typography.title)
                        .foregroundStyle(DS.Color.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Overlay images and trace with precision using AR technology")
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, DS.Space.xxl)

                Spacer()

                // Action buttons
                VStack(spacing: DS.Space.m) {
                    NavigationLink(destination: CameraView()) {
                        Text("Start AR Tracing")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }

                Spacer()
            }
            .padding(DS.Space.l)
            .background(DS.Color.background.ignoresSafeArea())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
