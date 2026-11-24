import Foundation

/// Centrální registr stránek. Pořadí registrací určuje pořadí v docku.
public final class PageRegistry: @unchecked Sendable {
    public static let shared = PageRegistry()

    private let lock = NSLock()
    private var storage: [String: any PageModule.Type] = [:]
    private var order: [String] = []

    public init() {}

    public func register(_ page: any PageModule.Type) {
        lock.lock()
        defer { lock.unlock() }
        if storage[page.id] == nil { order.append(page.id) }
        storage[page.id] = page
    }

    public func registerAll(_ pages: [any PageModule.Type]) {
        for page in pages { register(page) }
    }

    public func page(id: String) -> (any PageModule.Type)? {
        lock.lock()
        defer { lock.unlock() }
        return storage[id]
    }

    /// Stránky viditelné v daném kontextu, v pořadí docku.
    public func pages(visibleIn context: PageContext) -> [any PageModule.Type] {
        lock.lock()
        defer { lock.unlock() }
        return order.compactMap { storage[$0] }.filter { $0.isVisible(in: context) }
    }

    public var all: [any PageModule.Type] {
        lock.lock()
        defer { lock.unlock() }
        return order.compactMap { storage[$0] }
    }

    /// Mapa klávesa -> id stránky pro všechny registrované stránky.
    public func shortcutMap() -> [String: String] {
        var map: [String: String] = [:]
        for page in all {
            for key in page.shortcutKeys { map[key.lowercased()] = page.id }
        }
        return map
    }

    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAll()
        order.removeAll()
    }
}
