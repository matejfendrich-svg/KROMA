import SwiftUI

/// Design system Kroma podle interaktivního prototypu (monochrom): paleta spec 3.3,
/// akcent šedá/bílá, jediný barevný prvek UI jsou balanční kola (viz docs/design.md, ADR 0006).
public enum DesignTokens {
    public static let controlRadius: CGFloat = 4
    public static let cardRadius: CGFloat = 6
    public static let badgeRadius: CGFloat = 999
    public static let separatorWidth: CGFloat = 1
    public static let dockHeight: CGFloat = 64
    public static let headerHeight: CGFloat = 44
    public static let sidebarDefaultWidth: CGFloat = 190
    public static let sidebarMinWidth: CGFloat = 150
    public static let sidebarMaxWidth: CGFloat = 420
    public static let inspectorDefaultWidth: CGFloat = 248
    public static let inspectorMinWidth: CGFloat = 200
    public static let inspectorMaxWidth: CGFloat = 460
    public static let pageTransitionDuration: Double = 0.22
    public static let snapDuration: Double = 0.18
    public static let gridSpacing: CGFloat = 32

    public enum Palette {
        public static let base = Color(hex: "#0D0E0F")
        public static let deep = Color(hex: "#08090A")
        public static let headerBg = Color(hex: "#0A0B0C")
        public static let panel = Color(hex: "#151719")
        public static let elevated = Color(hex: "#1C1F22")
        public static let separator = Color(hex: "#26282B")
        public static let textPrimary = Color(hex: "#F4F4F2")
        public static let textSecondary = Color(hex: "#A6A8AA")
        public static let faint = Color(hex: "#3A3E44")
        // Akcent se volí v nastavení: seda #C9CED4 (výchozí) nebo bílá (viz Theme/AccentPreset).
        public static let onAccent = Color(hex: "#0A0A0B")
        // Sémantické stavové barvy mimo mono téma (indikátor tepla, spec 8.2).
        public static let statusGreen = Color(hex: "#2AA06B")
        public static let statusOrange = Color.orange
        public static let statusRed = Color(hex: "#D9483B")
        // Barvy balančních kol – jediný barevný prvek rozhraní (reprezentují barvu obrazu).
        public static let wheelColors: [Color] = [
            Color(hex: "#2AA06B"), Color(hex: "#D9483B"), Color(hex: "#7B6CE0"),
            Color(hex: "#3E8FD6"), Color(hex: "#D9C548"), Color(hex: "#2AA06B"),
        ]
    }

    /// Štítky klipů: osm šedých odstínů (černobílá stupnice z prototypu).
    public static let labelPalette: [Color] = [
        "#2A2C30", "#3A3D42", "#4A4E54", "#5B6066",
        "#6E747B", "#83898F", "#9BA1A7", "#B4BAC0",
    ].map(Color.init(hex:))
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
