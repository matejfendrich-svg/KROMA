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
            Text("Média")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
                .padding(8)
            Divider().background(DesignTokens.Palette.separator)
            if let media = model.projectStore.project?.media, !media.isEmpty {
                List(media) { item in
                    HStack(spacing: 6) {
                        Image(systemName: item.kind == .video ? "film" : "photo")
                            .foregroundStyle(DesignTokens.Palette.textSecondary)
                        Text(item.url.lastPathComponent)
                            .font(.system(size: 11))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        if item.rating > 0 {
                            Text(String(repeating: "★", count: item.rating))
                                .font(.system(size: 9))
                                .foregroundStyle(DesignTokens.Palette.accentGreenHover)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(DesignTokens.Palette.panel)
            } else {
                Text("Žádná média – M1 přidá import ze složky.")
                    .font(.system(size: 11))
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
            Text("Inspektor")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            if let page = model.visiblePages().first(where: { $0.id == model.selectedPageID }) {
                Text(page.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(DesignTokens.Palette.textPrimary)
            }
            Text("M2+ zde budou posuvníky parametrů generované ze schématu efektů.")
                .font(.system(size: 11))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            Spacer()
        }
        .padding(8)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(DesignTokens.Palette.panel)
    }
}
