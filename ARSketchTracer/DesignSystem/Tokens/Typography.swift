import SwiftUI

extension DS {
    enum Typography {
        // MARK: - Font Family
        private static let primaryFontName = "Merriweather"
        
        // MARK: - Typography Scale (with system font fallbacks)
        
        /// Large display text - 34pt Bold
        static let title = Font.custom(primaryFontName, size: 34, relativeTo: .largeTitle)
            .weight(.bold)
        
        /// Section headers - 20pt Bold  
        static let headline = Font.custom(primaryFontName, size: 20, relativeTo: .title2)
            .weight(.bold)
            
        /// Subtitle text - 16pt Regular
        static let subtitle = Font.custom(primaryFontName, size: 16, relativeTo: .headline)
            .weight(.regular)
            
        /// Body text - 14pt Regular
        static let body = Font.custom(primaryFontName, size: 14, relativeTo: .body)
            .weight(.regular)
            
        /// Button text - 16pt Medium
        static let button = Font.custom(primaryFontName, size: 16, relativeTo: .headline)
            .weight(.medium)
            
        /// Small text and captions - 12pt Regular
        static let caption = Font.custom(primaryFontName, size: 12, relativeTo: .caption)
            .weight(.regular)
            
        /// Very small text - 10pt Regular
        static let footnote = Font.custom(primaryFontName, size: 10, relativeTo: .footnote)
            .weight(.regular)
    }
}

