import Foundation

public enum MediaKind: String, Codable, Sendable {
    case photo
    case video
    case audio
}

/// Jedno médium v projektu. Projekt odkazuje na původní cestu, data se nekopírují
/// (pokud není zapnuto kopírování do spravované knihovny).
public struct MediaItem: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var url: URL
    public var kind: MediaKind
    /// Hodnocení 0 (nehlasováno) až 5 hvězd.
    public var rating: Int
    public var label: ColorLabel?
    public var rejected: Bool
    public var addedAt: Date

    public init(
        id: UUID = UUID(),
        url: URL,
        kind: MediaKind,
        rating: Int = 0,
        label: ColorLabel? = nil,
        rejected: Bool = false,
        addedAt: Date = Date()
    ) {
        self.id = id
        self.url = url
        self.kind = kind
        self.rating = min(max(rating, 0), 5)
        self.label = label
        self.rejected = rejected
        self.addedAt = addedAt
    }
}
