#!/bin/bash

# Font Installation Helper Script
echo "🔍 Checking for Merriweather font files..."

FONTS_DIR="Resources/Fonts"

# Check if font files exist
if [ -f "$FONTS_DIR/Merriweather-Regular.ttf" ]; then
    echo "✅ Merriweather-Regular.ttf found"
else
    echo "❌ Merriweather-Regular.ttf missing"
    echo "   Download from: https://fonts.google.com/specimen/Merriweather"
    echo "   Copy to: $FONTS_DIR/"
fi

if [ -f "$FONTS_DIR/Merriweather-Bold.ttf" ]; then
    echo "✅ Merriweather-Bold.ttf found"
else
    echo "❌ Merriweather-Bold.ttf missing"
fi

echo ""
echo "📝 Manual Steps Required:"
echo "1. Open ARSketchTracer.xcodeproj in Xcode"
echo "2. Right-click on Resources/Fonts folder in Xcode"
echo "3. Select 'Add Files to ARSketchTracer'"
echo "4. Choose the .ttf files you copied"
echo "5. Make sure 'ARSketchTracer' target is checked"
echo "6. Click 'Add'"
echo ""
echo "The fonts will then be automatically used by the design system!"
