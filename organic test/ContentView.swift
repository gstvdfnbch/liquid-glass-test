import SwiftUI
import CoreMotion
import UIKit

struct ContentView: View {

    private let motionManager = CMMotionManager()
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    // base positions on screen (not stacked)
    @State private var positions: [CGPoint] = Array(repeating: .zero, count: 3)

    // individual sizes (radius in points)
    private let radii: [CGFloat] = [45, 85, 65]

    // physics
    @State private var velocities: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var offsets: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var accelerations: [CGSize] = Array(repeating: .zero, count: 3)
    @State private var isTouchingWall: [Bool] = Array(repeating: false, count: 3)
    @State private var lastUpdate: Date = Date()

    @State private var animate = false
    

    var body: some View {
        GlassEffectContainer(spacing: 100) {
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        VStack{}
                            .frame(
                                width: radii[index] * 2,
                                height: radii[index] * 2
                            )
                            .glassEffect(.clear.interactive())
                            .shadow(radius: 100)
                            .position(
                                x: positions[index].x * geo.size.width,
                                y: positions[index].y * geo.size.height
                            )
                            .offset(offsets[index])
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
                    // initial layout: centered horizontally, stacked vertically
                    let centerX: CGFloat = 0.5
                    let baseY: CGFloat = 0.5
                    let verticalSpacing: CGFloat = 0.22

                    positions = [
                        CGPoint(x: centerX, y: baseY - verticalSpacing),
                        CGPoint(x: centerX, y: baseY),
                        CGPoint(x: centerX, y: baseY + verticalSpacing)
                    ]

                    hapticGenerator.prepare()

                    if motionManager.isAccelerometerAvailable {
                        motionManager.accelerometerUpdateInterval = 1 / 60
                        motionManager.startAccelerometerUpdates(to: .main) { data, _ in
                            guard let data else { return }

                            let now = Date()
                            let deltaTime = now.timeIntervalSince(lastUpdate)
                            lastUpdate = now

                            let gravity: CGFloat = 10000

                            for i in 0..<offsets.count {
                                let radius = radii[i]
                                let mass = max(.pi * radius * radius / 5_000, 1)

                                // acceleration (from accelerometer + mass)
                                accelerations[i] = CGSize(
                                    width: data.acceleration.x * gravity / mass,
                                    height: -data.acceleration.y * gravity / mass
                                )

                                // integrate acceleration -> velocity
                                velocities[i] = CGSize(
                                    width: velocities[i].width + accelerations[i].width * deltaTime,
                                    height: velocities[i].height + accelerations[i].height * deltaTime
                                )

                                // damping
                                velocities[i] = CGSize(
                                    width: velocities[i].width * 0.9,
                                    height: velocities[i].height * 0.9
                                )

                                var newOffset = CGSize(
                                    width: offsets[i].width + velocities[i].width * deltaTime,
                                    height: offsets[i].height + velocities[i].height * deltaTime
                                )

                                // screen bounds (consider circle radius)
                                let minX = -positions[i].x * geo.size.width + radius
                                let maxX = (1 - positions[i].x) * geo.size.width - radius
                                let minY = -positions[i].y * geo.size.height + radius
                                let maxY = (1 - positions[i].y) * geo.size.height - radius

                                var touchingWall = false

                                if newOffset.width < minX {
                                    newOffset.width = minX
                                    velocities[i].width *= -0.5
                                    touchingWall = true
                                } else if newOffset.width > maxX {
                                    newOffset.width = maxX
                                    velocities[i].width *= -0.5
                                    touchingWall = true
                                }

                                if newOffset.height < minY {
                                    newOffset.height = minY
                                    velocities[i].height *= -0.5
                                    touchingWall = true
                                } else if newOffset.height > maxY {
                                    newOffset.height = maxY
                                    velocities[i].height *= -0.5
                                    touchingWall = true
                                }

                                // fire haptic only on wall contact start
                                if touchingWall && !isTouchingWall[i] {
                                    let intensity = min(
                                        max(abs(velocities[i].width) + abs(velocities[i].height), 0.2),
                                        1.0
                                    )
                                    hapticGenerator.impactOccurred(intensity: intensity)
                                    hapticGenerator.prepare()
                                }

                                // update wall contact state
                                isTouchingWall[i] = touchingWall

                                offsets[i] = newOffset
                            }
                        }
                    }
                }
                .onDisappear {
                    motionManager.stopAccelerometerUpdates()
                }
            }
            .ignoresSafeArea()
        }

    }
}

#Preview {
    ContentView()
}
