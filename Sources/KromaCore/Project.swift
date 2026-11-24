import Foundation
import KromaRegistry

/// Verze schématu projektových souborů. Při změně schématu se přidá migrace v ProjectStore.
public enum KromaSchema {
    public static let currentVersion = 1
}

public enum ProjectStoreError: Error, LocalizedError, Sendable {
    case packageNotFound(URL)
    case unsupportedSchemaVersion(Int)
    case missingFile(String)

    public var errorDescription: String? {
        switch self {
        case .packageNotFound(let url): return "Balíček projektu nenalezen: \(url.path)"
        case .unsupportedSchemaVersion(let version): return "Nepodporovaná verze schématu projektu: \(version)"
        case .missingFile(let name): return "V balíčku chybí soubor \(name)"
        }
    }
}

/// Graf jednoho média uvnitř graph.json.
public struct MediaGraph: Codable, Hashable, Sendable {
    public var mediaID: UUID
    public var graph: NodeGraph

    public init(mediaID: UUID, graph: NodeGraph) {
        self.mediaID = mediaID
        self.graph = graph
    }
}

/// project.json – obálka projektu s verzí schématu a seznamem médií.
public struct ProjectEnvelope: Codable, Sendable {
    public var schemaVersion: Int
    public var name: String
    public var mode: WorkMode
    public var createdAt: Date
    public var media: [MediaItem]

    public init(schemaVersion: Int = KromaSchema.currentVersion, name: String, mode: WorkMode = .gallery, createdAt: Date = Date(), media: [MediaItem] = []) {
        self.schemaVersion = schemaVersion
        self.name = name
        self.mode = mode
        self.createdAt = createdAt
        self.media = media
    }
}

/// graph.json – node grafy všech médií.
public struct GraphFile: Codable, Sendable {
    public var schemaVersion: Int
    public var graphs: [MediaGraph]

    public init(schemaVersion: Int = KromaSchema.currentVersion, graphs: [MediaGraph] = []) {
        self.schemaVersion = schemaVersion
        self.graphs = graphs
    }
}

/// Projekt v paměti: obálka + grafy. Na disku leží jako balíček .kroma.
public struct Project: Sendable {
    public var envelope: ProjectEnvelope
    public var graphFile: GraphFile

    public init(envelope: ProjectEnvelope, graphFile: GraphFile) {
        self.envelope = envelope
        self.graphFile = graphFile
    }

    public var name: String {
        get { envelope.name }
        set { envelope.name = newValue }
    }

    public var mode: WorkMode {
        get { envelope.mode }
        set { envelope.mode = newValue }
    }

    public var media: [MediaItem] {
        get { envelope.media }
        set { envelope.media = newValue }
    }

    public func graph(for mediaID: UUID) -> NodeGraph {
        graphFile.graphs.first { $0.mediaID == mediaID }?.graph ?? NodeGraph()
    }

    public mutating func setGraph(_ graph: NodeGraph, for mediaID: UUID) {
        if let index = graphFile.graphs.firstIndex(where: { $0.mediaID == mediaID }) {
            graphFile.graphs[index].graph = graph
        } else {
            graphFile.graphs.append(MediaGraph(mediaID: mediaID, graph: graph))
        }
    }
}
