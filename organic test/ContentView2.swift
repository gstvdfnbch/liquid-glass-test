import SwiftUI

struct ContentView2: View {

    private let blobs: [FloatingBlobModel] = (0..<30).map { _ in
        FloatingBlobModel(
            size: CGFloat.random(in: 20...100),
            startPosition: CGPoint(x: CGFloat.random(in: 0.1...0.9), y: CGFloat.random(in: 0.1...0.9)),
            endPosition: CGPoint(x: CGFloat.random(in: 0.1...0.9), y: CGFloat.random(in: 0.1...0.9)),
            duration: Double.random(in: 12...20)
        )
    }

    @State private var animate = false

    var body: some View {
        GlassEffectContainer(spacing: 60) {
            GeometryReader { geo in
                ZStack {
                    ForEach(blobs) { blob in
                        FloatingBlobView(size: blob.size, color: .cyan)
                            .position(
                                x: (animate ? (blob.endPosition?.x ?? 0) : blob.startPosition.x) * geo.size.width,
                                y: (animate ? (blob.endPosition?.y ?? 0) : blob.startPosition.y) * geo.size.height
                            )
                            .animation(
                                .easeInOut(duration: blob.duration ?? 10)
                                    .repeatForever(autoreverses: true),
                                value: animate
                            )
                    }
                }
                .background(
                    Image("background-image2")
                        .resizable()
                        .scaledToFill()
                        .saturation(0.0)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                )
                .onAppear {
                    animate = true
                }
            }
            .ignoresSafeArea()
        }

    }
}

#Preview {
    ContentView2()
}
