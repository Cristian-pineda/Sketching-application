import Foundation
import SwiftUI

// MARK: - Drawing Catalog Models
struct DrawingCatalogItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String // For now, using system images or local assets
    let tags: [String]
    let description: String?
    
    var systemImage: String {
        // Using system images for initial implementation
        return imageName
    }
}

// MARK: - Personal Library Models
struct LibraryItem: Identifiable, Hashable, Codable {
    let id = UUID()
    var name: String
    let imageData: Data
    let dateCreated: Date
    let type: LibraryItemType
    
    enum LibraryItemType: String, Codable, CaseIterable {
        case upload = "upload"
        case generated = "generated"
        
        var displayName: String {
            switch self {
            case .upload: return "Upload"
            case .generated: return "Generated"
            }
        }
        
        var icon: String {
            switch self {
            case .upload: return "square.and.arrow.up"
            case .generated: return "wand.and.stars"
            }
        }
    }
    
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }
}

// MARK: - Illustration Generator Models
struct GenerationPrompt {
    let text: String
    let style: GenerationStyle
    
    enum GenerationStyle: String, CaseIterable {
        case realistic = "realistic"
        case cartoon = "cartoon"
        case sketch = "sketch"
        case minimalist = "minimalist"
        
        var displayName: String {
            switch self {
            case .realistic: return "Realistic"
            case .cartoon: return "Cartoon"
            case .sketch: return "Sketch"
            case .minimalist: return "Minimalist"
            }
        }
        
        var icon: String {
            switch self {
            case .realistic: return "camera"
            case .cartoon: return "face.smiling"
            case .sketch: return "pencil"
            case .minimalist: return "circle"
            }
        }
    }
}

struct GeneratedIllustration: Identifiable {
    let id = UUID()
    let prompt: String
    let style: GenerationPrompt.GenerationStyle
    let imageName: String // Will be actual image data in backend implementation
    let dateGenerated: Date
    
    var systemImage: String {
        // Placeholder system images for different types
        switch style {
        case .realistic: return "photo"
        case .cartoon: return "face.smiling.fill"
        case .sketch: return "pencil.circle.fill"
        case .minimalist: return "circle.fill"
        }
    }
}
