import SwiftUI

// MARK: - Toast Types
enum DSToastType {
    case success
    case warning
    case error
    case info
    
    var icon: String {
        switch self {
        case .success: return DS.Icon.success
        case .warning: return DS.Icon.warning
        case .error: return DS.Icon.error
        case .info: return DS.Icon.info
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .info: return DS.Color.primary
        }
    }
}

// MARK: - Toast View
struct DSToast: View {
    let type: DSToastType
    let title: String
    let message: String?
    let onDismiss: (() -> Void)?
    
    @State private var isVisible = false
    
    init(
        type: DSToastType,
        title: String,
        message: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        HStack(spacing: DS.Space.m) {
            DS.Icon.systemImage(type.icon, size: 20)
                .foregroundStyle(type.color)
            
            VStack(alignment: .leading, spacing: DS.Space.xs) {
                Text(title)
                    .font(DS.Typography.button)
                    .foregroundStyle(DS.Color.textPrimary)
                
                if let message {
                    Text(message)
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                }
            }
            
            Spacer()
            
            if let onDismiss {
                Button(action: onDismiss) {
                    DS.Icon.systemImage(DS.Icon.xmark, size: 16)
                        .foregroundStyle(DS.Color.textTertiary)
                }
            }
        }
        .padding(DS.Space.m)
        .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: DS.Radius.medium)
                .stroke(DS.Color.border, lineWidth: 1)
        }
        .shadow(color: DS.Elevation.cardShadow(.light), radius: 8, y: 4)
        .scaleEffect(isVisible ? 1 : 0.9)
        .opacity(isVisible ? 1 : 0)
        .animation(DS.Animation.spring, value: isVisible)
        .onAppear {
            isVisible = true
            
            // Auto-dismiss after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                onDismiss?()
            }
        }
    }
}

// MARK: - Alert Components
struct DSAlert: View {
    let title: String
    let message: String
    let primaryAction: (title: String, action: () -> Void)
    let secondaryAction: (title: String, action: () -> Void)?
    
    init(
        title: String,
        message: String,
        primaryAction: (title: String, action: () -> Void),
        secondaryAction: (title: String, action: () -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var body: some View {
        VStack(spacing: DS.Space.l) {
            VStack(spacing: DS.Space.s) {
                Text(title)
                    .font(DS.Typography.headline)
                    .foregroundStyle(DS.Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: DS.Space.s) {
                Button(primaryAction.title, action: primaryAction.action)
                    .buttonStyle(PrimaryButtonStyle())
                
                if let secondaryAction {
                    Button(secondaryAction.title, action: secondaryAction.action)
                        .buttonStyle(SecondaryButtonStyle())
                }
            }
        }
        .padding(DS.Space.xl)
        .frame(maxWidth: 320)
        .dsCard()
    }
}

// MARK: - Toast Modifier
extension View {
    func dsToast(
        isPresented: Binding<Bool>,
        type: DSToastType,
        title: String,
        message: String? = nil
    ) -> some View {
        self.overlay(alignment: .top) {
            if isPresented.wrappedValue {
                DSToast(
                    type: type,
                    title: title,
                    message: message,
                    onDismiss: {
                        isPresented.wrappedValue = false
                    }
                )
                .padding(.horizontal, DS.Space.l)
                .padding(.top, DS.Space.l)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(DS.Animation.spring, value: isPresented.wrappedValue)
    }
}
