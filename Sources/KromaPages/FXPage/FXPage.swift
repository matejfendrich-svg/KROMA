import SwiftUI
import KromaRegistry
import KromaUI

public struct FXPage: PageModule {
    public static let id = "fx"
    public static let title = "FX"
    public static let icon = "sparkles"
    public static let shortcutKeys = ["4"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    public static func makeView(host: any PageHost) -> AnyView {
        AnyView(PagePlaceholderView(title: title, detail: "M4 – halftone, pixel, písmenný raster, depth node"))
    }
}
