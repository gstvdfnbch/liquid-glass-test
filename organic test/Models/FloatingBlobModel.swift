// Modelos de dados para blobs flutuantes e animados
import SwiftUI

struct FloatingBlobModel: Identifiable {
    let id = UUID()
    let size: CGFloat
    let startPosition: CGPoint
    let endPosition: CGPoint?
    let duration: Double?
    // Para blobs físicos, pode-se ignorar endPosition/duration
    // Para blobs animados, preencher ambos
}
