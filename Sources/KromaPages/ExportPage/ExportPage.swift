import SwiftUI
import KromaRegistry
import KromaUI

public struct ExportPage: PageModule {
    public static let id = "export"
    public static let title = "Export"
    public static let icon = "square.and.arrow.up"
    public static let shortcutKeys = ["7", "e"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    @MainActor public static func makeView(host: any PageHost) -> AnyView {
        AnyView(PagePlaceholderView(title: title, detail: "M5/M6 – záložky Foto/Video/Animace, formát, kvalita, fronta na pozadí"))
    }
}
