import SwiftUI
import KromaRegistry
import KromaUI

/// Dolní dock ve stylu DaVinci Resolve přestylizovaný podle FR_APP (mono):
/// ikony s popisky, aktivní stránka bílá s bílým underline, výška 56 pt, popisek 10 pt.
public struct DockView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(model.visiblePages().enumerated()), id: \.offset) { _, page in
                DockItem(
                    page: page,
                    isActive: page.id == model.selectedPageID,
                    accent: model.theme.accentHover
                ) {
                    model.selectPage(page.id)
                }
            }
            Spacer()
            Button {
                model.showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 15))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius)
                            .stroke(DesignTokens.Palette.separator, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .help("Nastavení")
            .padding(.trailing, 8)
        }
        .frame(height: DesignTokens.dockHeight)
        .background(DesignTokens.Palette.panel)
    }
}

private struct DockItem: View {
    let page: any PageModule.Type
    let isActive: Bool
    let accent: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: page.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isActive ? accent : DesignTokens.Palette.textSecondary)
                Text(page.title)
                    .font(.system(size: DesignTokens.dockLabelSize))
                    .foregroundStyle(isActive ? DesignTokens.Palette.textPrimary : DesignTokens.Palette.textSecondary)
                Rectangle()
                    .fill(isActive ? accent : Color.clear)
                    .frame(width: 36, height: 2)
            }
            .frame(width: 64)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
