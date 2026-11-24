import Foundation
import CoreGraphics
import KromaCore
import KromaRegistry

public enum RenderPriority: String, Sendable {
    case interactive
    case background
    case export
}

/// Požadavek na render jednoho média přes node graf.
public struct RenderRequest: Sendable {
    public var sourceURL: URL
    public var graph: NodeGraph
    public var viewportSize: CGSize
    /// Adaptivní měřítko náhledu (1 = plné rozlišení panelu, 0.5 při interakci).
    public var scale: Double
    public var priority: RenderPriority

    public init(sourceURL: URL, graph: NodeGraph, viewportSize: CGSize, scale: Double = 1, priority: RenderPriority = .interactive) {
        self.sourceURL = sourceURL
        self.graph = graph
        self.viewportSize = viewportSize
        self.scale = scale
        self.priority = priority
    }
}

/// Výsledek renderu.
public struct RenderResult: @unchecked Sendable {
    public let image: CGImage
    public let cacheKey: String
    public let renderedAt: Date

    public init(image: CGImage, cacheKey: String, renderedAt: Date = Date()) {
        self.image = image
        self.cacheKey = cacheKey
        self.renderedAt = renderedAt
    }
}

/// Jedna fáze renderu odvozená z uzlu grafu.
public struct RenderStage: Identifiable, Sendable {
    public let id: UUID
    public let effectID: String
    public let kernelName: String
    public let parameters: [String: ParameterValue]

    public init(id: UUID, effectID: String, kernelName: String, parameters: [String: ParameterValue]) {
        self.id = id
        self.effectID = effectID
        self.kernelName = kernelName
        self.parameters = parameters
    }
}
