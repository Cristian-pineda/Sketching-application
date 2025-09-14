import Foundation
import ARKit
import RealityKit

enum ARHelper {
    static func makeBasicConfiguration() -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        return config
    }
}

