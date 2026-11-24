import SwiftUI

/// Panel s výchozím vzhledem: pozadí bg.panel, radius 4 pt, tenký oddělovač 1 pt.
public struct KromaPanel<Content: View>: View {
    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .background(DesignTokens.Palette.panel)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.panelCornerRadius))
    }
}

public extension View {
    func kromaSeparator() -> some View {
        Divider()
            .background(DesignTokens.Palette.separator)
            .frame(height: DesignTokens.separatorWidth)
    }
}
