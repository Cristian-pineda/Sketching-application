import SwiftUI

struct ImageCropView: View {
    let originalImage: UIImage
    @State private var croppedImage: UIImage?
    @State private var cropRect: CGRect = CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8)
    @State private var imageSize: CGSize = .zero
    @State private var imagePosition: CGPoint = .zero
    @State private var showingPreview: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if showingPreview {
                    // Preview Mode
                    previewView
                } else {
                    // Crop Mode
                    cropView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        if showingPreview {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingPreview = false
                            }
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundStyle(DS.Color.textSecondary)
                }
            }
        }
    }
    
    private var previewView: some View {
        VStack(spacing: DS.Space.l) {
            // Header
            VStack(spacing: DS.Space.s) {
                Text("Crop Preview")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Text("This is how your cropped image will look in the AR experience")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, DS.Space.l)
            
            // Cropped image preview
            if let croppedImage = croppedImage {
                VStack(spacing: DS.Space.m) {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.large))
                        .shadow(color: DS.Color.textPrimary.opacity(0.1), radius: 10, y: 5)
                    
                    Text("Cropped Image")
                        .font(DS.Typography.caption)
                        .foregroundStyle(DS.Color.textSecondary)
                }
                .dsCard()
                .padding(.horizontal, DS.Space.l)
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: DS.Space.s) {
                // Continue to AR button
                NavigationLink(destination: CameraView(overlayImage: croppedImage)) {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "arkit")
                            .font(.system(size: 18, weight: .medium))
                        Text("Start AR Tracing")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                
                // Back to crop button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingPreview = false
                    }
                }) {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "crop")
                            .font(.system(size: 16, weight: .medium))
                        Text("Adjust Crop")
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, DS.Space.l)
            .padding(.bottom, DS.Space.l)
        }
        .background(DS.Color.background.ignoresSafeArea())
    }
    
    private var cropView: some View {
        VStack(spacing: DS.Space.l) {
            // Header
            VStack(spacing: DS.Space.s) {
                Text("Crop Your Image")
                    .font(DS.Typography.title)
                    .foregroundStyle(DS.Color.textPrimary)
                
                Text("Adjust the crop area to focus on the part you want to trace")
                    .font(DS.Typography.body)
                    .foregroundStyle(DS.Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, DS.Space.l)
            
            // Crop area
            GeometryReader { geometry in
                ZStack {
                    // Background image
                    Image(uiImage: originalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onAppear {
                            calculateImageBounds(in: geometry)
                        }
                        .onChange(of: geometry.size) { _ in
                            calculateImageBounds(in: geometry)
                        }
                    
                    // Crop overlay
                    CropOverlay(
                        cropRect: $cropRect,
                        imageSize: imageSize,
                        imagePosition: imagePosition,
                        containerSize: geometry.size
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.medium))
            .padding(.horizontal, DS.Space.l)
            
            // Action buttons
            VStack(spacing: DS.Space.s) {
                // Preview crop button
                Button(action: previewCrop) {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "eye")
                            .font(.system(size: 18, weight: .medium))
                        Text("Preview Crop")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                
                // Reset crop button
                Button(action: resetCrop) {
                    HStack(spacing: DS.Space.s) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .medium))
                        Text("Reset Crop")
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, DS.Space.l)
            .padding(.bottom, DS.Space.l)
        }
        .background(DS.Color.background.ignoresSafeArea())
    }
    
    private func calculateImageBounds(in geometry: GeometryProxy) {
        let imageAspectRatio = originalImage.size.width / originalImage.size.height
        let containerAspectRatio = geometry.size.width / geometry.size.height
        
        let displaySize: CGSize
        let displayPosition: CGPoint
        
        if imageAspectRatio > containerAspectRatio {
            // Image is wider than container - fit to width
            let displayWidth = geometry.size.width
            let displayHeight = displayWidth / imageAspectRatio
            displaySize = CGSize(width: displayWidth, height: displayHeight)
            displayPosition = CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        } else {
            // Image is taller than container - fit to height
            let displayHeight = geometry.size.height
            let displayWidth = displayHeight * imageAspectRatio
            displaySize = CGSize(width: displayWidth, height: displayHeight)
            displayPosition = CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
        
        // Only update if the values have changed significantly to avoid constant recalculations
        if abs(imageSize.width - displaySize.width) > 1 || abs(imageSize.height - displaySize.height) > 1 {
            imageSize = displaySize
            imagePosition = displayPosition
        }
    }
    
    private func resetCrop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            cropRect = CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8)
        }
    }
    
    private func previewCrop() {
        updateCroppedImage()
        withAnimation(.easeInOut(duration: 0.3)) {
            showingPreview = true
        }
    }
    
    private func updateCroppedImage() {
        guard imageSize != .zero else { return }
        
        // Get the original image properties
        guard let cgImage = originalImage.cgImage else { return }
        
        // Calculate the crop rectangle in the original image's coordinate system
        let cropX = cropRect.minX * CGFloat(cgImage.width)
        let cropY = cropRect.minY * CGFloat(cgImage.height)
        let cropWidth = cropRect.width * CGFloat(cgImage.width)
        let cropHeight = cropRect.height * CGFloat(cgImage.height)
        
        // Ensure the crop rectangle is within bounds
        let clampedCropRect = CGRect(
            x: max(0, min(cropX, CGFloat(cgImage.width - 1))),
            y: max(0, min(cropY, CGFloat(cgImage.height - 1))),
            width: max(1, min(cropWidth, CGFloat(cgImage.width) - max(0, cropX))),
            height: max(1, min(cropHeight, CGFloat(cgImage.height) - max(0, cropY)))
        )
        
        // Perform the crop
        if let croppedCGImage = cgImage.cropping(to: clampedCropRect) {
            // Create the new UIImage with proper scale and orientation
            croppedImage = UIImage(
                cgImage: croppedCGImage,
                scale: originalImage.scale,
                orientation: originalImage.imageOrientation
            )
        }
    }
}

struct CropOverlay: View {
    @Binding var cropRect: CGRect
    let imageSize: CGSize
    let imagePosition: CGPoint
    let containerSize: CGSize
    
    @State private var isDraggingCorner = false
    @State private var isDraggingCenter = false
    @State private var dragStartRect: CGRect = .zero
    
    private var imageBounds: CGRect {
        CGRect(
            x: imagePosition.x - imageSize.width / 2,
            y: imagePosition.y - imageSize.height / 2,
            width: imageSize.width,
            height: imageSize.height
        )
    }
    
    private var cropFrame: CGRect {
        CGRect(
            x: imageBounds.minX + cropRect.minX * imageSize.width,
            y: imageBounds.minY + cropRect.minY * imageSize.height,
            width: cropRect.width * imageSize.width,
            height: cropRect.height * imageSize.height
        )
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent overlay
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .mask(
                    Rectangle()
                        .overlay(
                            Rectangle()
                                .frame(width: cropFrame.width, height: cropFrame.height)
                                .position(x: cropFrame.midX, y: cropFrame.midY)
                                .blendMode(.destinationOut)
                        )
                )
            
            // Crop frame
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: cropFrame.width, height: cropFrame.height)
                .position(x: cropFrame.midX, y: cropFrame.midY)
            
            // Corner handles
            ForEach(0..<4, id: \.self) { index in
                CropHandle(
                    position: cornerPosition(for: index),
                    onDragStart: {
                        isDraggingCorner = true
                        dragStartRect = cropRect
                    },
                    onDrag: { offset in
                        updateCropRect(for: index, offset: offset, startRect: dragStartRect)
                    },
                    onDragEnd: {
                        isDraggingCorner = false
                    }
                )
            }
            
            // Center drag area for moving the entire crop area
            Rectangle()
                .fill(Color.clear)
                .frame(width: max(cropFrame.width - 40, 40), height: max(cropFrame.height - 40, 40))
                .position(x: cropFrame.midX, y: cropFrame.midY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if !isDraggingCorner {
                                moveCropRect(by: value.translation)
                            }
                        }
                )
        }
    }
    
    private func cornerPosition(for index: Int) -> CGPoint {
        switch index {
        case 0: return CGPoint(x: cropFrame.minX, y: cropFrame.minY) // Top-left
        case 1: return CGPoint(x: cropFrame.maxX, y: cropFrame.minY) // Top-right
        case 2: return CGPoint(x: cropFrame.maxX, y: cropFrame.maxY) // Bottom-right
        case 3: return CGPoint(x: cropFrame.minX, y: cropFrame.maxY) // Bottom-left
        default: return .zero
        }
    }
    
    private func updateCropRect(for cornerIndex: Int, offset: CGSize, startRect: CGRect) {
        let normalizedOffset = CGSize(
            width: offset.width / imageSize.width,
            height: offset.height / imageSize.height
        )
        
        var newRect = startRect
        let minSize: CGFloat = 0.05 // Minimum 5% of image size
        
        switch cornerIndex {
        case 0: // Top-left
            let newX = max(0, min(startRect.maxX - minSize, startRect.minX + normalizedOffset.width))
            let newY = max(0, min(startRect.maxY - minSize, startRect.minY + normalizedOffset.height))
            newRect = CGRect(
                x: newX,
                y: newY,
                width: startRect.maxX - newX,
                height: startRect.maxY - newY
            )
        case 1: // Top-right
            let newWidth = max(minSize, min(1.0 - startRect.minX, startRect.width + normalizedOffset.width))
            let newY = max(0, min(startRect.maxY - minSize, startRect.minY + normalizedOffset.height))
            newRect = CGRect(
                x: startRect.minX,
                y: newY,
                width: newWidth,
                height: startRect.maxY - newY
            )
        case 2: // Bottom-right
            let newWidth = max(minSize, min(1.0 - startRect.minX, startRect.width + normalizedOffset.width))
            let newHeight = max(minSize, min(1.0 - startRect.minY, startRect.height + normalizedOffset.height))
            newRect = CGRect(
                x: startRect.minX,
                y: startRect.minY,
                width: newWidth,
                height: newHeight
            )
        case 3: // Bottom-left
            let newX = max(0, min(startRect.maxX - minSize, startRect.minX + normalizedOffset.width))
            let newHeight = max(minSize, min(1.0 - startRect.minY, startRect.height + normalizedOffset.height))
            newRect = CGRect(
                x: newX,
                y: startRect.minY,
                width: startRect.maxX - newX,
                height: newHeight
            )
        default:
            break
        }
        
        // Final validation to ensure the rectangle is within bounds
        newRect = CGRect(
            x: max(0, min(newRect.origin.x, 1.0 - minSize)),
            y: max(0, min(newRect.origin.y, 1.0 - minSize)),
            width: max(minSize, min(newRect.width, 1.0 - newRect.origin.x)),
            height: max(minSize, min(newRect.height, 1.0 - newRect.origin.y))
        )
        
        cropRect = newRect
    }
    
    private func moveCropRect(by translation: CGSize) {
        let normalizedTranslation = CGSize(
            width: translation.width / imageSize.width,
            height: translation.height / imageSize.height
        )
        
        var newRect = cropRect
        newRect.origin.x += normalizedTranslation.width
        newRect.origin.y += normalizedTranslation.height
        
        // Constrain to image bounds
        newRect.origin.x = max(0, min(newRect.origin.x, 1.0 - newRect.width))
        newRect.origin.y = max(0, min(newRect.origin.y, 1.0 - newRect.height))
        
        cropRect = newRect
    }
}

struct CropHandle: View {
    let position: CGPoint
    let onDragStart: () -> Void
    let onDrag: (CGSize) -> Void
    let onDragEnd: () -> Void
    
    @State private var dragStartPosition: CGPoint = .zero
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 24, height: 24)
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if dragStartPosition == .zero {
                            dragStartPosition = value.startLocation
                            onDragStart()
                        }
                        onDrag(value.translation)
                    }
                    .onEnded { _ in
                        dragStartPosition = .zero
                        onDragEnd()
                    }
            )
    }
}

struct ImageCropView_Previews: PreviewProvider {
    static var previews: some View {
        if let image = UIImage(systemName: "photo") {
            ImageCropView(originalImage: image)
        }
    }
}
