import SwiftUI

struct ImageCropView: View {
    let originalImage: UIImage
    @State private var croppedImage: UIImage?
    @State private var cropRect: CGRect = CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8)
    @State private var imageSize: CGSize = .zero
    @State private var imagePosition: CGPoint = .zero
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
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
                VStack(spacing: DS.Space.m) {
                    // Reset crop button
                    Button(action: resetCrop) {
                        HStack(spacing: DS.Space.s) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 16, weight: .medium))
                            Text("Reset Crop")
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    
                    // Continue to AR button
                    NavigationLink(destination: CameraView(overlayImage: croppedImage ?? originalImage)) {
                        HStack(spacing: DS.Space.s) {
                            Image(systemName: "arkit")
                                .font(.system(size: 18, weight: .medium))
                            Text("Start AR Tracing")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .onAppear {
                        updateCroppedImage()
                    }
                    .onChange(of: cropRect) { _ in
                        updateCroppedImage()
                    }
                }
                .padding(.horizontal, DS.Space.l)
                .padding(.bottom, DS.Space.l)
            }
            .background(DS.Color.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundStyle(DS.Color.textSecondary)
                }
            }
        }
    }
    
    private func calculateImageBounds(in geometry: GeometryProxy) {
        let imageAspectRatio = originalImage.size.width / originalImage.size.height
        let containerAspectRatio = geometry.size.width / geometry.size.height
        
        if imageAspectRatio > containerAspectRatio {
            // Image is wider than container
            let displayWidth = geometry.size.width
            let displayHeight = displayWidth / imageAspectRatio
            imageSize = CGSize(width: displayWidth, height: displayHeight)
            imagePosition = CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        } else {
            // Image is taller than container
            let displayHeight = geometry.size.height
            let displayWidth = displayHeight * imageAspectRatio
            imageSize = CGSize(width: displayWidth, height: displayHeight)
            imagePosition = CGPoint(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
    
    private func resetCrop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            cropRect = CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.8)
        }
    }
    
    private func updateCroppedImage() {
        guard imageSize != .zero else { return }
        
        let scale = originalImage.scale
        let imageRect = CGRect(
            x: cropRect.minX * originalImage.size.width,
            y: cropRect.minY * originalImage.size.height,
            width: cropRect.width * originalImage.size.width,
            height: cropRect.height * originalImage.size.height
        )
        
        if let cgImage = originalImage.cgImage?.cropping(to: imageRect) {
            croppedImage = UIImage(cgImage: cgImage, scale: scale, orientation: originalImage.imageOrientation)
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
        
        switch cornerIndex {
        case 0: // Top-left
            let newX = max(0, min(startRect.maxX - 0.1, startRect.minX + normalizedOffset.width))
            let newY = max(0, min(startRect.maxY - 0.1, startRect.minY + normalizedOffset.height))
            newRect = CGRect(
                x: newX,
                y: newY,
                width: startRect.maxX - newX,
                height: startRect.maxY - newY
            )
        case 1: // Top-right
            let newWidth = max(0.1, min(1.0 - startRect.minX, startRect.width + normalizedOffset.width))
            let newY = max(0, min(startRect.maxY - 0.1, startRect.minY + normalizedOffset.height))
            newRect = CGRect(
                x: startRect.minX,
                y: newY,
                width: newWidth,
                height: startRect.maxY - newY
            )
        case 2: // Bottom-right
            let newWidth = max(0.1, min(1.0 - startRect.minX, startRect.width + normalizedOffset.width))
            let newHeight = max(0.1, min(1.0 - startRect.minY, startRect.height + normalizedOffset.height))
            newRect = CGRect(
                x: startRect.minX,
                y: startRect.minY,
                width: newWidth,
                height: newHeight
            )
        case 3: // Bottom-left
            let newX = max(0, min(startRect.maxX - 0.1, startRect.minX + normalizedOffset.width))
            let newHeight = max(0.1, min(1.0 - startRect.minY, startRect.height + normalizedOffset.height))
            newRect = CGRect(
                x: newX,
                y: startRect.minY,
                width: startRect.maxX - newX,
                height: newHeight
            )
        default:
            break
        }
        
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
