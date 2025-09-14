import SwiftUI
import PhotosUI

struct CameraControls: View {
    @Binding var showControls: Bool
    @Binding var overlayImage: UIImage?
    @Binding var overlayOpacity: Double

    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 12) {
            HStack {
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

            HStack {
                Label("Opacity", systemImage: "circle.lefthalf.filled")
                    .foregroundStyle(DS.Color.textSecondary)
                    .font(DS.Typography.subtitle)
                Slider(value: $overlayOpacity, in: 0...1)
                    .frame(maxWidth: 200)
                Text(String(format: "%.0f%%", overlayOpacity * 100))
                    .monospacedDigit()
                    .foregroundStyle(DS.Color.textPrimary)
                    .font(DS.Typography.caption)
            }

            Button {
                showControls.toggle()
            } label: {
                Label(showControls ? "Hide Controls" : "Show Controls", systemImage: showControls ? "chevron.up" : "chevron.down")
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(DS.Space.m)
        .background(DS.Color.surface, in: .rect(cornerRadius: DS.Radius.medium))
        .overlay {
            RoundedRectangle(cornerRadius: DS.Radius.medium)
                .stroke(DS.Color.border, lineWidth: 1)
        }
    }
}
