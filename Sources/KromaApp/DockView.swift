import SwiftUI
import KromaRegistry
import KromaUI

/// Dolní dock podle prototypu: 64 px, stránky rovnoměrně, ikona + 8px uppercase popisek,
/// číslo klávesy vlevo nahoře, aktivní stránka: zvýšené pozadí + bílý text + 2px bílá
/// čárka dole se září. Vpravo oddělené ozubené kolo (nastavení).
public struct DockView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(model.visiblePages().enumerated()), id: \.offset) { index, page in
                let active = page.id == model.selectedPageID
                Button {
                    model.selectPage(page.id)
                } label: {
                    ZStack(alignment: .topLeading) {
                        VStack(spacing: 6) {
                            Image(systemName: page.icon)
                                .font(.system(size: 17))
                            Text(page.title)
                                .font(.system(size: 8, weight: .medium))
                                .tracking(2.1)
                                .textCase(.uppercase)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Text(page.id == "export" ? "7" : "\(index + 1)")
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundStyle(DesignTokens.Palette.textSecondary)
                            .padding(.top, 4)
                            .padding(.leading, 6)
                        if active {
                            VStack {
                                Spacer()
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(height: 2)
                                    .shadow(color: .white.opacity(0.8), radius: 10)
                                    .padding(.horizontal, 12)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
                .background(active ? DesignTokens.Palette.elevated : Color.clear)
                .foregroundStyle(active ? Color.white : DesignTokens.Palette.textSecondary)
            }
            Button {
                model.showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 16))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                    .frame(width: 64)
                    .contentShape(Rectangle())
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(DesignTokens.Palette.separator)
                            .frame(width: 1)
                    }
            }
            .buttonStyle(.plain)
            .help("Nastavení")
        }
        .frame(height: DesignTokens.dockHeight)
        .background(DesignTokens.Palette.headerBg)
    }
}
