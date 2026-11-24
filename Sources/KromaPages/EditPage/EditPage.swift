import SwiftUI
import KromaRegistry
import KromaUI

public struct EditPage: PageModule {
    public static let id = "edit"
    public static let title = "Edit"
    public static let icon = "timeline.selection"
    public static let shortcutKeys = ["5"]

    public init() {}

    /// Viditelná jen u projektu s videem, sekvencí z fotek, nebo v režimu Resolve.
    public static func isVisible(in context: PageContext) -> Bool {
        context.hasVideo || context.hasSequence || context.mode == .resolve
    }

    @MainActor public static func makeView(host: any PageHost) -> AnyView {
        AnyView(PagePlaceholderView(title: title, detail: "M6/M7 – timeline: stopy FOTO/ADJ/TEXT, razor Cmd+B, snapping, J/K/L, I/O"))
    }
}
