import SwiftUI
import PhotosUI

// MARK: - Control Types
enum ControlType: String, CaseIterable {
    case image = "Image"
    case lock = "Lock"
    case opacity = "Opacity"
    case filters = "Filters"
    
    var icon: String {
        switch self {
        case .image: return "photo"
        case .lock: return "lock" // Will be dynamic based on lock state
        case .opacity: return "circle.lefthalf.filled"
        case .filters: return "camera.filters"
        }
    }
}

// MARK: - Sliding Control Panel
struct SlidingControlPanel: View {
    @Binding var overlayImage: UIImage?
    @Binding var overlayOpacity: Double
    @Binding var isImageLocked: Bool
    
    @State private var selectedControl: ControlType? = nil
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    // Animation properties
    private let panelHeight: CGFloat = 180
    private let compactHeight: CGFloat = 80
    
    var body: some View {
        VStack(spacing: 0) {
            // Expanded content (only shown when a control is selected)
            if let selectedControl = selectedControl {
                expandedContent(for: selectedControl)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            }
            
            // Compact control bar (always visible)
            compactControlBar
        }
        .padding(.bottom, 24)
        .background(controlPanelBackground)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.large))
        .shadow(color: DS.Color.textPrimary.opacity(0.15), radius: 20, y: -5)
    }
    
    // MARK: - Compact Control Bar
    private var compactControlBar: some View {
        HStack(spacing: 0) {
            ForEach(ControlType.allCases, id: \.self) { controlType in
                controlButton(for: controlType)
            }
        }
        .frame(height: 80)
        .background(DS.Color.surface)
    }
    
    // MARK: - Control Button
    private func controlButton(for controlType: ControlType) -> some View {
        Group {
            if controlType == .image {
                // Image picker button
                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    VStack(spacing: DS.Space.xs) {
                        Image(systemName: overlayImage != nil ? "photo.fill" : "photo")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(DS.Color.textSecondary)
                        
                        Text(controlType.rawValue)
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: selectedPhotoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            overlayImage = image
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } else if controlType == .lock {
                // Lock/unlock button with special behavior
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isImageLocked.toggle()
                    }
                } label: {
                    VStack(spacing: DS.Space.xs) {
                        Image(systemName: isImageLocked ? "lock.fill" : "lock.open")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(
                                isImageLocked ? DS.Color.primary : DS.Color.textSecondary
                            )
                        
                        Text(isImageLocked ? "Unlock" : "Lock")
                            .font(DS.Typography.caption)
                            .foregroundStyle(
                                isImageLocked ? DS.Color.primary : DS.Color.textTertiary
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                // Regular control button
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        if selectedControl == controlType {
                            selectedControl = nil
                        } else {
                            selectedControl = controlType
                        }
                    }
                } label: {
                    VStack(spacing: DS.Space.xs) {
                        Image(systemName: controlType.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(
                                selectedControl == controlType ? DS.Color.primary : DS.Color.textSecondary
                            )
                        
                        Text(controlType.rawValue)
                            .font(DS.Typography.caption)
                            .foregroundStyle(
                                selectedControl == controlType ? DS.Color.primary : DS.Color.textTertiary
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Expanded Content
    @ViewBuilder
    private func expandedContent(for controlType: ControlType) -> some View {
        VStack(spacing: DS.Space.m) {
            // Header with control name and close button
            HStack {
                Text(controlType.rawValue)
                    .font(DS.Typography.headline)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedControl = nil
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(DS.Color.textSecondary)
                }
            }
            
            // Control-specific content
            switch controlType {
            case .image:
                imageControls
            case .lock:
                lockControls
            case .opacity:
                opacityControls
            case .filters:
                filtersControls
            }
        }
        .padding(DS.Space.l)
        .background(DS.Color.background)
    }
    
    // MARK: - Image Controls
    private var imageControls: some View {
        VStack(spacing: DS.Space.m) {
            if overlayImage != nil {
                // Show selected image info and clear option
                HStack {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "photo.fill")
                            .foregroundStyle(DS.Color.primary)
                        Text("Image selected")
                            .font(DS.Typography.body)
                            .foregroundStyle(DS.Color.textPrimary)
                    }
                    
                    Spacer()
                    
                    Button {
                        overlayImage = nil
                    } label: {
                        HStack(spacing: DS.Space.xs) {
                            Image(systemName: "trash")
                            Text("Remove")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, DS.Space.m)
                        .padding(.vertical, DS.Space.s)
                        .background(DS.Color.highlight, in: Capsule())
                    }
                }
            } else {
                // Prompt to select image
                VStack(spacing: DS.Space.s) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(DS.Color.textSecondary)
                    
                    Text("Tap the Image button below to select a photo for tracing")
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(DS.Space.l)
                .frame(maxWidth: .infinity)
                .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
            }
        }
    }
    
    // MARK: - Lock Controls
    private var lockControls: some View {
        VStack(spacing: DS.Space.m) {
            // Lock status indicator
            HStack(spacing: DS.Space.s) {
                Image(systemName: isImageLocked ? "lock.fill" : "lock.open")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isImageLocked ? DS.Color.primary : DS.Color.textSecondary)
                
                Text(isImageLocked ? "Image is locked in place" : "Image can be moved and resized")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Spacer()
            }
            .padding(DS.Space.m)
            .background(
                isImageLocked ? DS.Color.primary.opacity(0.1) : DS.Color.highlight,
                in: RoundedRectangle(cornerRadius: DS.Radius.medium)
            )
            
            // Lock toggle button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isImageLocked.toggle()
                }
            } label: {
                HStack(spacing: DS.Space.s) {
                    Image(systemName: isImageLocked ? "lock.open" : "lock.fill")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text(isImageLocked ? "Unlock Image" : "Lock Image")
                        .font(DS.Typography.body)
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Space.m)
                .background(
                    isImageLocked ? DS.Color.textSecondary : DS.Color.primary,
                    in: RoundedRectangle(cornerRadius: DS.Radius.medium)
                )
            }
            
            // Information text
            VStack(spacing: DS.Space.xs) {
                Text("Lock Status:")
                    .font(DS.Typography.caption)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if isImageLocked {
                    Text("• Size and rotation are locked\n• Image position is fixed\n• Tap 'Unlock Image' to allow changes")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("• Image can be moved freely\n• Size and rotation adjustable\n• Tap 'Lock Image' to prevent changes")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    // MARK: - Opacity Controls
    private var opacityControls: some View {
        VStack(spacing: DS.Space.m) {
            // Image status and clear button
            if overlayImage != nil {
                HStack {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "photo.fill")
                            .foregroundStyle(DS.Color.primary)
                        Text("Image loaded")
                            .font(DS.Typography.body)
                            .foregroundStyle(DS.Color.textPrimary)
                    }
                    
                    Spacer()
                    
                    Button {
                        overlayImage = nil
                    } label: {
                        HStack(spacing: DS.Space.xs) {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, DS.Space.m)
                        .padding(.vertical, DS.Space.s)
                        .background(DS.Color.highlight, in: Capsule())
                    }
                }
            } else {
                HStack {
                    Image(systemName: "photo")
                        .foregroundStyle(DS.Color.textSecondary)
                    Text("Use the Image button below to select a photo")
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                    Spacer()
                }
            }
            
            // Opacity slider
            VStack(spacing: DS.Space.s) {
                HStack {
                    Text("Opacity")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(overlayOpacity * 100))%")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textPrimary)
                        .monospacedDigit()
                }
                
                Slider(value: $overlayOpacity, in: 0...1)
                    .accentColor(DS.Color.primary)
                    .disabled(overlayImage == nil)
            }
        }
    }
    
    // MARK: - Filters Controls (Placeholder)
    private var filtersControls: some View {
        VStack(spacing: DS.Space.m) {
            Text("Filters coming soon...")
                .font(DS.Typography.body)
                .foregroundStyle(DS.Color.textSecondary)
            
            // Placeholder for filter controls
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: DS.Space.s) {
                ForEach(["None", "Sepia", "Mono", "Vivid", "Warm", "Cool"], id: \.self) { filter in
                    Button {
                        // TODO: Implement filter functionality
                    } label: {
                        Text(filter)
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textPrimary)
                            .padding(.horizontal, DS.Space.m)
                            .padding(.vertical, DS.Space.s)
                            .background(DS.Color.highlight, in: Capsule())
                    }
                }
            }
        }
    }
    
    // MARK: - Background
    private var controlPanelBackground: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay {
                Rectangle()
                    .fill(DS.Color.surface.opacity(0.9))
            }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        DS.Color.background
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            
            SlidingControlPanel(
                overlayImage: .constant(nil),
                overlayOpacity: .constant(0.5),
                isImageLocked: .constant(false)
            )
        }
        .padding(DS.Space.m)
    }
}