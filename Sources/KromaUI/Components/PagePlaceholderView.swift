import SwiftUI

/// Dočasný obsah stránky – až bude stránka implementovaná, tento view zmizí.
public struct PagePlaceholderView: View {
    public let title: String
    public let detail: String

    public init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 20, weight: .bold))
                .tracking(3)
                .foregroundStyle(DesignTokens.Palette.textPrimary)
            Text(detail)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
