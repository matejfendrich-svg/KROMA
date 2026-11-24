import Foundation

/// Barevný štítek pro culling (klávesy 6–9) a štítky klipů v režimu Resolve.
public enum ColorLabel: String, Codable, Sendable, CaseIterable, Identifiable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case gray

    public var id: String { rawValue }

    /// První čtyři štítky mají klávesy 6 až 9.
    public var shortcutKey: String? {
        switch self {
        case .red: return "6"
        case .yellow: return "7"
        case .green: return "8"
        case .blue: return "9"
        default: return nil
        }
    }
}
