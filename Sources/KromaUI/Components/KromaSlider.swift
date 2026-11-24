import SwiftUI

/// Posuvník ve stylu specifikace: dvojklik resetuje na výchozí hodnotu,
/// číselná hodnota v SF Pro Mono s tabulárními číslicemi.
public struct KromaSlider: View {
    public let title: String
    @Binding public var value: Double
    public let range: ClosedRange<Double>
    public let step: Double
    public let defaultValue: Double
    public let format: String

    public init(title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double = 0.01, defaultValue: Double = 0, format: String = "%.2f") {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.defaultValue = defaultValue
        self.format = format
    }

    public var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
                .frame(width: 72, alignment: .leading)
            Slider(value: $value, in: range, step: step)
                .tint(DesignTokens.Palette.accentGreenHover)
                .onTapGesture(count: 2) {
                    value = defaultValue
                }
            Text(String(format: format, value))
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
                .frame(width: 56, alignment: .trailing)
        }
    }
}
