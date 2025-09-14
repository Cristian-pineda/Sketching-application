import Foundation
import SwiftUI

enum TracingTools {
    static func clampOpacity(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}

