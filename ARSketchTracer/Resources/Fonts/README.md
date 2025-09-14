# Font Installation Guide

## Merriweather Font Setup

This app uses **Merriweather** by Sorkin Type as the primary typeface. Follow these steps to add the fonts to your project:

### 1. Download Merriweather Fonts

1. Go to [Google Fonts - Merriweather](https://fonts.google.com/specimen/Merriweather)
2. Click "Download family" to get the ZIP file
3. Extract the ZIP file

### 2. Add Font Files to Project

From the extracted folder, copy these font files to `Resources/Fonts/`:

**Required font files:**
- `Merriweather-Regular.ttf`
- `Merriweather-Bold.ttf` 
- `Merriweather-Medium.ttf` (if available)

**Optional italic variants:**
- `Merriweather-Italic.ttf`
- `Merriweather-BoldItalic.ttf`

### 3. Add Fonts to Xcode Project

1. In Xcode, right-click on the `Resources/Fonts` folder
2. Select "Add Files to ARSketchTracer"
3. Choose all the `.ttf` files you downloaded
4. Make sure "Add to target: ARSketchTracer" is checked

### 4. Update Info.plist

Add the font files to your `Info.plist`:

```xml
<key>UIAppFonts</key>
<array>
    <string>Merriweather-Regular.ttf</string>
    <string>Merriweather-Bold.ttf</string>
    <string>Merriweather-Medium.ttf</string>
    <string>Merriweather-Italic.ttf</string>
    <string>Merriweather-BoldItalic.ttf</string>
</array>
```

### 5. Verify Installation

The design system will automatically use Merriweather fonts once properly installed. If the fonts are not available, the system will fall back to serif system fonts.

### Font Usage in Design System

The typography system is now configured to use Merriweather:

```swift
DS.Typography.title    // 34pt Merriweather Bold
DS.Typography.headline // 20pt Merriweather Bold  
DS.Typography.subtitle // 16pt Merriweather Regular
DS.Typography.body     // 14pt Merriweather Regular
DS.Typography.button   // 16pt Merriweather Medium
DS.Typography.caption  // 12pt Merriweather Regular
DS.Typography.footnote // 10pt Merriweather Regular
```

### About Merriweather

Merriweather is a serif typeface designed by Sorkin Type, optimized for reading on screens. It features:
- Excellent readability at various sizes
- Clean, modern serif design
- Good contrast and character spacing
- Professional appearance suitable for AR applications
