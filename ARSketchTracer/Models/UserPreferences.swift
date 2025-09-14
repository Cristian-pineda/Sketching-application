import Foundation
import SwiftUI

struct UserPreferences {
    @AppStorage("overlayOpacity") var overlayOpacity: Double = 0.6
}

