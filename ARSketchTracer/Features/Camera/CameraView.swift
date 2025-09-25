import SwiftUI
import RealityKit
import ARKit

struct CameraView: View {
    @State private var overlayImage: UIImage?
    @State private var overlayOpacity: Double = 0.6
    @State private var isImageLocked: Bool = false
    @State private var isHighContrastGrayscale: Bool = false
    @State private var showControls: Bool = false
    @State private var sessionInitialized: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase
    
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
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
        .onAppear { 
            print("CameraView: onAppear - initializing AR session")
            
            if !sessionInitialized {
                sessionInitialized = true
                
                // Small delay to ensure view is fully loaded
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    startARSession()
                }
            } else {
                // View reappeared, restart session
                startARSession()
            }
        }
        .onDisappear { 
            print("CameraView: onDisappear - stopping AR session")
            stopARSession()
            
            // Reset controls state
            showControls = false
        }
        .onChange(of: scenePhase) { phase in
            handleScenePhaseChange(phase)
        }
    }
    
    // MARK: - AR Session Management
    
    private func startARSession() {
        guard ARSessionManager.shared.canStartSession else {
            print("CameraView: Cannot start AR session - invalid state")
            return
        }
        
        ARSessionManager.shared.startSession()
        
        // Animate in the custom AR controls with a delay
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            showControls = true
        }
        
        // Load image from URL if provided
        if let overlayURL = overlayURL {
            Task {
                await loadImageFromURL(overlayURL)
            }
        }
    }
    
    private func stopARSession() {
        ARSessionManager.shared.stopSession()
    }
    
    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            print("CameraView: Scene became active")
            // Restart session if it was interrupted
            if sessionInitialized && !ARSessionManager.shared.isSessionRunning {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    startARSession()
                }
            }
        case .inactive:
            print("CameraView: Scene became inactive")
            // Pause session to free resources
            stopARSession()
        case .background:
            print("CameraView: Scene moved to background")
            stopARSession()
        @unknown default:
            break
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

    func makeCoordinator() -> Coordinator { 
        Coordinator() 
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.configure(arView: arView)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // No-op for now; overlay is handled via SwiftUI overlay
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        coordinator.cleanup()
    }

    final class Coordinator {
        func configure(arView: ARView) {
            ARSessionManager.shared.attach(to: arView)
        }
        
        func cleanup() {
            print("ARViewContainer.Coordinator: Cleaning up AR session")
            ARSessionManager.shared.detachFromCurrentView()
        }
    }
}
