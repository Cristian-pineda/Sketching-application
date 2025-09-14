import SwiftUI

// MARK: - Loading Spinner
struct DSLoadingSpinner: View {
    let size: CGFloat
    let color: Color
    
    @State private var isAnimating = false
    
    init(size: CGFloat = 24, color: Color = DS.Color.primary) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, lineWidth: size / 8)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Progress Bar
struct DSProgressBar: View {
    let progress: Double // 0.0 to 1.0
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        progress: Double,
        height: CGFloat = 4,
        backgroundColor: Color = DS.Color.highlight,
        foregroundColor: Color = DS.Color.primary
    ) {
        self.progress = max(0, min(1, progress))
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(height: height)
                
                Rectangle()
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * progress, height: height)
                    .animation(DS.Animation.easeOut, value: progress)
            }
        }
        .frame(height: height)
        .clipShape(Capsule())
    }
}

// MARK: - Loading States
struct DSLoadingView: View {
    let title: String
    let subtitle: String?
    
    init(title: String = "Loading...", subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: DS.Space.l) {
            DSLoadingSpinner(size: 32)
            
            VStack(spacing: DS.Space.s) {
                Text(title)
                    .font(DS.Typography.headline)
                    .foregroundStyle(DS.Color.textPrimary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(DS.Space.xl)
        .dsCard()
    }
}

// MARK: - Empty State
struct DSEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: DS.Space.l) {
            DS.Icon.systemImage(icon, size: 48)
                .foregroundStyle(DS.Color.textTertiary)
            
            VStack(spacing: DS.Space.s) {
                Text(title)
                    .font(DS.Typography.headline)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Text(subtitle)
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(DS.Space.xl)
        .frame(maxWidth: 280)
    }
}
