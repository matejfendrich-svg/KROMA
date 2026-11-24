import Foundation
import Observation
import SwiftUI

/// Předvolby dominantní barvy aplikace (nastavení, sekce Pracovní prostředí).
/// Výchozí je mono (bílý akcent na černé) podle designu FR_APP – viz ADR 0005.
public enum AccentPreset: String, Codable, Sendable, CaseIterable, Identifiable {
    case mono
    case green
    case red
    case blue
    case graphite

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .mono: return "Mono"
        case .green: return "Zelená"
        case .red: return "Červená"
        case .blue: return "Modrá"
        case .graphite: return "Grafitová"
        }
    }

    public var base: Color {
        switch self {
        case .mono: return DesignTokens.Palette.accent
        case .green: return Color(hex: "#185238")
        case .red: return Color(hex: "#D9483B")
        case .blue: return Color(hex: "#2F6FB5")
        case .graphite: return Color(hex: "#3A3D40")
        }
    }

    public var hover: Color {
        switch self {
        case .mono: return DesignTokens.Palette.accent
        case .green: return Color(hex: "#2AA06B")
        case .red: return Color(hex: "#E86A5E")
        case .blue: return Color(hex: "#5B93D6")
        case .graphite: return Color(hex: "#5C6065")
        }
    }

    public var onAccent: Color {
        switch self {
        case .mono: return DesignTokens.Palette.onAccent
        default: return DesignTokens.Palette.textPrimary
        }
    }
}

/// Aktivní téma aplikace. Uživatelsky konfigurovatelné přes nastavení.
@Observable
public final class Theme {
    public var accent: AccentPreset = .mono
    public var customAccentHex: String?
    public var darkAppearance: Bool = true

    public init() {}

    /// Aktivní základní akcent (vlastní hex má přednost před předvolbou).
    public var accentBase: Color {
        if let hex = customAccentHex, !hex.isEmpty { return Color(hex: hex) }
        return accent.base
    }

    public var accentHover: Color { accent.hover }

    public var onAccent: Color { accent.onAccent }
}
