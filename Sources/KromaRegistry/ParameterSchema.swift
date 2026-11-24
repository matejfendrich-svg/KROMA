import Foundation

/// Hodnota jednoho parametru uzlu. Jediný zdroj serializace i inspektoru UI.
public enum ParameterValue: Codable, Hashable, Sendable {
    case double(Double)
    case int(Int)
    case bool(Bool)
    case string(String)
    case color(RGBA)
    case array([ParameterValue])
}

public struct RGBA: Codable, Hashable, Sendable {
    public var r: Double
    public var g: Double
    public var b: Double
    public var a: Double

    public init(r: Double, g: Double, b: Double, a: Double = 1) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

public enum ParameterKind: String, Codable, Sendable, CaseIterable {
    case double
    case int
    case bool
    case string
    case color
    case choice
    case array
}

/// Definice jednoho parametru efektu: typ, rozsah, výchozí hodnota, volby.
public struct ParameterDefinition: Codable, Hashable, Sendable, Identifiable {
    public let id: String
    public let name: String
    public let kind: ParameterKind
    public let defaultValue: ParameterValue
    public let minimum: Double?
    public let maximum: Double?
    public let step: Double?
    public let unit: String?
    public let choices: [String]?

    public init(
        id: String,
        name: String,
        kind: ParameterKind,
        defaultValue: ParameterValue,
        minimum: Double? = nil,
        maximum: Double? = nil,
        step: Double? = nil,
        unit: String? = nil,
        choices: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.defaultValue = defaultValue
        self.minimum = minimum
        self.maximum = maximum
        self.step = step
        self.unit = unit
        self.choices = choices
    }
}

/// Kompletní schéma parametrů jednoho efektu.
public struct ParameterSchema: Codable, Hashable, Sendable {
    public var parameters: [ParameterDefinition]

    public init(parameters: [ParameterDefinition]) {
        self.parameters = parameters
    }

    public func parameter(id: String) -> ParameterDefinition? {
        parameters.first { $0.id == id }
    }

    /// Výchozí hodnoty všech parametrů jako slovník (výchozí stav nového uzlu).
    public func defaultValues() -> [String: ParameterValue] {
        Dictionary(uniqueKeysWithValues: parameters.map { ($0.id, $0.defaultValue) })
    }
}
