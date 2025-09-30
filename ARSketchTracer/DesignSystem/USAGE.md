# Design System Usage Examples

This document shows how to properly use the AR Sketch Tracer design system components.

## Colors

```swift
// Background colors
DS.Color.background    // #FFFFFF - Main background
DS.Color.surface       // #F7F7F8 - Card/surface background

// Text colors
DS.Color.textPrimary   // #000000 - Primary text
DS.Color.textSecondary // #6E6E73 - Secondary text
DS.Color.textTertiary  // #A1A1AA - Tertiary text

// Interactive states
DS.Color.primary       // Brand primary (from Assets)
DS.Color.accent        // #3E3E3E - Hover/active states
DS.Color.highlight     // #EBEBEB - Light highlights
DS.Color.selection     // #D1D1D1 - Selected states

// Structural elements
DS.Color.border        // #E3E3E3 - Borders
DS.Color.divider       // #E5E5E5 - Dividers
```

## Typography

The app uses **Merriweather** by Sorkin Type as the primary typeface.

```swift
DS.Typography.title    // 34pt Merriweather Bold - Large display text
DS.Typography.headline // 20pt Merriweather Bold - Section headers  
DS.Typography.subtitle // 16pt Merriweather Regular - Subtitle text
DS.Typography.body     // 14pt Merriweather Regular - Body text
DS.Typography.button   // 16pt Merriweather Medium - Button text
DS.Typography.caption  // 12pt Merriweather Regular - Small text
DS.Typography.footnote // 10pt Merriweather Regular - Very small text
```

**Note**: If Merriweather fonts are not installed, the system will fall back to serif system fonts.

## Spacing

```swift
DS.Space.xs   // 4pt
DS.Space.s    // 8pt
DS.Space.m    // 12pt
DS.Space.l    // 16pt
DS.Space.xl   // 24pt
DS.Space.xxl  // 32pt
```

## Button Styles

```swift
// Primary action button
Button("Action") { }
.buttonStyle(PrimaryButtonStyle())

// Secondary button
Button("Cancel") { }
.buttonStyle(SecondaryButtonStyle())

// Tertiary button
Button("Option") { }
.buttonStyle(TertiaryButtonStyle())

// Destructive action
Button("Delete") { }
.buttonStyle(DestructiveButtonStyle())
```

## Card Backgrounds

```swift
// Full card with padding and border
VStack {
    Text("Content")
}
.dsCard()

// Compact card
VStack {
    Text("Content")
}
.dsCompactCard()
```

## Example Usage

```swift
struct ExampleView: View {
    var body: some View {
        VStack(spacing: DS.Space.l) {
            Text("AR Sketch Tracer")
                .font(DS.Typography.title)
                .foregroundStyle(DS.Color.textPrimary)
            
            Text("Trace sketches using AR overlay")
                .font(DS.Typography.body)
                .foregroundStyle(DS.Color.textSecondary)
            
            Button("Start Tracing") { }
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding(DS.Space.l)
        .dsCard()
    }
}
```

---

## Component Usage

All design system components (e.g., `Chip`, `StyleChip`, `ItemCardSlider`) are located in:
```
ARSketchTracer/DesignSystem/Components/
```
They are **SwiftUI views** and are available to any file in the same Xcode target.  
**No import statement** like `import DesignSystem` is needed—just use the component directly.

### 1. Chip
```swift
Chip(title: "All", isSelected: true) {
    // action
}
```

### 2. StyleChip
```swift
StyleChip(style: someStyle, isSelected: false) {
    // action
}
```

### 3. ItemCardSlider
```swift
ItemCardSlider(items: itemsArray) { item in
    // action on item tap
}
```

---

### Notes
- **No module import required** for design system components.
- If you get a "No such module" error, remove any `import DesignSystem` or similar lines.
- Components are available as long as they are in the same target and not excluded from build phases.

### Troubleshooting
- If a component is not found, ensure the file is present in `DesignSystem/Components/` and included in the Xcode target.
- If you move or rename a component, update all references accordingly.

---

## MainNavigationBar + Scroll Tracking

`MainNavigationBar` lives in `ARSketchTracer/DesignSystem/Components/MainNavigationBar.swift`. It renders two layouts depending on the `isCollapsed` flag that the caller provides. The design system intentionally keeps the component stateless so feature screens can decide when to collapse.

### Example: Dashboard Integration

`ARSketchTracer/Features/Search/Views/DashboardView.swift` shows the recommended pattern:

```swift
struct DashboardView: View {
    @State private var isNavCollapsed = false

    var body: some View {
        VStack(spacing: 0) {
            MainNavigationBar(
                style: .expanded(
                    title: "Discover",
                    subtitle: "Your next drawing idea",
                    leading: nil,
                    trailing: nil
                ),
                isCollapsed: isNavCollapsed
            )

            TrackableScrollView(onOffsetChange: handleScroll) {
                // dashboard content …
            }
        }
    }

    private func handleScroll(offset: CGFloat) {
        // Collapse as soon as the user scrolls down.
        isNavCollapsed = max(0, offset) > 0
    }
}
```

### TrackableScrollView Helper

SwiftUI's `ScrollView` does not expose scroll offsets directly, so the dashboard wraps its content in `TrackableScrollView` (declared at the bottom of the same file). It bridges to `UIScrollView` via `UIViewRepresentable` and forwards `scrollView.contentOffset.y` to the supplied closure.

To reuse the pattern on other screens:
1. Copy `TrackableScrollView` (lines 187–233 in `DashboardView.swift`) into a shared utilities file, or move it to a common module.
2. Keep the navigation bar stateless—drive `isCollapsed` from your feature view’s scroll offset.
3. Adjust the collapse threshold locally if a view needs more scroll before collapsing.

This separation lets each feature decide when to collapse while preserving a single design-system component.
