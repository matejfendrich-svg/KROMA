/// Kategorie efektu podle stránky, na které se typicky objevuje.
public enum EffectCategory: String, Codable, Sendable, CaseIterable {
    case basic
    case color
    case fx
    case depth
}

/// Definice efektu. Každý efekt je jedna struktura v KromaFX implementující tento protokol.
/// Schéma parametrů je jediný zdroj inspektoru UI i serializace grafu.
public protocol EffectDefinition: Sendable {
    static var id: String { get }
    static var version: Int { get }
    static var name: String { get }
    static var category: EffectCategory { get }
    static var parameterSchema: ParameterSchema { get }
    /// Název Metal kernelu v KromaEngine/Kernels.
    static var kernelName: String { get }
    /// Odhad operací na pixel, podle kterého plánovač volí strategii renderu.
    static var costPerPixel: Double { get }
}
