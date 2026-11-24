import Foundation
import KromaCore
import KromaRegistry

/// Sestavuje renderovací fáze z node grafu. Jediný render DAG aplikace:
/// stránky Obraz, Color i FX jsou jen pohledy na tentýž graf.
public enum RenderDAG {
    public static func makeStages(for graph: NodeGraph, registry: EffectRegistry = .shared) -> [RenderStage] {
        graph.nodes
            .filter(\.enabled)
            .compactMap { node in
                guard let effect = registry.effect(id: node.type) else { return nil }
                return RenderStage(
                    id: node.id,
                    effectID: node.type,
                    kernelName: effect.kernelName,
                    parameters: node.parameters
                )
            }
    }

    /// Celkový odhad náročnosti grafu (operace na pixel), podle kterého plánovač volí strategii.
    public static func estimatedCost(for graph: NodeGraph, registry: EffectRegistry = .shared) -> Double {
        graph.nodes
            .filter(\.enabled)
            .compactMap { registry.effect(id: $0.type) }
            .reduce(0) { $0 + $1.costPerPixel }
    }
}
