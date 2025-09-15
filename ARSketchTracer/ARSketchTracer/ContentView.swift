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
                    
                    Button(action: {
                        // Typography demo action
                        print("Typography working with Merriweather fonts")
                    }) {
                        Text("Design System Demo")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    // Design system demonstration
                    VStack(spacing: DS.Space.s) {
                        Text("Typography Scale Demo")
                            .font(DS.Typography.headline)
                            .foregroundStyle(DS.Color.textPrimary)
                        
                        Text("Merriweather fonts are working correctly")
                            .font(DS.Typography.body)
                            .foregroundStyle(DS.Color.textSecondary)
                        
                        Text("Design system tokens applied")
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textTertiary)
                    }
                    .dsCard()
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
