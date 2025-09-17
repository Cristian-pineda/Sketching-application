import SwiftUI

struct IllustrationGeneratorView: View {
    @State private var promptText = ""
    @State private var selectedStyle: GenerationPrompt.GenerationStyle = .realistic
    @State private var isGenerating = false
    @State private var generationProgress: Double = 0.0
    @State private var generatedIllustrations: [GeneratedIllustration] = []
    @State private var currentGeneration: GeneratedIllustration?
    @State private var showingResult = false
    @State private var showingLibraryOptions = false
    
    private let maxPromptLength = 200
    
    var body: some View {
        VStack(spacing: DS.Space.m) {
            // Header
            VStack(spacing: DS.Space.s) {
                HStack {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(DS.Color.primary)
                    
                    Text("AI Illustration Generator")
                        .font(DS.Typography.headline)
                        .foregroundStyle(DS.Color.textPrimary)
                    
                    Spacer()
                }
                
                Text("Generate custom illustrations from text descriptions")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, DS.Space.m)
            
            // Generation form
            VStack(spacing: DS.Space.l) {
                // Prompt input
                VStack(spacing: DS.Space.s) {
                    HStack {
                        Text("Describe what you want to draw:")
                            .font(DS.Typography.button)
                            .foregroundStyle(DS.Color.textPrimary)
                        
                        Spacer()
                        
                        Text("\(promptText.count)/\(maxPromptLength)")
                            .font(DS.Typography.caption)
                            .foregroundStyle(promptText.count > maxPromptLength * 9/10 ? DS.Color.primary : DS.Color.textTertiary)
                            .monospacedDigit()
                    }
                    
                    TextField("e.g., A cute cat sitting on a windowsill...", text: $promptText, axis: .vertical)
                        .textFieldStyle(PlainTextFieldStyle())
                        .lineLimit(3...6)
                        .padding(DS.Space.m)
                        .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
                        .overlay {
                            RoundedRectangle(cornerRadius: DS.Radius.medium)
                                .stroke(DS.Color.border, lineWidth: 1)
                        }
                        .onChange(of: promptText) { newValue in
                            if newValue.count > maxPromptLength {
                                promptText = String(newValue.prefix(maxPromptLength))
                            }
                        }
                }
                
                // Style selection
                VStack(spacing: DS.Space.s) {
                    HStack {
                        Text("Choose Style:")
                            .font(DS.Typography.button)
                            .foregroundStyle(DS.Color.textPrimary)
                        
                        Spacer()
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DS.Space.s), count: 2), spacing: DS.Space.s) {
                        ForEach(GenerationPrompt.GenerationStyle.allCases, id: \.self) { style in
                            StyleSelectionCard(
                                style: style,
                                isSelected: selectedStyle == style
                            ) {
                                selectedStyle = style
                            }
                        }
                    }
                }
                
                // Generate button
                Button {
                    generateIllustration()
                } label: {
                    HStack(spacing: DS.Space.s) {
                        if isGenerating {
                            DSLoadingSpinner(size: 16, color: DS.Color.background)
                        } else {
                            Image(systemName: "wand.and.stars")
                        }
                        Text(isGenerating ? "Generating..." : "Generate Illustration")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isGenerating)
                
                // Generation progress
                if isGenerating {
                    VStack(spacing: DS.Space.s) {
                        HStack {
                            Text("Creating your illustration...")
                                .font(DS.Typography.caption)
                                .foregroundStyle(DS.Color.textSecondary)
                            
                            Spacer()
                            
                            Text("\(Int(generationProgress * 100))%")
                                .font(DS.Typography.caption)
                                .foregroundStyle(DS.Color.textPrimary)
                                .monospacedDigit()
                        }
                        
                        DSProgressBar(progress: generationProgress)
                    }
                }
            }
            .padding(.horizontal, DS.Space.m)
            
            // Recent generations
            if !generatedIllustrations.isEmpty {
                VStack(spacing: DS.Space.s) {
                    HStack {
                        Text("Recent Generations")
                            .font(DS.Typography.button)
                            .foregroundStyle(DS.Color.textPrimary)
                        
                        Spacer()
                        
                        Text("\(generatedIllustrations.count)")
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textSecondary)
                            .padding(.horizontal, DS.Space.s)
                            .padding(.vertical, 2)
                            .background(DS.Color.highlight, in: Capsule())
                    }
                    .padding(.horizontal, DS.Space.m)
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DS.Space.m), count: 2), spacing: DS.Space.m) {
                            ForEach(generatedIllustrations.reversed()) { illustration in
                                GeneratedIllustrationCard(illustration: illustration) {
                                    currentGeneration = illustration
                                    showingResult = true
                                }
                            }
                        }
                        .padding(.horizontal, DS.Space.m)
                        .padding(.bottom, DS.Space.l)
                    }
                }
            } else if !isGenerating {
                Spacer()
                
                DSEmptyState(
                    icon: "wand.and.stars",
                    title: "No Illustrations Yet",
                    subtitle: "Enter a prompt above to generate your first AI illustration"
                )
                .padding(DS.Space.l)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingResult) {
            if let illustration = currentGeneration {
                GeneratedIllustrationResultSheet(
                    illustration: illustration,
                    onAddToLibrary: { addToLibrary(illustration) },
                    onUseForSketch: { }
                )
            }
        }
        .onAppear {
            loadGeneratedIllustrations()
        }
        .onChange(of: generatedIllustrations) { _ in
            saveGeneratedIllustrations()
        }
    }
    
    // MARK: - Private Methods
    private func generateIllustration() {
        guard !promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isGenerating = true
        generationProgress = 0.0
        
        Task {
            // Simulate AI generation with progress updates
            let steps = 10
            for i in 0...steps {
                await MainActor.run {
                    generationProgress = Double(i) / Double(steps)
                }
                try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
            }
            
            // Create mock generated illustration
            let illustration = GeneratedIllustration(
                prompt: promptText.trimmingCharacters(in: .whitespacesAndNewlines),
                style: selectedStyle,
                imageName: selectedStyle.rawValue + "_generated_\(Date().timeIntervalSince1970)",
                dateGenerated: Date()
            )
            
            await MainActor.run {
                generatedIllustrations.append(illustration)
                currentGeneration = illustration
                isGenerating = false
                generationProgress = 0.0
                showingResult = true
                
                // Clear form
                promptText = ""
            }
        }
    }
    
    private func addToLibrary(_ illustration: GeneratedIllustration) {
        // In a real implementation, this would save the actual image data
        // For now, we'll create a mock library item
        
        // Create placeholder image data (in real app, this would be the actual generated image)
        let placeholderImage = UIImage(systemName: "photo")!
        let imageData = placeholderImage.pngData()!
        
        let libraryItem = LibraryItem(
            name: illustration.prompt.prefix(30) + "...",
            imageData: imageData,
            dateCreated: illustration.dateGenerated,
            type: .generated
        )
        
        // Save to library (this would integrate with LibraryUploadView's storage)
        var savedItems = loadLibraryItems()
        savedItems.append(libraryItem)
        saveLibraryItems(savedItems)
    }
    
    private func loadLibraryItems() -> [LibraryItem] {
        if let data = UserDefaults.standard.data(forKey: "LibraryItems"),
           let items = try? JSONDecoder().decode([LibraryItem].self, from: data) {
            return items
        }
        return []
    }
    
    private func saveLibraryItems(_ items: [LibraryItem]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "LibraryItems")
        }
    }
    
    private func loadGeneratedIllustrations() {
        // Load from UserDefaults for now
        if let data = UserDefaults.standard.data(forKey: "GeneratedIllustrations"),
           let illustrations = try? JSONDecoder().decode([GeneratedIllustration].self, from: data) {
            generatedIllustrations = illustrations
        }
    }
    
    private func saveGeneratedIllustrations() {
        // Save to UserDefaults for now
        if let data = try? JSONEncoder().encode(generatedIllustrations) {
            UserDefaults.standard.set(data, forKey: "GeneratedIllustrations")
        }
    }
}

// MARK: - Supporting Components
struct StyleSelectionCard: View {
    let style: GenerationPrompt.GenerationStyle
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DS.Space.s) {
                Image(systemName: style.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? DS.Color.background : DS.Color.primary)
                
                Text(style.displayName)
                    .font(DS.Typography.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? DS.Color.background : DS.Color.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(DS.Space.m)
            .background(
                isSelected ? DS.Color.primary : DS.Color.surface,
                in: RoundedRectangle(cornerRadius: DS.Radius.medium)
            )
            .overlay {
                if !isSelected {
                    RoundedRectangle(cornerRadius: DS.Radius.medium)
                        .stroke(DS.Color.border, lineWidth: 1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GeneratedIllustrationCard: View {
    let illustration: GeneratedIllustration
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DS.Space.s) {
                // Placeholder image
                Image(systemName: illustration.systemImage)
                    .font(.system(size: 48))
                    .foregroundStyle(DS.Color.primary)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(DS.Color.highlight, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
                
                // Prompt preview
                VStack(spacing: DS.Space.xs) {
                    Text(illustration.prompt)
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text(illustration.style.displayName)
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textTertiary)
                        
                        Spacer()
                        
                        Text(illustration.dateGenerated, style: .date)
                            .font(DS.Typography.caption)
                            .foregroundStyle(DS.Color.textTertiary)
                    }
                }
            }
            .padding(DS.Space.s)
        }
        .buttonStyle(PlainButtonStyle())
        .dsCompactCard()
    }
}

struct GeneratedIllustrationResultSheet: View {
    let illustration: GeneratedIllustration
    let onAddToLibrary: () -> Void
    let onUseForSketch: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingSuccessToast = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: DS.Space.l) {
                // Generated image preview
                Image(systemName: illustration.systemImage)
                    .font(.system(size: 120))
                    .foregroundStyle(DS.Color.primary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(DS.Color.highlight, in: RoundedRectangle(cornerRadius: DS.Radius.large))
                
                // Details
                VStack(spacing: DS.Space.m) {
                    VStack(spacing: DS.Space.s) {
                        Text("Generated Illustration")
                            .font(DS.Typography.headline)
                            .foregroundStyle(DS.Color.textPrimary)
                        
                        HStack(spacing: DS.Space.s) {
                            Image(systemName: illustration.style.icon)
                                .font(.system(size: 14))
                            Text(illustration.style.displayName + " Style")
                                .font(DS.Typography.caption)
                        }
                        .foregroundStyle(DS.Color.textSecondary)
                        .padding(.horizontal, DS.Space.m)
                        .padding(.vertical, DS.Space.s)
                        .background(DS.Color.highlight, in: Capsule())
                    }
                    
                    Text("\"\(illustration.prompt)\"")
                        .font(DS.Typography.body)
                        .foregroundStyle(DS.Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding(.horizontal, DS.Space.m)
                        .padding(.vertical, DS.Space.s)
                        .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Radius.medium))
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: DS.Space.m) {
                    NavigationLink(destination: CameraView()) {
                        HStack(spacing: DS.Space.s) {
                            Image(systemName: "arkit")
                            Text("Use for Sketch")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button {
                        onAddToLibrary()
                        showingSuccessToast = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    } label: {
                        HStack(spacing: DS.Space.s) {
                            Image(systemName: "folder.badge.plus")
                            Text("Add to Library")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
            .padding(DS.Space.l)
            .navigationTitle("Generated Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .dsToast(
            isPresented: $showingSuccessToast,
            type: .success,
            title: "Added to Library",
            message: "Illustration saved to your personal library"
        )
    }
}

// Make GeneratedIllustration Codable for persistence
extension GeneratedIllustration: Codable {
    enum CodingKeys: String, CodingKey {
        case id, prompt, style, imageName, dateGenerated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let prompt = try container.decode(String.self, forKey: .prompt)
        let style = try container.decode(GenerationPrompt.GenerationStyle.self, forKey: .style)
        let imageName = try container.decode(String.self, forKey: .imageName)
        let dateGenerated = try container.decode(Date.self, forKey: .dateGenerated)
        
        self.init(id: id, prompt: prompt, style: style, imageName: imageName, dateGenerated: dateGenerated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(style, forKey: .style)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(dateGenerated, forKey: .dateGenerated)
    }
}

extension GeneratedIllustration {
    init(id: UUID = UUID(), prompt: String, style: GenerationPrompt.GenerationStyle, imageName: String, dateGenerated: Date) {
        self.id = id
        self.prompt = prompt
        self.style = style
        self.imageName = imageName
        self.dateGenerated = dateGenerated
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        IllustrationGeneratorView()
    }
}
