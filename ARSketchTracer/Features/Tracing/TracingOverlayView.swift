import SwiftUI

struct TracingOverlayView: View {
    @Binding var overlayImage: UIImage?
    @Binding var opacity: Double
    @Binding var isLocked: Bool

    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var rotation: Angle = .zero

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
                                        offset = value.translation
                                    },
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = value
                                    }
                            ),
                            RotationGesture()
                                .onChanged { value in
                                    rotation = value
                                }
                        )
                    )
            }
        }
        .allowsHitTesting(overlayImage != nil && !isLocked)
        .animation(.easeInOut(duration: 0.15), value: opacity)
    }
}

