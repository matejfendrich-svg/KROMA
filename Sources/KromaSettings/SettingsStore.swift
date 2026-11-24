import Foundation
import Observation

/// Perzistence uživatelských nastavení do Application Support/Kroma/settings.json.
@MainActor
@Observable
public final class SettingsStore {
    public var settings = AppSettings()

    private let fileURL: URL

    public init() {
        let directory = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("Kroma", isDirectory: true)
        if let directory {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            fileURL = directory.appendingPathComponent("settings.json")
        } else {
            fileURL = URL(fileURLWithPath: "/tmp/kroma-settings.json")
        }
        load()
    }

    public func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) else { return }
        settings = decoded
    }

    public func save() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try? encoder.encode(settings).write(to: fileURL, options: .atomic)
    }

    /// Změna nastavení se uloží okamžitě, bez tlačítka potvrdit.
    public func update(_ change: (inout AppSettings) -> Void) {
        change(&settings)
        save()
    }
}
