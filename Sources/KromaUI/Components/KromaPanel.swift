import SwiftUI

/// Karta ve stylu FR_APP: bg surface, 1px border, radius 12 px.
public struct KromaPanel<Content: View>: View {
    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .background(DesignTokens.Palette.panel)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.cardRadius)
                    .stroke(DesignTokens.Palette.separator, lineWidth: DesignTokens.separatorWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardRadius))
    }
}

public extension View {
    func kromaSeparator() -> some View {
        Divider()
            .background(DesignTokens.Palette.separator)
            .frame(height: DesignTokens.separatorWidth)
    }
}
