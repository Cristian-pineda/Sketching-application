import SwiftUI

extension DS {
    enum Animation {
        // MARK: - Duration
        static let fast: TimeInterval = 0.15
        static let medium: TimeInterval = 0.25
        static let slow: TimeInterval = 0.35
        static let xSlow: TimeInterval = 0.5
        
        // MARK: - Easing Curves
        static let easeInOut = SwiftUI.Animation.easeInOut(duration: medium)
        static let easeOut = SwiftUI.Animation.easeOut(duration: medium)
        static let easeIn = SwiftUI.Animation.easeIn(duration: medium)
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
        
        // MARK: - Common Animations
        static let buttonPress = SwiftUI.Animation.easeInOut(duration: fast)
        static let modalPresentation = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let fadeInOut = SwiftUI.Animation.easeInOut(duration: medium)
        static let slideTransition = SwiftUI.Animation.easeOut(duration: medium)
    }
}
