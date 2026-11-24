import Foundation
import KromaRegistry
import KromaUI

/// Sekce okna nastavení (kapitola 8.1). Každé budoucí nastavení patří sem.
public enum SettingsSection: String, Codable, Sendable, CaseIterable, Identifiable {
    case workspace = "Pracovní prostředí"
    case performance = "Výkon a systém"
    case project = "Projekt a knihovna"
    case export = "Export"
    case shortcuts = "Klávesové zkratky"
    case advanced = "Rozšířené"

    public var id: String { rawValue }
}

public enum EkoMode: String, Codable, Sendable, CaseIterable, Identifiable {
    case never
    case onBattery
    case always

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .never: return "Nikdy"
        case .onBattery: return "Jen na baterii"
        case .always: return "Vždy"
        }
    }
}

/// Uživatelská nastavení aplikace, ukládaná průběžně a platná okamžitě.
public struct AppSettings: Codable, Sendable {
    public var defaultWorkMode: WorkMode = .gallery
    public var accent: AccentPreset = .seda
    public var customAccentHex: String?
    public var uiScale: Int = 100
    public var compactControls: Bool = false
    public var showTimelineFilmstrip: Bool = true
    public var ekoMode: EkoMode = .onBattery
    public var performanceLevel: Int?
    public var previewResolution: String = "Auto (fit panelu)"
    public var interactionQuality: String = "Střední"
    public var thermalThreshold: String = "serious"
    public var cacheSizeGB: Int = 20
    public var generateProxy: Bool = true
    public var copyOriginalsIntoLibrary: Bool = false
    public var writeXMPSidecar: Bool = true
    public var exportQueueCount: Int = 2
    public var language: String = "Čeština"
    public var updateChannel: String = "Stabilní"

    public init() {}
}
