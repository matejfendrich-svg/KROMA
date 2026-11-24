import Foundation
import Observation
import SwiftUI

/// Předvolby dominantní barvy aplikace (nastavení, sekce Pracovní prostředí).
public enum AccentPreset: String, Codable, Sendable, CaseIterable, Identifiable {
    case green
    case red
    case blue
    case graphite

    public var id: String { rawValue }

    public var base: Color {
        switch self {
        case .green: return DesignTokens.Palette.accentGreen
        case .red: return DesignTokens.Palette.accentRed
        case .blue: return DesignTokens.Palette.accentBlue
        case .graphite: return Color(hex: "#3A3D40")
        }
    }

    public var hover: Color {
        switch self {
        case .green: return DesignTokens.Palette.accentGreenHover
        case .red: return Color(hex: "#E86A5E")
        case .blue: return Color(hex: "#5B93D6")
        case .graphite: return Color(hex: "#5C6065")
        }
    }
}

/// Aktivní téma aplikace. Uživatelsky konfigurovatelné přes nastavení.
@Observable
public final class Theme {
    public var accent: AccentPreset = .green
    public var customAccentHex: String?
    public var darkAppearance: Bool = true

    public init() {}

    /// Aktivní základní akcent (vlastní hex má přednost před předvolbou).
    public var accentBase: Color {
        if let hex = customAccentHex, !hex.isEmpty { return Color(hex: hex) }
        return accent.base
    }

    public var accentHover: Color { accent.hover }
}
