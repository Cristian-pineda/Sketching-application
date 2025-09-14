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
                Color.black.ignoresSafeArea()
                Text("ARKit is not supported in the Simulator\nUse a real device.")
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
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
