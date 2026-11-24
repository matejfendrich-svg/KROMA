import Foundation
import Observation
import KromaRegistry

/// Načítá a ukládá projektový balíček .kroma (project.json + graph.json + cache/).
/// Automatické ukládání s odstupem 1 s; verzování řeší macOS Versions.
@MainActor
@Observable
public final class ProjectStore {
    public private(set) var project: Project?
    public private(set) var packageURL: URL?

    private var autosaveItem: DispatchWorkItem?

    public init() {}

    /// Vytvoří nový prázdný balíček projektu na disku.
    public func newProject(name: String, at directory: URL, mode: WorkMode = .gallery) throws {
        let package = directory.appendingPathComponent(name + ".kroma", isDirectory: true)
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: package, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: package.appendingPathComponent("cache", isDirectory: true), withIntermediateDirectories: true)
        project = Project(
            envelope: ProjectEnvelope(name: name, mode: mode),
            graphFile: GraphFile()
        )
        packageURL = package
        try saveNow()
    }

    /// Otevře existující balíček .kroma.
    public func open(at package: URL) throws {
        let envelope = try Self.decode(ProjectEnvelope.self, from: package.appendingPathComponent("project.json"))
        let graphFile = try Self.decode(GraphFile.self, from: package.appendingPathComponent("graph.json"))
        guard envelope.schemaVersion <= KromaSchema.currentVersion else {
            throw ProjectStoreError.unsupportedSchemaVersion(envelope.schemaVersion)
        }
        guard graphFile.schemaVersion <= KromaSchema.currentVersion else {
            throw ProjectStoreError.unsupportedSchemaVersion(graphFile.schemaVersion)
        }
        project = Project(envelope: envelope, graphFile: graphFile)
        packageURL = package
    }

    /// Aplikuje změnu na projekt a naplánuje autosave (debounce 1 s).
    public func update(_ change: (inout Project) -> Void) {
        guard var current = project else { return }
        change(&current)
        project = current
        scheduleAutosave()
    }

    public func scheduleAutosave() {
        autosaveItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            Task { @MainActor in
                try? self?.saveNow()
            }
        }
        autosaveItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
    }

    /// Okamžité uložení obálky a grafů do balíčku.
    public func saveNow() throws {
        guard let project, let packageURL else { return }
        try Self.encode(project.envelope, to: packageURL.appendingPathComponent("project.json"))
        try Self.encode(project.graphFile, to: packageURL.appendingPathComponent("graph.json"))
    }

    private static func encode<T: Encodable>(_ value: T, to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        try encoder.encode(value).write(to: url, options: .atomic)
    }

    private static func decode<T: Decodable>(_ type: T.Type, from url: URL) throws -> T {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ProjectStoreError.missingFile(url.lastPathComponent)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: Data(contentsOf: url))
    }
}
