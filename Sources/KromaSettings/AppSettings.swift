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

public enum EkoMode: String, Codable, Sendable, CaseIterable {
    case never
    case onBattery
    case always
}

/// Uživatelská nastavení aplikace, ukládaná průběžně a platná okamžitě.
public struct AppSettings: Codable, Sendable {
    public var defaultWorkMode: WorkMode = .gallery
    public var accent: AccentPreset = .mono
    public var customAccentHex: String?
    public var compactControls: Bool = false
    public var showTimelineFilmstrip: Bool = true
    public var ekoMode: EkoMode = .never
    public var performanceLevel: Int?
    public var copyOriginalsIntoLibrary: Bool = false
    public var writeXMPSidecar: Bool = false

    public init() {}
}
