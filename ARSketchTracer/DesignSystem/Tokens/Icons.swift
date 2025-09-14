import SwiftUI

extension DS {
    enum Icon {
        // MARK: - Camera & AR
        static let camera = "camera"
        static let cameraFill = "camera.fill"
        static let viewfinder = "viewfinder.circle"
        static let arkit = "arkit"
        
        // MARK: - Media
        static let photo = "photo"
        static let photoStack = "photo.stack"
        static let square = "square.and.arrow.up"
        static let trash = "trash"
        static let xmark = "xmark.circle"
        
        // MARK: - Controls
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let stop = "stop.fill"
        static let sliders = "slider.horizontal.3"
        static let opacity = "circle.lefthalf.filled"
        
        // MARK: - Navigation
        static let chevronUp = "chevron.up"
        static let chevronDown = "chevron.down"
        static let chevronLeft = "chevron.left"
        static let chevronRight = "chevron.right"
        static let back = "arrow.left"
        
        // MARK: - Actions
        static let add = "plus"
        static let edit = "pencil"
        static let settings = "gear"
        static let info = "info.circle"
        static let help = "questionmark.circle"
        
        // MARK: - States
        static let checkmark = "checkmark"
        static let warning = "exclamationmark.triangle"
        static let error = "xmark.circle.fill"
        static let success = "checkmark.circle.fill"
        
        // MARK: - Helper Functions
        static func systemImage(_ name: String, size: CGFloat = 16) -> Image {
            Image(systemName: name)
                .font(.system(size: size))
        }
        
        static func iconButton(_ name: String, size: CGFloat = 20) -> Image {
            Image(systemName: name)
                .font(.system(size: size, weight: .medium))
        }
    }
}
