////
////  ContentView.swift
////  organic test
////
////  Created by Gustavo Diefenbach on 28/12/25.
////
//
//import SwiftUI
//
//struct FloatingBlob: Identifiable {
//    let id = UUID()
//    let size: CGFloat
//    let startPosition: CGPoint
//    let endPosition: CGPoint
//    let duration: Double
//}
//
//struct ContentView: View {
//
//    private let blobs: [FloatingBlob] = (0..<30).map { _ in
//        FloatingBlob(
//            size: CGFloat.random(in: 20...100),
//            startPosition: CGPoint(
//                x: CGFloat.random(in: 0.1...0.9),
//                y: CGFloat.random(in: 0.1...0.9)
//            ),
//            endPosition: CGPoint(
//                x: CGFloat.random(in: 0.1...0.9),
//                y: CGFloat.random(in: 0.1...0.9)
//            ),
//            duration: Double.random(in: 12...20)
//        )
//    }
//
//    @State private var animate = false
//
//    var body: some View {
//        GlassEffectContainer(spacing: 60) {
//            GeometryReader { geo in
//                ZStack {
//                    ForEach(blobs) { blob in
//                        VStack{}
//                            .frame(width: blob.size, height: blob.size)
//                            .glassEffect(.clear.interactive())
//                            .shadow(radius: 100)
//                            .position(
//                                x: (animate ? blob.endPosition.x : blob.startPosition.x) * geo.size.width,
//                                y: (animate ? blob.endPosition.y : blob.startPosition.y) * geo.size.height
//                            )
//                            .animation(
//                                .easeInOut(duration: blob.duration)
//                                .repeatForever(autoreverses: true),
//                                value: animate
//                            )
//                    }
//                }
//                .background(
//                    Image("background-image2")
//                        .resizable()
//                        .scaledToFill()
//                        .saturation(0.0)
//                        .frame(width: geo.size.width, height: geo.size.height)
//                        .clipped()
//                )
//                .onAppear {
//                    animate = true
//                }
//            }
//            .ignoresSafeArea()
//        }
//
//    }
//}
//
//#Preview {
//    ContentView()
//}
