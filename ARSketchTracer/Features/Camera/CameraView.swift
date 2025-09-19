import SwiftUI
import RealityKit
import ARKit

struct CameraView: View {
    @State private var overlayImage: UIImage?
    @State private var overlayOpacity: Double = 0.6
    @State private var isImageLocked: Bool = false
    @State private var isHighContrastGrayscale: Bool = false
    @State private var showControls: Bool = false
    
    private let overlayURL: URL?
    
    init(overlayImage: UIImage? = nil) {
        self._overlayImage = State(initialValue: overlayImage)
        self.overlayURL = nil
    }
    
    init(overlayURL: URL) {
        self._overlayImage = State(initialValue: nil)
        self.overlayURL = overlayURL
    }

    var body: some View {
        ZStack {
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

            TracingOverlayView(
                overlayImage: $overlayImage, 
                opacity: $overlayOpacity,
                isLocked: $isImageLocked,
                isHighContrastGrayscale: $isHighContrastGrayscale
            )
                .ignoresSafeArea()

            // New sliding control panel at bottom (full width, edge-to-edge)
            VStack {
                Spacer()
                
                SlidingControlPanel(
                    overlayImage: $overlayImage,
                    overlayOpacity: $overlayOpacity,
                    isImageLocked: $isImageLocked,
                    isHighContrastGrayscale: $isHighContrastGrayscale
                )
                .opacity(showControls ? 1.0 : 0.0)
                .offset(y: showControls ? 0 : 50)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
        .onAppear { 
            ARSessionManager.shared.startSession()
            
            // Load image from URL if provided
            if let overlayURL = overlayURL {
                Task {
                    await loadImageFromURL(overlayURL)
                }
            }
            
            // Animate in the controls with a slight delay
            withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                showControls = true
            }
        }
        .onDisappear { 
            ARSessionManager.shared.stopSession()
            // Reset controls state for clean transitions
            showControls = false
        }
    }
    
    @MainActor
    private func loadImageFromURL(_ url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                overlayImage = uiImage
            }
        } catch {
            print("Failed to load image from URL: \(error)")
        }
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
