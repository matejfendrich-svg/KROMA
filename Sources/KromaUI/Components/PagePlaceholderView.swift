import SwiftUI

/// Dočasný obsah stránky v M0 – až bude stránka implementovaná, tento view zmizí.
public struct PagePlaceholderView: View {
    public let title: String
    public let detail: String

    public init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
            Text(detail)
                .font(.system(size: 12))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignTokens.Palette.base)
    }
}
