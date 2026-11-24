import KromaRegistry

/// Základní korekce expozice (stránka Obraz). Ukázka vzoru: nový efekt
/// je jen tento soubor + kernel v KromaEngine/Kernels + test.
public struct ExposureEffect: EffectDefinition {
    public static let id = "basic.exposure"
    public static let version = 1
    public static let name = "Expozice"
    public static let category: EffectCategory = .basic
    public static let kernelName = "exposure"
    public static let costPerPixel = 4.0

    public static let parameterSchema = ParameterSchema(parameters: [
        ParameterDefinition(
            id: "ev",
            name: "EV",
            kind: .double,
            defaultValue: .double(0),
            minimum: -5,
            maximum: 5,
            step: 0.01,
            unit: "EV"
        ),
    ])

    public init() {}
}
