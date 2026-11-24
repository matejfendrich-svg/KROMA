import SwiftUI
import KromaRegistry
import KromaUI

public struct ObrazPage: PageModule {
    public static let id = "obraz"
    public static let title = "Obraz"
    public static let icon = "circle.lefthalf.filled"
    public static let shortcutKeys = ["2"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    @MainActor public static func makeView(host: any PageHost) -> AnyView {
        AnyView(PagePlaceholderView(title: title, detail: "M2 – expozice, jas, kontrast, stíny, světlá jako uzly grafu"))
    }
}
