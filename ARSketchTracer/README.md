# AR Sketch Tracer

An iOS app that uses ARKit to overlay sketches and images for tracing in augmented reality.

## Project Structure

```
ARSketchTracer/
├── ARSketchTracer/           # Main app files
│   ├── App.swift            # App entry point
│   └── ContentView.swift    # Main content view
├── DesignSystem/            # Centralized design system
│   ├── DesignSystem.swift   # Main DS namespace
│   ├── Components/          # Reusable UI components
│   │   └── ButtonStyles.swift
│   ├── Modifiers/           # SwiftUI view modifiers
│   │   └── CardBackground.swift
│   └── Tokens/              # Design tokens
│       ├── ColorTokens.swift
│       ├── Elevation.swift
│       ├── Gradients.swift
│       ├── Radius.swift
│       ├── Spacing.swift
│       └── Typography.swift
├── Features/                # Feature-specific modules
│   ├── Camera/              # AR camera functionality
│   │   ├── ARSessionManager.swift
│   │   ├── CameraControls.swift
│   │   └── CameraView.swift
│   └── Tracing/             # Image overlay tracing
│       ├── TracingOverlayView.swift
│       └── TracingTools.swift
├── Models/                  # Data models
│   └── UserPreferences.swift
├── Resources/               # Assets and resources
│   └── Assets.xcassets/
├── Utils/                   # Utility functions
│   └── ARHelper.swift
└── project.yml              # XcodeGen configuration
```

## Design System Architecture

The app follows a centralized design system approach:

- **Tokens**: Fundamental design values (colors, spacing, typography, etc.)
- **Components**: Reusable UI elements built using tokens
- **Modifiers**: SwiftUI view modifiers for consistent styling

All design elements are accessed through the `DS` namespace:
- `DS.Color.primary`
- `DS.Typography.button`
- `DS.Space.m`
- etc.

## Features

- **AR Camera View**: Real-time camera feed with ARKit integration
- **Image Overlay**: Import and overlay images for tracing
- **Interactive Controls**: Adjust opacity, scale, and position of overlays
- **Design System**: Consistent UI components and styling

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Real device (ARKit doesn't work in Simulator)
- **Merriweather font family** (see [Font Installation Guide](Resources/Fonts/README.md))

## Building

1. **Install Fonts**: Follow the [Font Installation Guide](Resources/Fonts/README.md) to add Merriweather fonts
2. Open `ARSketchTracer.xcodeproj` in Xcode
3. Select a physical device
4. Build and run

## Development

The project uses XcodeGen for project generation. After making changes to `project.yml`:

```bash
./.tools/xcodegen/bin/xcodegen generate
```
