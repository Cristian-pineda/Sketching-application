import SwiftUI
import PhotosUI

struct LibraryUploadView: View {
    @State private var libraryItems: [LibraryItem] = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var showingRenameAlert = false
    @State private var itemToRename: LibraryItem?
    @State private var newItemName = ""
    @State private var showingDeleteAlert = false
    @State private var itemToDelete: LibraryItem?
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0.0
    
    // Grid layout
    private let columns = Array(repeating: GridItem(.flexible(), spacing: DS.Space.m), count: 2)
    
    var body: some View {
        VStack(spacing: DS.Space.m) {
            // Header
            VStack(spacing: DS.Space.s) {
                HStack {
                    Image(systemName: "folder")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(DS.Color.primary)
                    
                    Text("Personal Library")
                        .font(DS.Typography.headline)
                        .foregroundStyle(DS.Color.textPrimary)
                    
                    Spacer()
                    
                    Text("\(libraryItems.count)")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, DS.Space.s)
                        .padding(.vertical, 2)
                        .background(DS.Color.highlight, in: Capsule())
                }
                
                Text("Upload and manage your personal sketching images")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, DS.Space.m)
            
            // Upload section
            VStack(spacing: DS.Space.m) {
                PhotosPicker(
                    selection: $selectedPhotoItems,
                    maxSelectionCount: 5,
                    matching: .images
                ) {
                    HStack(spacing: DS.Space.m) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(DS.Color.primary)
                        
                        VStack(alignment: .leading, spacing: DS.Space.xs) {
                            Text("Upload Images")
                                .font(DS.Typography.button)
                                .foregroundStyle(DS.Color.textPrimary)
                            
                            Text("JPG, PNG • Max 5 at once")
                                .font(DS.Typography.caption)
                                .foregroundStyle(DS.Color.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(DS.Color.textTertiary)
                    }
                    .padding(DS.Space.m)
                    .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
                    .overlay {
                        RoundedRectangle(cornerRadius: DS.Radius.medium)
                            .stroke(DS.Color.border, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    }
                }
                .padding(.horizontal, DS.Space.m)
                .onChange(of: selectedPhotoItems) { newItems in
                    Task {
                        await processSelectedPhotos(newItems)
                    }
                }
                
                // Upload progress
                if isUploading {
                    VStack(spacing: DS.Space.s) {
                        HStack {
                            Text("Uploading...")
                                .font(DS.Typography.caption)
                                .foregroundStyle(DS.Color.textSecondary)
                            
                            Spacer()
                            
                            Text("\(Int(uploadProgress * 100))%")
                                .font(DS.Typography.caption)
                                .foregroundStyle(DS.Color.textPrimary)
                                .monospacedDigit()
                        }
                        
                        DSProgressBar(progress: uploadProgress)
                    }
                    .padding(.horizontal, DS.Space.m)
                }
            }
            
            // Library grid
            if libraryItems.isEmpty && !isUploading {
                Spacer()
                
                DSEmptyState(
                    icon: "photo.on.rectangle",
                    title: "No Images Yet",
                    subtitle: "Upload your first image to start building your personal sketch library",
                    actionTitle: "Upload Images",
                    action: {
                        // PhotosPicker will handle this
                    }
                )
                .padding(DS.Space.l)
                
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: DS.Space.m) {
                        ForEach(libraryItems) { item in
                            LibraryItemCard(
                                item: item,
                                onRename: {
                                    itemToRename = item
                                    newItemName = item.name
                                    showingRenameAlert = true
                                },
                                onDelete: {
                                    itemToDelete = item
                                    showingDeleteAlert = true
                                },
                                onUseForSketch: {
                                    // Navigate to camera with this image
                                }
                            )
                        }
                    }
                    .padding(.horizontal, DS.Space.m)
                    .padding(.bottom, DS.Space.l)
                }
            }
        }
        .alert("Rename Image", isPresented: $showingRenameAlert) {
            TextField("Image name", text: $newItemName)
            
            Button("Cancel", role: .cancel) {
                itemToRename = nil
                newItemName = ""
            }
            
            Button("Rename") {
                if let item = itemToRename,
                   let index = libraryItems.firstIndex(where: { $0.id == item.id }) {
                    libraryItems[index].name = newItemName.isEmpty ? "Untitled" : newItemName
                }
                itemToRename = nil
                newItemName = ""
            }
        } message: {
            Text("Enter a new name for this image")
        }
        .alert("Delete Image", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                itemToDelete = nil
            }
            
            Button("Delete", role: .destructive) {
                if let item = itemToDelete {
                    libraryItems.removeAll { $0.id == item.id }
                }
                itemToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this image? This action cannot be undone.")
        }
        .onAppear {
            loadSavedItems()
        }
        .onChange(of: libraryItems) { _ in
            saveItems()
        }
    }
    
    // MARK: - Private Methods
    private func processSelectedPhotos(_ items: [PhotosPickerItem]) async {
        guard !items.isEmpty else { return }
        
        isUploading = true
        uploadProgress = 0.0
        
        let totalItems = items.count
        
        for (index, item) in items.enumerated() {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let _ = UIImage(data: data) {
                    
                    let libraryItem = LibraryItem(
                        name: "Image \(libraryItems.count + 1)",
                        imageData: data,
                        dateCreated: Date(),
                        type: .upload
                    )
                    
                    await MainActor.run {
                        libraryItems.append(libraryItem)
                        uploadProgress = Double(index + 1) / Double(totalItems)
                    }
                    
                    // Simulate upload delay
                    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
        
        // Clear selected items
        selectedPhotoItems = []
        
        // Small delay before hiding progress
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
            isUploading = false
            uploadProgress = 0.0
        }
    }
    
    private func loadSavedItems() {
        // Load from UserDefaults for now
        if let data = UserDefaults.standard.data(forKey: "LibraryItems"),
           let items = try? JSONDecoder().decode([LibraryItem].self, from: data) {
            libraryItems = items
        }
    }
    
    private func saveItems() {
        // Save to UserDefaults for now
        if let data = try? JSONEncoder().encode(libraryItems) {
            UserDefaults.standard.set(data, forKey: "LibraryItems")
        }
    }
}

// MARK: - Library Item Card
struct LibraryItemCard: View {
    let item: LibraryItem
    let onRename: () -> Void
    let onDelete: () -> Void
    let onUseForSketch: () -> Void
    
    @State private var showingMenu = false
    
    var body: some View {
        VStack(spacing: DS.Space.s) {
            // Image
            Group {
                if let uiImage = item.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 32))
                        .foregroundStyle(DS.Color.textTertiary)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(DS.Color.highlight)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.medium))
            
            // Info
            VStack(spacing: DS.Space.xs) {
                HStack {
                    Text(item.name)
                        .font(DS.Typography.button)
                        .foregroundStyle(DS.Color.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button {
                        showingMenu = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(DS.Color.textSecondary)
                    }
                }
                
                HStack {
                    HStack(spacing: DS.Space.xs) {
                        Image(systemName: item.type.icon)
                            .font(.system(size: 10))
                        Text(item.type.displayName)
                            .font(DS.Typography.caption)
                    }
                    .foregroundStyle(DS.Color.textTertiary)
                    
                    Spacer()
                    
                    Text(item.dateCreated, style: .date)
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textTertiary)
                }
            }
        }
        .padding(DS.Space.s)
        .dsCompactCard()
        .confirmationDialog("Image Options", isPresented: $showingMenu, titleVisibility: .visible) {
            NavigationLink(destination: CameraView(overlayImage: item.uiImage)) {
                Label("Use for Sketch", systemImage: "arkit")
            }
            
            Button("Rename") {
                onRename()
            }
            
            Button("Delete", role: .destructive) {
                onDelete()
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
}

// MARK: - Compact Card Modifier
extension View {
    func dsCompactCard() -> some View {
        modifier(DSCompactCardBackground())
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LibraryUploadView()
    }
}
