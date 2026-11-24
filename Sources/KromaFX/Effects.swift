import KromaRegistry

public enum KromaFX {
    /// Registruje všechny vestavěné efekty. Volá se při startu aplikace.
    public static func registerDefaultEffects(into registry: EffectRegistry = .shared) {
        registry.registerAll([
            ExposureEffect.self,
        ])
    }
}
