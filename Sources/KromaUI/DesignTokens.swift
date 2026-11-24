import SwiftUI

/// Design system Kroma – inspirováno FR_APP (MONO/FRAME): čistě monochromatická
/// paleta #000–#FFF, bílý akcent, karty 12 px, pill, snap easing
/// cubic-bezier(0.2, 0, 0, 1) / 180 ms. Viz docs/design.md a ADR 0005.
public enum DesignTokens {
    public static let cardCornerRadius: CGFloat = 12
    public static let badgeCornerRadius: CGFloat = 999
    public static let separatorWidth: CGFloat = 1
    public static let dockHeight: CGFloat = 56
    public static let dockLabelSize: CGFloat = 10
    public static let sidebarWidth: CGFloat = 230
    public static let inspectorWidth: CGFloat = 300
    public static let snapDuration: Double = 0.18
    public static let gridSpacing: CGFloat = 32

    public enum Palette {
        public static let base = Color(hex: "#000000")
        public static let panel = Color(hex: "#0A0A0A")
        public static let elevated = Color(hex: "#141414")
        public static let separator = Color(hex: "#262626")
        public static let separatorStrong = Color(hex: "#3D3D3D")
        public static let textPrimary = Color(hex: "#FFFFFF")
        public static let textSecondary = Color(hex: "#A3A3A3")
        public static let textFaint = Color(hex: "#525252")
        public static let accent = Color(hex: "#FFFFFF")
        public static let onAccent = Color(hex: "#000000")
        // Sémantické stavové barvy (indikátor tepla apod.), ne součást mono tématu.
        public static let statusGreen = Color(hex: "#2AA06B")
        public static let statusOrange = Color.orange
        public static let statusRed = Color(hex: "#D9483B")
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
