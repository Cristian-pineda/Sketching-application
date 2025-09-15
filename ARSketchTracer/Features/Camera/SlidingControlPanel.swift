import SwiftUI
import PhotosUI

// MARK: - Control Types
enum ControlType: String, CaseIterable {
    case move = "Move"
    case opacity = "Opacity"
    case filters = "Filters"
    
    var icon: String {
        switch self {
        case .move: return "move.3d"
        case .opacity: return "circle.lefthalf.filled"
        case .filters: return "camera.filters"
        }
    }
}

// MARK: - Sliding Control Panel
struct SlidingControlPanel: View {
    @Binding var overlayImage: UIImage?
    @Binding var overlayOpacity: Double
    
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
        .background(controlPanelBackground)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.large))
        .shadow(color: DS.Color.textPrimary.opacity(0.15), radius: 20, y: -5)
    }
    
    // MARK: - Compact Control Bar
    private var compactControlBar: some View {
        HStack(spacing: DS.Space.l) {
            ForEach(ControlType.allCases, id: \.self) { controlType in
                controlButton(for: controlType)
            }
        }
        .padding(.horizontal, DS.Space.l)
        .padding(.vertical, DS.Space.m)
        .background(DS.Color.surface)
    }
    
    // MARK: - Control Button
    private func controlButton(for controlType: ControlType) -> some View {
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
    
    // MARK: - Expanded Content
    @ViewBuilder
    private func expandedContent(for controlType: ControlType) -> some View {
        VStack(spacing: DS.Space.m) {
            // Header with control name and close button
            HStack {
                Text(controlType.rawValue)
                    .font(DS.Typography.headlineSmall)
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
            case .opacity:
                opacityControls
            case .move:
                moveControls
            case .filters:
                filtersControls
            }
        }
        .padding(DS.Space.l)
        .background(DS.Color.background)
    }
    
    // MARK: - Opacity Controls
    private var opacityControls: some View {
        VStack(spacing: DS.Space.m) {
            // Image picker section
            HStack(spacing: DS.Space.s) {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "photo")
                            .font(.system(size: 16, weight: .medium))
                        Text("Choose Image")
                            .font(DS.Typography.body)
                    }
                    .foregroundStyle(DS.Color.background)
                    .padding(.horizontal, DS.Space.m)
                    .padding(.vertical, DS.Space.s)
                    .background(DS.Color.primary)
                    .clipShape(Capsule())
                }
                .onChange(of: selectedPhotoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            overlayImage = image
                        }
                    }
                }
                
                if overlayImage != nil {
                    Button {
                        overlayImage = nil
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(DS.Color.textSecondary)
                            .padding(DS.Space.s)
                            .background(DS.Color.highlight, in: Circle())
                    }
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
            }
        }
    }
    
    // MARK: - Move Controls (Placeholder)
    private var moveControls: some View {
        VStack(spacing: DS.Space.m) {
            Text("Move controls coming soon...")
                .font(DS.Typography.body)
                .foregroundStyle(DS.Color.textSecondary)
            
            // Placeholder for move controls
            HStack(spacing: DS.Space.m) {
                ForEach(["arrow.up", "arrow.down", "arrow.left", "arrow.right"], id: \.self) { icon in
                    Button {
                        // TODO: Implement move functionality
                    } label: {
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(DS.Color.textSecondary)
                            .padding(DS.Space.m)
                            .background(DS.Color.highlight, in: Circle())
                    }
                }
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
                overlayOpacity: .constant(0.5)
            )
        }
        .padding(DS.Space.m)
    }
}
