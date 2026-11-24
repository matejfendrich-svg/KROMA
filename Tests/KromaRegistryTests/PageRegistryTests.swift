import SwiftUI
import Testing
import KromaRegistry

struct StubPage: PageModule {
    static let id = "stub"
    static let title = "Stub"
    static let icon = "circle"
    static let shortcutKeys = ["9"]
    static func isVisible(in context: PageContext) -> Bool { true }
    static func makeView(host: any PageHost) -> AnyView { AnyView(Text("stub")) }
}

struct StubEditPage: PageModule {
    static let id = "stub-edit"
    static let title = "Stub Edit"
    static let icon = "timeline.selection"
    static let shortcutKeys = ["8"]
    static func isVisible(in context: PageContext) -> Bool {
        context.hasVideo || context.hasSequence || context.mode == .resolve
    }
    static func makeView(host: any PageHost) -> AnyView { AnyView(Text("edit")) }
}

@Test func registrationOrderIsDockOrder() {
    let registry = PageRegistry()
    registry.registerAll([StubPage.self, StubEditPage.self])
    #expect(registry.all.map { $0.id } == ["stub", "stub-edit"])
}

@Test func contextualVisibility() {
    let registry = PageRegistry()
    registry.registerAll([StubPage.self, StubEditPage.self])

    let gallery = PageContext(hasVideo: false, hasSequence: false, mode: .gallery)
    #expect(registry.pages(visibleIn: gallery).map { $0.id } == ["stub"])

    let video = PageContext(hasVideo: true, mode: .gallery)
    #expect(registry.pages(visibleIn: video).map { $0.id } == ["stub", "stub-edit"])

    let sequence = PageContext(hasSequence: true, mode: .gallery)
    #expect(registry.pages(visibleIn: sequence).map { $0.id } == ["stub", "stub-edit"])

    let resolve = PageContext(mode: .resolve)
    #expect(registry.pages(visibleIn: resolve).map { $0.id } == ["stub", "stub-edit"])
}

@Test func shortcutMapCoversAllKeys() {
    let registry = PageRegistry()
    registry.registerAll([StubPage.self, StubEditPage.self])
    let map = registry.shortcutMap()
    #expect(map["9"] == "stub")
    #expect(map["8"] == "stub-edit")
}
