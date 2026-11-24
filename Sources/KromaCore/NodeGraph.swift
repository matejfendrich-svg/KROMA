import CryptoKit
import Foundation
import KromaRegistry

/// Maska výběru připojená k uzlu (qualifier, hloubka, tvar...).
public struct MaskDefinition: Codable, Hashable, Sendable {
    public var kind: String
    public var parameters: [String: ParameterValue]

    public init(kind: String, parameters: [String: ParameterValue] = [:]) {
        self.kind = kind
        self.parameters = parameters
    }
}

/// Jeden uzel editačního grafu: nese typ efektu, verzi a serializovatelné parametry.
public struct GraphNode: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var type: String
    public var version: Int
    public var enabled: Bool
    public var parameters: [String: ParameterValue]
    public var mask: MaskDefinition?

    public init(
        id: UUID = UUID(),
        type: String,
        version: Int = 1,
        enabled: Bool = true,
        parameters: [String: ParameterValue] = [:],
        mask: MaskDefinition? = nil
    ) {
        self.id = id
        self.type = type
        self.version = version
        self.enabled = enabled
        self.parameters = parameters
        self.mask = mask
    }
}

/// Uspořádaný lineární řetěz uzlů jednoho média. Sdílí ho stránky Obraz, Color i FX.
public struct NodeGraph: Codable, Hashable, Sendable {
    public var nodes: [GraphNode]

    public init(nodes: [GraphNode] = []) {
        self.nodes = nodes
    }

    /// Stabilní hash grafu – klíč cache renderovaných náhledů.
    /// Nezměněný graf dává stejný klíč, změna libovolného parametru klíč změní.
    public var cacheKey: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = (try? encoder.encode(self)) ?? Data()
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
