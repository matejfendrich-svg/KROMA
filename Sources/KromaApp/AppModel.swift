import Foundation
import Observation
import ColorPage
import EditPage
import ExportPage
import FXPage
import ImportPage
import KromaCore
import KromaFX
import KromaRegistry
import KromaSettings
import KromaUI
import ObrazPage
import SwiftUI

/// Viditelný stav termální ochrany v hlavičce (kapitola 7.3 a 8.2).
public enum ThermalIndicator: Sendable {
    case nominal
    case fair
    case serious
    case critical

    public init(_ state: ProcessInfo.ThermalState) {
        switch state {
        case .nominal: self = .nominal
        case .fair: self = .fair
        case .serious: self = .serious
        case .critical: self = .critical
        @unknown default: self = .nominal
        }
    }

    public var color: Color {
        switch self {
        case .nominal, .fair: return DesignTokens.Palette.accentGreenHover
        case .serious: return .orange
        case .critical: return DesignTokens.Palette.accentRed
        }
    }

    public var label: String {
        switch self {
        case .nominal: return "Teplota: v pořádku"
        case .fair: return "Teplota: mírně zvýšená"
        case .serious: return "Teplota: termální reakce aktivní"
        case .critical: return "Teplota: kritická, Eko režim"
        }
    }
}

/// Hlavní model aplikace: projekt, aktuální stránka, viditelnost panelů, nastavení.
@Observable
@MainActor
public final class AppModel: PageHost {
    /// Sdílená instance aplikace (bez @State, aby build fungoval i jen s Command Line Tools).
    public static let shared = AppModel()

    public let theme = Theme()
    public let settings = SettingsStore()
    public let projectStore = ProjectStore()

    public var selectedPageID: String = "import"
    public var showMediaPanel: Bool = true
    public var showInspector: Bool = true
    public var showSettings: Bool = false
    public var thermalState: ThermalIndicator = .nominal

    public init() {
        KromaFX.registerDefaultEffects()
        PageRegistry.shared.registerAll([
            ImportPage.self,
            ObrazPage.self,
            ColorPage.self,
            FXPage.self,
            EditPage.self,
            ExportPage.self,
        ])
        if let first = visiblePages().first { selectedPageID = first.id }
        startThermalMonitoring()
    }

    public var pageContext: PageContext {
        let media = projectStore.project?.media ?? []
        let mode = projectStore.project?.mode ?? .gallery
        return PageContext(
            hasVideo: media.contains { $0.kind == .video },
            hasSequence: false,
            mode: mode
        )
    }

    public func visiblePages() -> [any PageModule.Type] {
        PageRegistry.shared.pages(visibleIn: pageContext)
    }

    public func selectPage(_ id: String) {
        guard visiblePages().contains(where: { $0.id == id }) else { return }
        selectedPageID = id
    }

    /// Přepnutí stránky podle klávesy (1–7, E). Vrací true, pokud klávesa něco udělala.
    public func handleShortcut(_ key: String) -> Bool {
        let normalized = key.lowercased()
        let match = visiblePages().first { $0.shortcutKeys.contains(normalized) }
        guard let match else { return false }
        selectedPageID = match.id
        return true
    }

    private func startThermalMonitoring() {
        Task { [weak self] in
            while !Task.isCancelled {
                let state = ProcessInfo.processInfo.thermalState
                await MainActor.run { self?.thermalState = ThermalIndicator(state) }
                try? await Task.sleep(for: .seconds(2))
            }
        }
    }
}
