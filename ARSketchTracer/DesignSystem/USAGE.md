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
            Text("Title")
                .font(DS.Typography.title)
                .foregroundStyle(DS.Color.textPrimary)
            
            Text("Subtitle")
                .font(DS.Typography.body)
                .foregroundStyle(DS.Color.textSecondary)
            
            Button("Primary Action") { }
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding(DS.Space.l)
        .background(DS.Color.surface)
    }
}
```
