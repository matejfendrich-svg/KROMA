import SwiftUI

/// Pracovní režim projektu: galerijní editor, nebo režim Resolve (timeline-first).
public enum WorkMode: String, Codable, Sendable {
    case gallery
    case resolve
}

/// Kontext, podle kterého se rozhoduje viditelnost stránek v docku.
public struct PageContext: Sendable {
    public var hasVideo: Bool
    public var hasSequence: Bool
    public var mode: WorkMode

    public init(hasVideo: Bool = false, hasSequence: Bool = false, mode: WorkMode = .gallery) {
        self.hasVideo = hasVideo
        self.hasSequence = hasSequence
        self.mode = mode
    }
}

/// Hostitelské prostředí stránky. Implementuje ho AppModel v KromaApp,
/// aby stránky nezávisely na konkrétní aplikaci.
public protocol PageHost: AnyObject, Sendable {
    @MainActor var pageContext: PageContext { get }
}

/// Modul stránky. Každá stránka je samostatný SwiftPM target implementující tento protokol:
/// přidání = zkopírování adresáře + registrace v PageRegistry, odebrání = obráceně.
public protocol PageModule: Sendable {
    static var id: String { get }
    static var title: String { get }
    /// SF Symbol název ikony v docku.
    static var icon: String { get }
    /// Klávesy pro přepnutí stránky, první je primární.
    static var shortcutKeys: [String] { get }
    /// Kontextová viditelnost v docku.
    static func isVisible(in context: PageContext) -> Bool
    @MainActor static func makeView(host: any PageHost) -> AnyView
}
