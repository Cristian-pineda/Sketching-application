import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Drawing Catalog Tab
            NavigationStack {
                DrawingCatalogSection()
            }
            .tabItem {
                Image(systemName: "rectangle.grid.2x2")
                Text("Catalog")
            }
            .tag(0)
            
            // Personal Library Tab
            NavigationStack {
                PersonalLibrarySection()
            }
            .tabItem {
                Image(systemName: "photo.on.rectangle")
                Text("Library")
            }
            .tag(1)
            
            // AI Generator Tab
            NavigationStack {
                AIGeneratorSection()
            }
            .tabItem {
                Image(systemName: "wand.and.stars")
                Text("Generate")
            }
            .tag(2)
            
            // Quick Start Tab
            NavigationStack {
                QuickStartView()
            }
            .tabItem {
                Image(systemName: "viewfinder")
                Text("Quick Start")
            }
            .tag(3)
        }
        .tint(Color.primary)
    }
}

// Quick Start View for direct AR tracing
struct QuickStartView: View {
    var body: some View {
        VStack(spacing: DS.Space.xl) {
            // Header section
            VStack(spacing: DS.Space.m) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 60))
                    .foregroundStyle(DS.Color.primary)
                
                Text("Quick Start")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Jump straight into AR tracing by selecting an image from your device")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Space.l)
            }
            .padding(.top, DS.Space.xxl)

            Spacer()

            // Action button
            VStack(spacing: DS.Space.m) {
                NavigationLink(destination: ImageSelectionView()) {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                        Text("Start AR Tracing")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Text("Select an image from your photos to begin")
                    .font(DS.Typography.caption)
                    .foregroundStyle(DS.Color.textSecondary)
            }

            Spacer()
        }
        .padding(DS.Space.l)
        .background(DS.Color.background.ignoresSafeArea())
        .navigationTitle("Quick Start")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Dashboard Sections (Placeholder Implementation)

struct DrawingCatalogSection: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: DS.Space.l) {
            // Header
            VStack(spacing: DS.Space.m) {
                Image(systemName: "rectangle.grid.2x2")
                    .font(.system(size: 60))
                    .foregroundStyle(DS.Color.primary)
                
                Text("Drawing Catalog")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Text("Browse and select from our collection of tracing templates")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, DS.Space.l)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(DS.Color.textSecondary)
                TextField("Search drawings...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, DS.Space.m)
            
            // Mock catalog grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DS.Space.m) {
                ForEach(mockCatalogItems, id: \.self) { item in
                    CatalogItemCard(title: item.title, imageName: item.imageName)
                }
            }
            .padding(.horizontal, DS.Space.m)
            
            Spacer()
        }
        .background(DS.Color.background.ignoresSafeArea())
        .navigationTitle("Catalog")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var mockCatalogItems: [CatalogItem] {
        [
            CatalogItem(title: "Butterfly", imageName: "leaf"),
            CatalogItem(title: "Landscape", imageName: "mountain.2"),
            CatalogItem(title: "Coffee Cup", imageName: "cup.and.saucer"),
            CatalogItem(title: "Flower", imageName: "leaf.fill"),
            CatalogItem(title: "Car", imageName: "car"),
            CatalogItem(title: "House", imageName: "house")
        ]
    }
}

// Helper struct for catalog items
struct CatalogItem: Hashable {
    let title: String
    let imageName: String
}

struct PersonalLibrarySection: View {
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack(spacing: DS.Space.l) {
            // Header
            VStack(spacing: DS.Space.m) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 60))
                    .foregroundStyle(DS.Color.primary)
                
                Text("Personal Library")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Text("Upload and manage your own images for tracing")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, DS.Space.l)
            
            // Upload button
            Button(action: { showingImagePicker = true }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Upload Images")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, DS.Space.m)
            
            // Placeholder for uploaded images
            Text("No images uploaded yet")
                .font(DS.Typography.body)
                .foregroundStyle(DS.Color.textSecondary)
                .padding(.top, DS.Space.xl)
            
            Spacer()
        }
        .background(DS.Color.background.ignoresSafeArea())
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImagePicker) {
            ImageSelectionView()
        }
    }
}

struct AIGeneratorSection: View {
    @State private var promptText = ""
    @State private var selectedStyle = "Realistic"
    
    private let styles = ["Realistic", "Cartoon", "Sketch", "Minimalist"]
    
    var body: some View {
        VStack(spacing: DS.Space.l) {
            // Header
            VStack(spacing: DS.Space.m) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 60))
                    .foregroundStyle(DS.Color.primary)
                
                Text("AI Generator")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Text("Generate custom illustrations using AI")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, DS.Space.l)
            
            // Prompt input
            VStack(alignment: .leading, spacing: DS.Space.s) {
                Text("Describe what you want to draw:")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textPrimary)
                
                TextField("Enter your prompt...", text: $promptText, axis: .vertical)
                    .lineLimit(3...6)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, DS.Space.m)
            
            // Style selection
            VStack(alignment: .leading, spacing: DS.Space.s) {
                Text("Style:")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textPrimary)
                
                HStack {
                    ForEach(styles, id: \.self) { style in
                        Button(style) {
                            selectedStyle = style
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .opacity(selectedStyle == style ? 1.0 : 0.6)
                    }
                }
            }
            .padding(.horizontal, DS.Space.m)
            
            // Generate button
            Button("Generate Illustration") {
                // Mock generation
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, DS.Space.m)
            .disabled(promptText.isEmpty)
            
            Spacer()
        }
        .background(DS.Color.background.ignoresSafeArea())
        .navigationTitle("Generate")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CatalogItemCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 40))
                .foregroundStyle(DS.Color.primary)
                .frame(height: 60)
            
            Text(title)
                .font(DS.Typography.caption)
                .foregroundStyle(DS.Color.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(DS.Space.m)
        .background(DS.Color.surface)
        .cornerRadius(DS.Radius.medium)
        .onTapGesture {
            // Navigate to AR camera with selected image
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
