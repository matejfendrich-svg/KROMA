import SwiftUI
import KromaUI

/// Levý panel: seznam médií projektu (klient, složka).
public struct MediaPanelView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            KromaLabel("Složka · projekt")
                .padding(8)
            Divider().background(DesignTokens.Palette.separator)
            if let media = model.projectStore.project?.media, !media.isEmpty {
                List(media) { item in
                    HStack(spacing: 6) {
                        Image(systemName: item.kind == .video ? "film" : "photo")
                            .font(.system(size: 11))
                            .foregroundStyle(DesignTokens.Palette.textSecondary)
                        Text(item.url.lastPathComponent)
                            .font(.system(size: 10))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        if item.rating > 0 {
                            Text(String(repeating: "★", count: item.rating))
                                .font(.system(size: 9))
                                .foregroundStyle(Theme.shared.accentBase)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(DesignTokens.Palette.panel)
            } else {
                Text("Žádná média – stránka Import (1) přidá složku.")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                    .padding(8)
                Spacer()
            }
        }
        .background(DesignTokens.Palette.panel)
    }
}

/// Pravý panel: inspektor vlastností aktuální stránky.
public struct InspectorView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KromaLabel("Inspektor")
            if let page = model.visiblePages().first(where: { $0.id == model.selectedPageID }) {
                Text(page.title.uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .tracking(1.6)
                    .foregroundStyle(DesignTokens.Palette.textPrimary)
            }
            Text("Posuvníky parametrů se generují ze schématu efektů (M2+).")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            Spacer()
        }
        .padding(8)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(DesignTokens.Palette.panel)
    }
}
