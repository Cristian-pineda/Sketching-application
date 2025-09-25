import Foundation
import ARKit
import Combine

/// Utility class to help recover from AR session failures and manage session lifecycle
final class ARSessionRecovery {
    static let shared = ARSessionRecovery()
    
    private var sessionFailureSubject = PassthroughSubject<ARError, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var sessionFailurePublisher: AnyPublisher<ARError, Never> {
        sessionFailureSubject.eraseToAnyPublisher()
    }
    
    private init() {
        setupFailureRecovery()
    }
    
    private func setupFailureRecovery() {
        sessionFailurePublisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleSessionFailure(error)
            }
            .store(in: &cancellables)
    }
    
    func reportSessionFailure(_ error: ARError) {
        print("ARSessionRecovery: Reporting session failure: \(error.localizedDescription)")
        sessionFailureSubject.send(error)
    }
    
    private func handleSessionFailure(_ error: ARError) {
        print("ARSessionRecovery: Handling session failure with code: \(error.code)")
        
        switch error.code {
        case .worldTrackingFailed:
            recoverFromWorldTrackingFailure()
        case .cameraUnauthorized:
            handleCameraAuthorizationFailure()
        case .sensorUnavailable, .sensorFailed:
            handleSensorFailure()
        case .invalidReferenceImage, .invalidReferenceObject:
            handleInvalidReference()
        default:
            attemptGeneralRecovery()
        }
    }
    
    private func recoverFromWorldTrackingFailure() {
        print("ARSessionRecovery: Attempting recovery from world tracking failure")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if ARWorldTrackingConfiguration.isSupported {
                ARSessionManager.shared.resetSession()
            }
        }
    }
    
    private func handleCameraAuthorizationFailure() {
        print("ARSessionRecovery: Camera authorization denied - cannot recover automatically")
        // This would need UI notification to guide user to Settings
    }
    
    private func handleSensorFailure() {
        print("ARSessionRecovery: Sensor failure - attempting restart after delay")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            ARSessionManager.shared.resetSession()
        }
    }
    
    private func handleInvalidReference() {
        print("ARSessionRecovery: Invalid reference - resetting session with clean configuration")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ARSessionManager.shared.resetSession()
        }
    }
    
    private func attemptGeneralRecovery() {
        print("ARSessionRecovery: Attempting general recovery")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            ARSessionManager.shared.resetSession()
        }
    }
    
    /// Check if current device and iOS version support the features we need
    static func checkARCapabilities() -> (supported: Bool, issues: [String]) {
        var issues: [String] = []
        
        if !ARWorldTrackingConfiguration.isSupported {
            issues.append("ARWorldTracking not supported on this device")
        }
        
        if #available(iOS 13.0, *) {
            // Check for specific iOS 13+ features
        } else {
            issues.append("iOS version may not support all AR features")
        }
        
        return (supported: issues.isEmpty, issues: issues)
    }
}
