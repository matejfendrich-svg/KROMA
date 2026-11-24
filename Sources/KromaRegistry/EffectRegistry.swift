import Foundation

/// Centrální registr efektů. Efekt se přidá registrací jednoho typu,
/// žádný jiný kód se nemusí měnit.
public final class EffectRegistry: @unchecked Sendable {
    public static let shared = EffectRegistry()

    private let lock = NSLock()
    private var storage: [String: any EffectDefinition.Type] = [:]

    public init() {}

    public func register(_ effect: any EffectDefinition.Type) {
        lock.lock()
        defer { lock.unlock() }
        storage[effect.id] = effect
    }

    public func registerAll(_ effects: [any EffectDefinition.Type]) {
        for effect in effects { register(effect) }
    }

    public func effect(id: String) -> (any EffectDefinition.Type)? {
        lock.lock()
        defer { lock.unlock() }
        return storage[id]
    }

    public var all: [any EffectDefinition.Type] {
        lock.lock()
        defer { lock.unlock() }
        return storage.values.sorted { $0.id < $1.id }
    }

    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAll()
    }
}
