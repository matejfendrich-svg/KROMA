import SwiftUI

/// Design system Kroma: tokeny podle specifikace kapitola 3.3.
/// Žádné natvrdo zapsané barvy v komponentách – vše přes tyto tokeny.
public enum DesignTokens {
    public static let panelCornerRadius: CGFloat = 4
    public static let separatorWidth: CGFloat = 1
    public static let dockHeight: CGFloat = 56
    public static let dockLabelSize: CGFloat = 10

    public enum Palette {
        public static let base = Color(hex: "#0D0E0F")
        public static let panel = Color(hex: "#151719")
        public static let elevated = Color(hex: "#1C1F22")
        public static let separator = Color(hex: "#26282B")
        public static let textPrimary = Color(hex: "#F4F4F2")
        public static let textSecondary = Color(hex: "#A6A8AA")
        public static let accentGreen = Color(hex: "#185238")
        public static let accentGreenHover = Color(hex: "#2AA06B")
        public static let accentRed = Color(hex: "#D9483B")
        public static let accentBlue = Color(hex: "#2F6FB5")
    }
}

public extension Color {
    init(hex: String) {
        let cleaned = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        let rgb = UInt64(cleaned, radix: 16) ?? 0
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}
