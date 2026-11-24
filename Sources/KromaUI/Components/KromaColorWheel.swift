import SwiftUI

/// Balanční kolo podle prototypu: conic-gradient přes 6 barev, tmavý střed,
/// bílý „knob" tažený ukazatelem, pod ním název a mono hodnota hue° / sytost.
/// Jediný barevný prvek rozhraní.
public struct KromaColorWheel: View {
    public let name: String
    @Binding public var position: CGPoint

    public init(name: String, position: Binding<CGPoint>) {
        self.name = name
        self._position = position
    }

    private let size: CGFloat = 74

    public var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(AngularGradient(colors: DesignTokens.Palette.wheelColors, center: .center))
                    .frame(width: size, height: size)
                    .overlay(Circle().stroke(DesignTokens.Palette.separator, lineWidth: 2))
                Circle()
                    .fill(Color(hex: "#26282B"))
                    .frame(width: size - 36, height: size - 36)
                    .overlay(Circle().stroke(DesignTokens.Palette.separator, lineWidth: 1))
                Circle()
                    .fill(Color.white)
                    .frame(width: 14, height: 14)
                    .offset(x: position.x * 26, y: position.y * 26)
            }
            .frame(width: size, height: size)
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let x = (value.location.x - size / 2) / (size / 2)
                        let y = (value.location.y - size / 2) / (size / 2)
                        position = CGPoint(
                            x: min(1, max(-1, x)),
                            y: min(1, max(-1, y))
                        )
                    }
            )
            Text(name)
                .font(.system(size: 10, weight: .medium))
                .tracking(1.4)
                .textCase(.uppercase)
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            Text("\(hueDegrees)° \(saturation)")
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
        }
    }

    private var hueDegrees: Int {
        Int((atan2(position.y, position.x) * 180 / .pi + 360).truncatingRemainder(dividingBy: 360))
    }

    private var saturation: Int {
        Int((hypot(position.x, position.y) * 100).rounded())
    }
}
