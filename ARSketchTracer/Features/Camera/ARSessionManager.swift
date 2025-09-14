import Foundation
import ARKit
import RealityKit

final class ARSessionManager: NSObject, ARSessionDelegate {
    static let shared = ARSessionManager()

    private(set) var arView: ARView?

    func attach(to arView: ARView) {
        self.arView = arView
        arView.session.delegate = self
        guard ARWorldTrackingConfiguration.isSupported else { return }

        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        arView.automaticallyConfigureSession = false
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    func startSession() {
        guard let arView, ARWorldTrackingConfiguration.isSupported else { return }
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        arView.session.run(config, options: [])
    }

    func stopSession() {
        arView?.session.pause()
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARSession error: \(error.localizedDescription)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("ARSession interrupted")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        print("ARSession interruption ended")
    }
}
