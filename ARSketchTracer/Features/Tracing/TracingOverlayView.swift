import SwiftUI

struct TracingOverlayView: View {
    @Binding var overlayImage: UIImage?
    @Binding var opacity: Double
    @Binding var isLocked: Bool

    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var rotation: Angle = .zero
    
    // Store the last committed values
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    @State private var lastRotation: Angle = .zero

    var body: some View {
        ZStack {
            if let uiImage = overlayImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .rotationEffect(rotation)
                    .offset(offset)
                    .gesture(
                        // Only apply gestures when NOT locked
                        isLocked ? nil : 
                        SimultaneousGesture(
                            SimultaneousGesture(
                                DragGesture()
                                    .onChanged { value in
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        lastOffset = offset
                                    },
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = lastScale * value
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    }
                            ),
                            RotationGesture()
                                .onChanged { value in
                                    rotation = lastRotation + value
                                }
                                .onEnded { _ in
                                    lastRotation = rotation
                                }
                        )
                    )
            }
        }
        .allowsHitTesting(overlayImage != nil && !isLocked)
        .animation(.easeInOut(duration: 0.15), value: opacity)
    }
}

