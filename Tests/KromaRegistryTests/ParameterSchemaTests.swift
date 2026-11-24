import Foundation
import Testing
import KromaRegistry

@Test func parameterValueRoundtrip() throws {
    let values: [ParameterValue] = [
        .double(1.5),
        .int(3),
        .bool(true),
        .string("hello"),
        .color(RGBA(r: 1, g: 0.5, b: 0, a: 1)),
        .array([.double(1), .string("x")]),
    ]
    let data = try JSONEncoder().encode(values)
    let decoded = try JSONDecoder().decode([ParameterValue].self, from: data)
    #expect(decoded == values)
}

@Test func parameterSchemaRoundtrip() throws {
    let schema = ParameterSchema(parameters: [
        ParameterDefinition(id: "ev", name: "EV", kind: .double, defaultValue: .double(0), minimum: -5, maximum: 5, step: 0.01, unit: "EV"),
        ParameterDefinition(id: "mode", name: "Režim", kind: .choice, defaultValue: .string("a"), choices: ["a", "b"]),
    ])
    let data = try JSONEncoder().encode(schema)
    let decoded = try JSONDecoder().decode(ParameterSchema.self, from: data)
    #expect(decoded == schema)
}
