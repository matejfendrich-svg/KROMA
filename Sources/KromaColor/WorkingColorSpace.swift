import Foundation

/// Pracovní barevný prostor projektu (kapitola 6 a 8). Výchozí Display P3.
public enum WorkingColorSpace: String, Codable, Sendable, CaseIterable, Identifiable {
    case displayP3
    case sRGB
    case adobeRGB
    /// Interní lineární scénově referovaný prostor (half float na GPU).
    case linear

    public var id: String { rawValue }

    public static let `default`: WorkingColorSpace = .displayP3
}

/// ICC profil pro tisk nebo vlastní export.
public struct ICCProfile: Identifiable, Codable, Sendable {
    public let id: UUID
    public var name: String
    public var url: URL?

    public init(id: UUID = UUID(), name: String, url: URL? = nil) {
        self.id = id
        self.name = name
        self.url = url
    }
}

/// Soft proofing pro tisk: výběr profilu tiskárny a simulace papíru.
public struct SoftProofing: Codable, Sendable {
    public var enabled: Bool
    public var profileName: String?
    public var simulatePaperWhite: Bool
    public var blackPointCompensation: Bool

    public init(enabled: Bool = false, profileName: String? = nil, simulatePaperWhite: Bool = true, blackPointCompensation: Bool = true) {
        self.enabled = enabled
        self.profileName = profileName
        self.simulatePaperWhite = simulatePaperWhite
        self.blackPointCompensation = blackPointCompensation
    }
}
