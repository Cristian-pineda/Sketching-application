import SwiftUI

struct TracingOverlayView: View {
    @Binding var overlayImage: UIImage?
    @Binding var opacity: Double

    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            if let uiImage = overlayImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                },
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                        )
                    )
            }
        }
        .allowsHitTesting(overlayImage != nil)
        .animation(.easeInOut(duration: 0.15), value: opacity)
    }
}

