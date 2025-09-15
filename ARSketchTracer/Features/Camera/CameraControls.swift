import SwiftUI
import PhotosUI

struct CameraControls: View {
    @Binding var showControls: Bool
    @Binding var overlayImage: UIImage?
    @Binding var overlayOpacity: Double

    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: DS.Space.m) {
            HStack(spacing: DS.Space.s) {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Label("Choose Image", systemImage: "photo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            overlayImage = image
                        }
                    }
                }

                Button {
                    overlayImage = nil
                } label: {
                    Label("Clear", systemImage: "xmark.circle")
                }
                .buttonStyle(SecondaryButtonStyle())
            }

            VStack(spacing: DS.Space.s) {
                HStack {
                    Label("Opacity", systemImage: "circle.lefthalf.filled")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                    
                    Spacer()
                    
                    Text(String(format: "%.0f%%", overlayOpacity * 100))
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textPrimary)
                        .monospacedDigit()
                }
                
                Slider(value: $overlayOpacity, in: 0...1)
                    .accentColor(DS.Color.primary)
            }

            Button {
                showControls.toggle()
            } label: {
                Label(
                    showControls ? "Hide Controls" : "Show Controls", 
                    systemImage: showControls ? "chevron.up" : "chevron.down"
                )
            }
            .buttonStyle(TertiaryButtonStyle())
        }
        .padding(DS.Space.m)
        .background(DS.Color.surface.opacity(0.95), in: .rect(cornerRadius: DS.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: DS.Radius.medium)
                .stroke(DS.Color.border.opacity(0.3), lineWidth: 1)
        }
        .shadow(color: DS.Color.textPrimary.opacity(0.1), radius: 8, y: 4)
    }
}
