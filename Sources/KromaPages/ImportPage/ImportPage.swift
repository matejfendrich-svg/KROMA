import SwiftUI
import KromaRegistry
import KromaUI

public struct ImportPage: PageModule {
    public static let id = "import"
    public static let title = "Import"
    public static let icon = "tray.and.arrow.down"
    public static let shortcutKeys = ["1"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    public static func makeView(host: any PageHost) -> AnyView {
        AnyView(PagePlaceholderView(title: title, detail: "M1 – výběr složky, mřížka náhledů, culling, import do projektu"))
    }
}
