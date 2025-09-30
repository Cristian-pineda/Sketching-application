//  MainNavigationBar.swift
//  ARSketchTracer Design System
//
//  Created by Cristian Pineda on 9/26/25.
//
//  A reusable navigation bar component inspired by Figma 'Toolbar - Top'.

import SwiftUI

public struct MainNavigationBar: View {
    public enum Style {
        case expanded(title: String, subtitle: String?, leading: AnyView?, trailing: AnyView?)
        case collapsed(title: String, leading: AnyView?, trailing: AnyView?)
    }
    
    let style: Style
    let isCollapsed: Bool // <-- pass in from parent, not @State
    
    public init(style: Style, isCollapsed: Bool) {
        self.style = style
        self.isCollapsed = isCollapsed
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Top bar: left, center, right controls
            HStack(alignment: .center, spacing: 0) {
                switch style {
                case .expanded(let title, _, let leading, let trailing):
                    if let leading = leading { leading }
                    else { Spacer().frame(width: 44) }
                    Spacer(minLength: 0)
                    if isCollapsed {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DS.Color.textPrimary)
                            .frame(maxWidth: 220)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .transition(.opacity)
                    } else {
                        Spacer().frame(width: 44)
                    }
                    Spacer(minLength: 0)
                    if let trailing = trailing { trailing }
                    else { Spacer().frame(width: 44) }
                case .collapsed(let title, let leading, let trailing):
                    if let leading = leading { leading }
                    else { Spacer().frame(width: 44) }
                    Spacer(minLength: 0)
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DS.Color.textPrimary)
                        .frame(maxWidth: 220)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .transition(.opacity)
                    Spacer(minLength: 0)
                    if let trailing = trailing { trailing }
                    else { Spacer().frame(width: 44) }
                }
            }
            .frame(height: 56)
            .padding(.horizontal, DS.Space.l)
            .background(DS.Color.surface)
            .frame(maxWidth: .infinity)
            // Bottom section: title and subtitle (expands/collapses)
            if !isCollapsed, case let .expanded(title, subtitle, _, _) = style {
                VStack(alignment: .leading, spacing: DS.Space.xs) {
                    Text(title)
                        .font(DS.Typography.title)
                        .foregroundColor(DS.Color.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DS.Typography.subtitle)
                            .foregroundColor(DS.Color.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                .padding(.horizontal, DS.Space.l)
                .padding(.vertical, DS.Space.m)
                .background(DS.Color.surface)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(DS.Color.surface)
        .animation(.easeInOut, value: isCollapsed)
        .shadow(color: DS.Color.divider.opacity(0.15), radius: 2, y: 1)
    }
}

// MARK: - Helper: BackButton
public struct NavBarBackButton: View {
    let label: String?
    let action: () -> Void
    public init(label: String? = nil, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    public var body: some View {
        Button(action: action) {
            HStack(spacing: DS.Space.s) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(DS.Color.textPrimary)
                if let label = label {
                    Text(label)
                        .font(DS.Typography.subtitle)
                        .foregroundColor(DS.Color.textPrimary)
                }
            }
            .padding(.vertical, DS.Space.s)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        // Collapsed: Back button with label, up to 3 trailing actions, title centered (scroll variant)
        MainNavigationBar(
            style: .collapsed(
                title: "Discover",
                leading: AnyView(NavBarBackButton(label: "Back") { }),
                trailing: AnyView(HStack(spacing: DS.Space.l) {
                    Button(action: {}) { Image(systemName: "gearshape").foregroundColor(DS.Color.textPrimary) }
                    Button(action: {}) { Image(systemName: "bell").foregroundColor(DS.Color.textPrimary) }
                    Button(action: {}) { Image(systemName: "ellipsis").foregroundColor(DS.Color.textPrimary) }
                })
            ),
            isCollapsed: true
        )
        // Collapsed: Centered title only (scroll variant, no left/right controls)
        MainNavigationBar(
            style: .collapsed(
                title: "Discover",
                leading: nil,
                trailing: nil
            ),
            isCollapsed: true
        )
        // Expanded: Back button with label, up to 3 trailing actions
        MainNavigationBar(
            style: .expanded(
                title: "Discover",
                subtitle: "Your next drawing idea",
                leading: AnyView(NavBarBackButton(label: "Back") { }),
                trailing: AnyView(HStack(spacing: DS.Space.l) {
                    Button(action: {}) { Image(systemName: "gearshape").foregroundColor(DS.Color.textPrimary) }
                    Button(action: {}) { Image(systemName: "bell").foregroundColor(DS.Color.textPrimary) }
                    Button(action: {}) { Image(systemName: "ellipsis").foregroundColor(DS.Color.textPrimary) }
                })
            ),
            isCollapsed: false
        )
        // Expanded: Only icon on left, label on right
        MainNavigationBar(
            style: .expanded(
                title: "Gallery",
                subtitle: "Browse your sketches",
                leading: AnyView(Button(action: {}) {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(DS.Color.textPrimary)
                }),
                trailing: AnyView(Text("Edit")
                    .font(DS.Typography.subtitle)
                    .foregroundColor(DS.Color.textPrimary))
            ),
            isCollapsed: false
        )
    }
    .padding()
    .background(DS.Color.surface)
}
