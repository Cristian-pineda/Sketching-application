import SwiftUI

struct DrawingCatalogView: View {
    @State private var searchText = ""
    @State private var selectedTags: Set<String> = []
    @State private var selectedDrawing: DrawingCatalogItem?
    @State private var showingPreview = false
    
    // Mock catalog data - will be replaced with backend data
    private let catalogItems: [DrawingCatalogItem] = [
        DrawingCatalogItem(title: "Simple Butterfly", imageName: "leaf", tags: ["animals", "nature", "easy"], description: "A beautiful butterfly perfect for beginners"),
        DrawingCatalogItem(title: "Mountain Landscape", imageName: "mountain.2", tags: ["nature", "landscape", "medium"], description: "Scenic mountain view with clouds"),
        DrawingCatalogItem(title: "Coffee Cup", imageName: "cup.and.saucer", tags: ["food", "objects", "easy"], description: "Classic coffee cup design"),
        DrawingCatalogItem(title: "Rose Flower", imageName: "leaf.fill", tags: ["nature", "flowers", "medium"], description: "Detailed rose with petals"),
        DrawingCatalogItem(title: "Cat Portrait", imageName: "cat", tags: ["animals", "pets", "hard"], description: "Cute cat face with details"),
        DrawingCatalogItem(title: "Apple", imageName: "apple.logo", tags: ["food", "fruit", "easy"], description: "Simple apple shape"),
        DrawingCatalogItem(title: "Tree", imageName: "tree", tags: ["nature", "plants", "medium"], description: "Oak tree with branches"),
        DrawingCatalogItem(title: "House", imageName: "house", tags: ["buildings", "architecture", "easy"], description: "Simple house structure")
    ]
    
    private var allTags: [String] {
        Array(Set(catalogItems.flatMap { $0.tags })).sorted()
    }
    
    private var filteredItems: [DrawingCatalogItem] {
        catalogItems.filter { item in
            let matchesSearch = searchText.isEmpty || item.title.localizedCaseInsensitiveContains(searchText)
            let matchesTags = selectedTags.isEmpty || !selectedTags.isDisjoint(with: Set(item.tags))
            return matchesSearch && matchesTags
        }
    }
    
    var body: some View {
        VStack(spacing: DS.Space.m) {
            // Header
            VStack(spacing: DS.Space.s) {
                HStack {
                    Image(systemName: "books.vertical")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(DS.Color.primary)
                    
                    Text("Drawing Catalog")
                        .font(DS.Typography.headline)
                        .foregroundStyle(DS.Color.textPrimary)
                    
                    Spacer()
                }
                
                Text("Browse our curated collection of drawings")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, DS.Space.m)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(DS.Color.textTertiary)
                
                TextField("Search drawings...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(DS.Color.textTertiary)
                    }
                }
            }
            .padding(DS.Space.m)
            .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
            .padding(.horizontal, DS.Space.m)
            
            // Tag filters
            if !allTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DS.Space.s) {
                        ForEach(allTags, id: \.self) { tag in
                            TagFilterButton(
                                tag: tag,
                                isSelected: selectedTags.contains(tag)
                            ) {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DS.Space.m)
                }
            }
            
            // Drawing grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DS.Space.m), count: 2), spacing: DS.Space.m) {
                    ForEach(filteredItems) { item in
                        DrawingCatalogCard(item: item) {
                            selectedDrawing = item
                            showingPreview = true
                        }
                    }
                }
                .padding(.horizontal, DS.Space.m)
            }
            
            if filteredItems.isEmpty {
                DSEmptyState(
                    icon: "magnifyingglass",
                    title: "No Drawings Found",
                    subtitle: searchText.isEmpty ? "Try adjusting your filters" : "Try a different search term"
                )
                .padding(DS.Space.l)
            }
        }
        .sheet(isPresented: $showingPreview) {
            if let drawing = selectedDrawing {
                DrawingPreviewSheet(drawing: drawing)
            }
        }
    }
}

// MARK: - Supporting Components
struct TagFilterButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag.capitalized)
                .font(DS.Typography.caption)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? DS.Color.background : DS.Color.textSecondary)
                .padding(.horizontal, DS.Space.m)
                .padding(.vertical, DS.Space.s)
                .background(
                    isSelected ? DS.Color.primary : DS.Color.highlight,
                    in: Capsule()
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DrawingCatalogCard: View {
    let item: DrawingCatalogItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DS.Space.s) {
                // Image placeholder
                Image(systemName: item.systemImage)
                    .font(.system(size: 48))
                    .foregroundStyle(DS.Color.primary)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(DS.Color.highlight, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
                
                // Title
                Text(item.title)
                    .font(DS.Typography.button)
                    .foregroundStyle(DS.Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Tags
                HStack {
                    ForEach(item.tags.prefix(2), id: \.self) { tag in
                        Text(tag)
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textTertiary)
                            .padding(.horizontal, DS.Space.s)
                            .padding(.vertical, 2)
                            .background(DS.Color.highlight, in: Capsule())
                    }
                    
                    if item.tags.count > 2 {
                        Text("+\(item.tags.count - 2)")
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textTertiary)
                    }
                }
            }
            .padding(DS.Space.m)
        }
        .buttonStyle(PlainButtonStyle())
        .dsCard()
    }
}

struct DrawingPreviewSheet: View {
    let drawing: DrawingCatalogItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: DS.Space.l) {
                // Large preview
                Image(systemName: drawing.systemImage)
                    .font(.system(size: 120))
                    .foregroundStyle(DS.Color.primary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(DS.Color.highlight, in: RoundedRectangle(cornerRadius: DS.Radius.large))
                
                // Details
                VStack(spacing: DS.Space.m) {
                    Text(drawing.title)
                        .font(DS.Typography.title)
                        .foregroundStyle(DS.Color.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    if let description = drawing.description {
                        Text(description)
                            .font(DS.Typography.body)
                            .foregroundStyle(DS.Color.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Tags
                    FlowLayout(spacing: DS.Space.s) {
                        ForEach(drawing.tags, id: \.self) { tag in
                            Text(tag.capitalized)
                                .font(DS.Typography.caption)
                                .foregroundStyle(DS.Color.textSecondary)
                                .padding(.horizontal, DS.Space.m)
                                .padding(.vertical, DS.Space.s)
                                .background(DS.Color.highlight, in: Capsule())
                        }
                    }
                }
                
                Spacer()
                
                // Action button
                NavigationLink(destination: CameraView()) {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "arkit")
                        Text("Use for Sketch")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(DS.Space.l)
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions(),
            subviews: subviews,
            spacing: spacing
        )
        return result.bounds
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions(),
            subviews: subviews,
            spacing: spacing
        )
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                     y: bounds.minY + result.frames[index].minY),
                         proposal: ProposedViewSize(result.frames[index].size))
        }
    }
}

struct FlowResult {
    var bounds = CGSize.zero
    var frames: [CGRect] = []
    
    init(in bounds: CGSize, subviews: LayoutSubviews, spacing: CGFloat) {
        var origin = CGPoint.zero
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if origin.x + size.width > bounds.width && origin.x > 0 {
                // Start new line
                origin.x = 0
                origin.y += lineHeight + spacing
                lineHeight = 0
            }
            
            frames.append(CGRect(origin: origin, size: size))
            lineHeight = max(lineHeight, size.height)
            origin.x += size.width + spacing
        }
        
        self.bounds = CGSize(width: bounds.width, height: origin.y + lineHeight)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DrawingCatalogView()
    }
}
