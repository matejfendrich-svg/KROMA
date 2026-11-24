import Foundation
import Testing
import KromaRegistry

struct StubEffect: EffectDefinition {
    static let id = "test.stub"
    static let version = 1
    static let name = "Stub"
    static let category: EffectCategory = .fx
    static let kernelName = "stub"
    static let costPerPixel = 1.0
    static let parameterSchema = ParameterSchema(parameters: [
        ParameterDefinition(id: "amount", name: "Amount", kind: .double, defaultValue: .double(0.5), minimum: 0, maximum: 1, step: 0.01),
    ])
}

struct OtherStubEffect: EffectDefinition {
    static let id = "test.other"
    static let version = 1
    static let name = "Other"
    static let category: EffectCategory = .basic
    static let kernelName = "other"
    static let costPerPixel = 2.0
    static let parameterSchema = ParameterSchema(parameters: [])
}

@Test func registerAndLookup() {
    let registry = EffectRegistry()
    registry.register(StubEffect.self)
    #expect(registry.effect(id: "test.stub") != nil)
    #expect(registry.effect(id: "missing") == nil)
    #expect(registry.all.count == 1)
}

@Test func registerAllKeepsSortedOrder() {
    let registry = EffectRegistry()
    registry.registerAll([StubEffect.self, OtherStubEffect.self])
    #expect(registry.all.map { $0.id } == ["test.other", "test.stub"])
}

@Test func reregisterReplaces() {
    let registry = EffectRegistry()
    registry.register(StubEffect.self)
    registry.register(StubEffect.self)
    #expect(registry.all.count == 1)
}

@Test func schemaDefaultValues() {
    let values = StubEffect.parameterSchema.defaultValues()
    #expect(values["amount"] == .double(0.5))
    #expect(StubEffect.parameterSchema.parameter(id: "amount")?.step == 0.01)
    #expect(StubEffect.parameterSchema.parameter(id: "missing") == nil)
}
