import Foundation
import ARKit
import RealityKit

final class ARSessionManager: NSObject, ARSessionDelegate {
    static let shared = ARSessionManager()
    
    private var arView: ARView?
    private var sessionRunning = false
    private var sessionConfiguration: ARWorldTrackingConfiguration?
    
    private override init() {
        super.init()
    }

    func attach(to arView: ARView) {
        // Clean up any previous ARView
        cleanupCurrentSession()
        
        self.arView = arView
        arView.session.delegate = self
        arView.automaticallyConfigureSession = false
        
        // Prepare configuration but don't start session immediately
        setupConfiguration()
    }
    
    private func setupConfiguration() {
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        sessionConfiguration = config
    }

    func startSession() {
        guard validateSessionState() else {
            print("ARSessionManager: Cannot start session - invalid state")
            return
        }
        
        guard let arView = arView,
              let config = sessionConfiguration else { 
            print("ARSessionManager: Cannot start session - missing arView or config")
            return 
        }
        
        guard !sessionRunning else { 
            print("ARSessionManager: Session already running")
            return 
        }
        
        print("ARSessionManager: Starting AR session")
        sessionRunning = true
        
        // Create a fresh copy of the configuration to avoid reuse issues
        let freshConfig = ARWorldTrackingConfiguration()
        freshConfig.environmentTexturing = config.environmentTexturing
        freshConfig.frameSemantics = config.frameSemantics
        
        // Use resetTracking and removeExistingAnchors to ensure clean start
        arView.session.run(freshConfig, options: [.resetTracking, .removeExistingAnchors])
    }

    func stopSession() {
        guard let arView = arView, sessionRunning else { return }
        
        print("ARSessionManager: Stopping AR session")
        sessionRunning = false
        arView.session.pause()
    }
    
    func resetSession() {
        guard let arView = arView else {
            print("ARSessionManager: Cannot reset session - no ARView")
            return
        }
        
        print("ARSessionManager: Resetting AR session")
        
        // Stop current session first
        if sessionRunning {
            arView.session.pause()
            sessionRunning = false
        }
        
        // Create a completely fresh configuration
        guard ARWorldTrackingConfiguration.isSupported else {
            print("ARSessionManager: Cannot reset session - ARWorldTracking not supported")
            return
        }
        
        let newConfig = ARWorldTrackingConfiguration()
        newConfig.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            newConfig.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        sessionConfiguration = newConfig
        
        // Small delay to ensure session is fully paused
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let currentArView = self.arView {
                self.sessionRunning = true
                currentArView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
                print("ARSessionManager: Session reset complete")
            }
        }
    }
    
    private func cleanupCurrentSession() {
        if let arView = arView, sessionRunning {
            print("ARSessionManager: Cleaning up previous session")
            arView.session.pause()
            arView.session.delegate = nil
        }
        sessionRunning = false
        arView = nil
        sessionConfiguration = nil
    }
    
    func detachFromCurrentView() {
        cleanupCurrentSession()
    }
    
    // MARK: - Session Status
    
    var isSessionRunning: Bool {
        return sessionRunning
    }
    
    var hasValidConfiguration: Bool {
        return sessionConfiguration != nil
    }
    
    var canStartSession: Bool {
        return arView != nil && sessionConfiguration != nil && !sessionRunning
    }
    
    func validateSessionState() -> Bool {
        guard let arView = arView else {
            print("ARSessionManager: Validation failed - no ARView")
            return false
        }
        
        guard sessionConfiguration != nil else {
            print("ARSessionManager: Validation failed - no configuration")
            return false
        }
        
        // Check if the session is in a valid state to run
        if arView.session.currentFrame == nil && sessionRunning {
            print("ARSessionManager: Warning - session marked as running but no current frame")
        }
        
        return true
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARSessionManager: AR session failed with error: \(error.localizedDescription)")
        sessionRunning = false
        
        // Handle specific ARKit errors and attempt recovery
        if let arError = error as? ARError {
            ARSessionRecovery.shared.reportSessionFailure(arError)
        }
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("ARSessionManager: AR session was interrupted")
        sessionRunning = false
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        print("ARSessionManager: AR session interruption ended")
        
        // Automatically restart the session when interruption ends
        if let arView = arView, let config = sessionConfiguration {
            print("ARSessionManager: Restarting session after interruption")
            sessionRunning = true
            arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            print("ARSessionManager: Tracking state normal")
        case .limited(let reason):
            print("ARSessionManager: Tracking limited: \(reason)")
        case .notAvailable:
            print("ARSessionManager: Tracking not available")
        }
    }
}
