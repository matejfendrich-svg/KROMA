import SwiftUI

/// Jemná mřížka 32 px jako pozadí plochy (bg-grid z FR_APP): linky rgba(255,255,255,0.03).
public struct KromaGridBackground: View {
    public init() {}

    public var body: some View {
        Canvas { context, size in
            let step = DesignTokens.gridSpacing
            let line = Color.white.opacity(0.03)
            var x: CGFloat = 0
            while x <= size.width {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    },
                    with: .color(line),
                    lineWidth: 1
                )
                x += step
            }
            var y: CGFloat = 0
            while y <= size.height {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    },
                    with: .color(line),
                    lineWidth: 1
                )
                y += step
            }
        }
    }
}
