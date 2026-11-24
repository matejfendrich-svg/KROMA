import Foundation
import Testing
import KromaCore

@Test @MainActor func saveAndOpenRoundtrip() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: dir) }

    let store = ProjectStore()
    try store.newProject(name: "Test", at: dir, mode: .resolve)

    let media = MediaItem(url: URL(fileURLWithPath: "/tmp/a.cr3"), kind: .photo, rating: 4, label: .green)
    store.update { project in
        project.media.append(media)
        project.setGraph(
            NodeGraph(nodes: [GraphNode(type: "basic.exposure", parameters: ["ev": .double(1.5)])]),
            for: media.id
        )
    }
    try store.saveNow()

    let reopened = ProjectStore()
    try reopened.open(at: dir.appendingPathComponent("Test.kroma"))

    let project = try #require(reopened.project)
    #expect(project.name == "Test")
    #expect(project.mode == .resolve)
    #expect(project.envelope.schemaVersion == KromaSchema.currentVersion)
    let loadedMedia = try #require(project.media.first)
    #expect(loadedMedia.id == media.id)
    #expect(loadedMedia.rating == 4)
    #expect(loadedMedia.label == .green)
    let graph = project.graph(for: media.id)
    #expect(graph.nodes.count == 1)
    #expect(graph.nodes.first?.parameters["ev"] == .double(1.5))
}

@Test @MainActor func rejectsNewerSchemaVersion() throws {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: dir) }
    let package = dir.appendingPathComponent("New.kroma", isDirectory: true)
    try FileManager.default.createDirectory(at: package, withIntermediateDirectories: true)

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    try encoder.encode(ProjectEnvelope(schemaVersion: KromaSchema.currentVersion + 1, name: "New"))
        .write(to: package.appendingPathComponent("project.json"))
    try encoder.encode(GraphFile())
        .write(to: package.appendingPathComponent("graph.json"))

    let store = ProjectStore()
    #expect(throws: ProjectStoreError.self) {
        try store.open(at: package)
    }
}

@Test @MainActor func missingPackageThrows() {
    let store = ProjectStore()
    let missing = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".kroma", isDirectory: true)
    #expect(throws: ProjectStoreError.self) {
        try store.open(at: missing)
    }
}
