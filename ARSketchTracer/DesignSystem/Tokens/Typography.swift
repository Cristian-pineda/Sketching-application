import SwiftUI

extension DS {
    enum Typography {
        // MARK: - Font Family
        private static let primaryFontName = "Merriweather"
        
        // MARK: - Typography Scale
        
        /// Large display text - 34pt Merriweather Bold
        static let title = Font.custom(primaryFontName, size: 34)
            .weight(.bold)
        
        /// Section headers - 20pt Merriweather Bold  
        static let headline = Font.custom(primaryFontName, size: 20)
            .weight(.bold)
            
        /// Subtitle text - 16pt Merriweather Regular
        static let subtitle = Font.custom(primaryFontName, size: 16)
            .weight(.regular)
            
        /// Body text - 14pt Merriweather Regular
        static let body = Font.custom(primaryFontName, size: 14)
            .weight(.regular)
            
        /// Button text - 16pt Merriweather Medium
        static let button = Font.custom(primaryFontName, size: 16)
            .weight(.medium)
            
        /// Small text and captions - 12pt Merriweather Regular
        static let caption = Font.custom(primaryFontName, size: 12)
            .weight(.regular)
            
        /// Very small text - 10pt Merriweather Regular
        static let footnote = Font.custom(primaryFontName, size: 10)
            .weight(.regular)
        
        // MARK: - Fallback Fonts (when Merriweather is not available)
        
        static let titleFallback = Font.system(size: 34, weight: .bold, design: .serif)
        static let headlineFallback = Font.system(size: 20, weight: .bold, design: .serif)
        static let subtitleFallback = Font.system(size: 16, weight: .regular, design: .serif)
        static let bodyFallback = Font.system(size: 14, weight: .regular, design: .serif)
        static let buttonFallback = Font.system(size: 16, weight: .medium, design: .serif)
        static let captionFallback = Font.system(size: 12, weight: .regular, design: .serif)
        static let footnoteFallback = Font.system(size: 10, weight: .regular, design: .serif)
    }
}

