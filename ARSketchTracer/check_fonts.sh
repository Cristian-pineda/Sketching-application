#!/bin/bash

# Font installation verification script for AR Sketch Tracer

echo "🔤 AR Sketch Tracer Font Installation Checker"
echo "============================================="

PROJECT_DIR="/Users/cristianpineda/Coding/Projects/Sketching application/ARSketchTracer"
FONTS_DIR="$PROJECT_DIR/Resources/Fonts"

echo ""
echo "📁 Checking font files in Resources/Fonts/..."
if [ -d "$FONTS_DIR" ]; then
    cd "$FONTS_DIR"
    echo "✅ Fonts directory exists"
    
    if [ -f "Merriweather-VariableFont_opsz,wdth,wght.ttf" ]; then
        echo "✅ Merriweather Variable Font found"
    else
        echo "❌ Merriweather Variable Font NOT found"
    fi
    
    if [ -f "Merriweather-Italic-VariableFont_opsz,wdth,wght.ttf" ]; then
        echo "✅ Merriweather Italic Variable Font found"
    else
        echo "❌ Merriweather Italic Variable Font NOT found"
    fi
else
    echo "❌ Fonts directory does not exist"
fi

echo ""
echo "📝 Checking Info.plist configuration..."
INFO_PLIST="$PROJECT_DIR/Info.plist"
if [ -f "$INFO_PLIST" ]; then
    if grep -q "UIAppFonts" "$INFO_PLIST"; then
        echo "✅ UIAppFonts key found in Info.plist"
        
        if grep -q "Merriweather-VariableFont_opsz,wdth,wght.ttf" "$INFO_PLIST"; then
            echo "✅ Merriweather Variable Font referenced in Info.plist"
        else
            echo "❌ Merriweather Variable Font NOT referenced in Info.plist"
        fi
        
        if grep -q "Merriweather-Italic-VariableFont_opsz,wdth,wght.ttf" "$INFO_PLIST"; then
            echo "✅ Merriweather Italic Variable Font referenced in Info.plist"
        else
            echo "❌ Merriweather Italic Variable Font NOT referenced in Info.plist"
        fi
    else
        echo "❌ UIAppFonts key NOT found in Info.plist"
    fi
else
    echo "❌ Info.plist not found"
fi

echo ""
echo "🔧 Checking Xcode project configuration..."
PBXPROJ="$PROJECT_DIR/ARSketchTracer.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ" ]; then
    if grep -q "Merriweather" "$PBXPROJ"; then
        echo "✅ Merriweather fonts referenced in Xcode project"
    else
        echo "❌ Merriweather fonts NOT referenced in Xcode project"
        echo ""
        echo "🚨 ACTION REQUIRED:"
        echo "   1. In Xcode, right-click on 'Resources' folder"
        echo "   2. Select 'Add Files to ARSketchTracer'"
        echo "   3. Navigate to Resources/Fonts/ and select both .ttf files"
        echo "   4. Make sure 'Add to target: ARSketchTracer' is checked"
        echo "   5. Click 'Add'"
    fi
else
    echo "❌ Xcode project file not found"
fi

echo ""
echo "🏗️  Building project to check for errors..."
cd "$PROJECT_DIR"
xcodebuild -project ARSketchTracer.xcodeproj -scheme ARSketchTracer -destination 'platform=iOS Simulator,name=iPhone 16' build -quiet

if [ $? -eq 0 ]; then
    echo "✅ Project builds successfully"
else
    echo "❌ Project build failed"
fi

echo ""
echo "📱 Next steps:"
echo "   1. Open ARSketchTracer.xcodeproj in Xcode"
echo "   2. Add the font files to the project if not already added"
echo "   3. Run the app and check the 'Font Test' screen"
echo "   4. Verify Merriweather fonts are displayed correctly"
echo ""
