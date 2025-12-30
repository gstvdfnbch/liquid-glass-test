import SwiftUI

struct FloatingBlobView: View {
    let size: CGFloat
    let color: Color
    var body: some View {
        VStack {}
            .frame(width: size, height: size)
            .glassEffect(.clear.interactive())
            .shadow(radius: 100)
            .background(Color.clear)
            .clipShape(Circle())
    }
}

#if DEBUG
#Preview {
    FloatingBlobView(size: 80, color: .blue)
}
#endif
