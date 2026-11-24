import Foundation
import Observation
import SwiftUI

/// Předvolba akcentu rozhraní podle prototypu: moderní šedá (výchozí) nebo čistá bílá.
/// Monochromní UI – barevné jsou výhradně balanční kola (ADR 0006). Vlastní hex zůstává možný (spec 8.1).
public enum AccentPreset: String, Codable, Sendable, CaseIterable, Identifiable {
    case seda
    case bila

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .seda: return "Moderní šedá"
        case .bila: return "Čistá bílá"
        }
    }

    public var base: Color {
        switch self {
        case .seda: return Color(hex: "#C9CED4")
        case .bila: return Color(hex: "#FFFFFF")
        }
    }

    public var hover: Color { base }

    public var onAccent: Color { DesignTokens.Palette.onAccent }
}

/// Aktivní téma aplikace. Uživatelsky konfigurovatelné přes nastavení.
@Observable
public final class Theme {
    /// Sdílené téma aplikace (jedno okno; stránky k němu přistupují přes Theme.shared).
    public static let shared = Theme()

    public var accent: AccentPreset = .seda
    public var customAccentHex: String?
    public var darkAppearance: Bool = true

    public init() {}

    /// Aktivní akcent (vlastní hex má přednost před předvolbou).
    public var accentBase: Color {
        if let hex = customAccentHex, !hex.isEmpty { return Color(hex: hex) }
        return accent.base
    }

    public var accentHover: Color { accent.hover }

    public var onAccent: Color { accent.onAccent }
}
