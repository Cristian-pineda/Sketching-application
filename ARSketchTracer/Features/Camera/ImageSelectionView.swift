import SwiftUI
import PhotosUI

struct ImageSelectionView: View {
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isNavigatingToCamera = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: DS.Space.xl) {
                // Header section
                VStack(spacing: DS.Space.m) {
                    Text("Select Image to Trace")
                        .font(DS.Typography.title)
                        .foregroundStyle(DS.Color.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Choose an image from your photo library to overlay and trace in AR")
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, DS.Space.xl)
                
                // Image preview section
                if let selectedImage = selectedImage {
                    VStack(spacing: DS.Space.m) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.large))
                            .shadow(color: DS.Color.textPrimary.opacity(0.1), radius: 10, y: 5)
                        
                        Text("Selected Image")
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textSecondary)
                    }
                    .dsCard()
                } else {
                    // Placeholder state
                    VStack(spacing: DS.Space.m) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 64))
                            .foregroundStyle(DS.Color.textTertiary)
                        
                        Text("No image selected")
                            .font(DS.Typography.body)
                            .foregroundStyle(DS.Color.textSecondary)
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .dsCard()
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: DS.Space.m) {
                    // Photo picker button
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                        HStack(spacing: DS.Space.s) {
                            Image(systemName: selectedImage != nil ? "photo.fill" : "photo")
                                .font(.system(size: 18, weight: .medium))
                            Text(selectedImage != nil ? "Change Image" : "Choose Image")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .onChange(of: selectedPhotoItem) { newItem in
                        Task {
                            if let newItem = newItem,
                               let data = try? await newItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                            }
                        }
                    }
                    
                    // Continue to AR button
                    if selectedImage != nil {
                        NavigationLink(destination: CameraView(overlayImage: selectedImage)) {
                            HStack(spacing: DS.Space.s) {
                                Image(systemName: "arkit")
                                    .font(.system(size: 18, weight: .medium))
                                Text("Start AR Tracing")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                    }
                }
            }
            .padding(DS.Space.l)
            .background(DS.Color.background.ignoresSafeArea())
            .animation(.easeInOut(duration: 0.3), value: selectedImage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(DS.Color.textSecondary)
                }
            }
        }
    }
}

struct ImageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectionView()
    }
}
