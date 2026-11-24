import SwiftUI
import KromaRegistry
import KromaUI

public struct ColorPage: PageModule {
    public static let id = "color"
    public static let title = "Color"
    public static let icon = "circle.grid.3x3.filled"
    public static let shortcutKeys = ["3"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    public static func makeView(host: any PageHost) -> AnyView {
        AnyView(PagePlaceholderView(title: title, detail: "M3 – kola, qualifier, křivky, node tree, LUT, scopes"))
    }
}
