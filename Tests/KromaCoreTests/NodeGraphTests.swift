import Foundation
import Testing
import KromaCore
import KromaRegistry

@Test func cacheKeyIsStableForIdenticalGraphs() {
    let node = GraphNode(type: "basic.exposure", parameters: ["ev": .double(1)])
    let first = NodeGraph(nodes: [node])
    let second = NodeGraph(nodes: [GraphNode(id: node.id, type: node.type, parameters: node.parameters)])
    #expect(first.cacheKey == second.cacheKey)
    #expect(first.cacheKey.count == 64)
}

@Test func cacheKeyChangesWithParametersAndEnabledState() {
    let base = NodeGraph(nodes: [GraphNode(type: "basic.exposure", parameters: ["ev": .double(1)])])

    var changedParam = base
    changedParam.nodes[0].parameters["ev"] = .double(2)
    #expect(changedParam.cacheKey != base.cacheKey)

    var disabled = base
    disabled.nodes[0].enabled = false
    #expect(disabled.cacheKey != base.cacheKey)
}

@Test func graphCodableRoundtripPreservesCacheKey() throws {
    let graph = NodeGraph(nodes: [
        GraphNode(type: "basic.exposure", parameters: ["ev": .double(-2.5), "on": .bool(true)]),
        GraphNode(type: "fx.halftone", version: 2, enabled: false, parameters: ["dot": .double(4)]),
    ])
    let data = try JSONEncoder().encode(graph)
    let decoded = try JSONDecoder().decode(NodeGraph.self, from: data)
    #expect(decoded == graph)
    #expect(decoded.cacheKey == graph.cacheKey)
}

@Test func colorLabelShortcuts() {
    #expect(ColorLabel.red.shortcutKey == "6")
    #expect(ColorLabel.yellow.shortcutKey == "7")
    #expect(ColorLabel.green.shortcutKey == "8")
    #expect(ColorLabel.blue.shortcutKey == "9")
    #expect(ColorLabel.purple.shortcutKey == nil)
}

@Test func mediaItemRatingIsClamped() {
    let item = MediaItem(url: URL(fileURLWithPath: "/tmp/a.jpg"), kind: .photo, rating: 9)
    #expect(item.rating == 5)
}
