import SwiftUI
import RealityKit
import ARKit

struct CameraView: View {
    @State private var showControls = true
    @State private var overlayImage: UIImage? = nil
    @State private var overlayOpacity: Double = 0.6

    var body: some View {
        ZStack(alignment: .topTrailing) {
            #if targetEnvironment(simulator)
            ZStack {
                DS.Color.textPrimary.ignoresSafeArea()
                Text("ARKit is not supported in the Simulator\nUse a real device.")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.background)
                    .multilineTextAlignment(.center)
                    .padding(DS.Space.l)
                    .background(DS.Color.surface, in: .rect(cornerRadius: DS.Radius.medium))
                    .overlay {
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(DS.Color.border, lineWidth: 1)
                    }
                    .padding(DS.Space.l)
            }
            #else
            ARViewContainer(overlayImage: overlayImage)
                .ignoresSafeArea()
            #endif

            TracingOverlayView(overlayImage: $overlayImage, opacity: $overlayOpacity)
                .ignoresSafeArea()

            if showControls {
                CameraControls(showControls: $showControls,
                               overlayImage: $overlayImage,
                               overlayOpacity: $overlayOpacity)
                    .padding()
            } else {
                // Provide a persistent affordance to reopen controls when hidden
                Button {
                    showControls = true
                } label: {
                    Label("Show Controls", systemImage: "slider.horizontal.3")
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding()
            }
        }
        .onAppear { ARSessionManager.shared.startSession() }
        .onDisappear { ARSessionManager.shared.stopSession() }
    }
}

struct ARViewContainer: UIViewRepresentable {
    let overlayImage: UIImage?

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.configure(arView: arView)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // No-op for now; overlay is handled via SwiftUI overlay
    }

    final class Coordinator {
        func configure(arView: ARView) {
            ARSessionManager.shared.attach(to: arView)
        }
    }
}
