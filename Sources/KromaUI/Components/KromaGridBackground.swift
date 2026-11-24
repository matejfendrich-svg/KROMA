import SwiftUI

/// Jemná mřížka 32 px jako pozadí plochy (bg-grid z FR_APP): linky rgba(255,255,255,0.03).
public struct KromaGridBackground: View {
    public init() {}

    public var body: some View {
        Canvas { context, size in
            let step = DesignTokens.gridSpacing
            let line = Color.white.opacity(0.03)
            var offsetX: CGFloat = 0
            while offsetX <= size.width {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: offsetX, y: 0))
                        path.addLine(to: CGPoint(x: offsetX, y: size.height))
                    },
                    with: .color(line),
                    lineWidth: 1
                )
                offsetX += step
            }
            var offsetY: CGFloat = 0
            while offsetY <= size.height {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: offsetY))
                        path.addLine(to: CGPoint(x: size.width, y: offsetY))
                    },
                    with: .color(line),
                    lineWidth: 1
                )
                offsetY += step
            }
        }
    }
}
