import AppKit
import SwiftUI
import KromaUI

/// Hlavička okna: název projektu, cesta, stav cache, indikátor tepla, fullscreen.
public struct HeaderView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        HStack(spacing: 12) {
            Text(model.projectStore.project?.name ?? "Kroma")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
            if let path = model.projectStore.packageURL?.path {
                Text(path)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Text("Cache: —")
                .font(.system(size: 11))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            Circle()
                .fill(model.thermalState.color)
                .frame(width: 8, height: 8)
                .help(model.thermalState.label)
            Spacer()
            Button {
                NSApp.windows.first?.toggleFullScreen(nil)
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
            .buttonStyle(.plain)
            .help("Celá obrazovka")
        }
        .padding(.horizontal, 12)
        .frame(height: 36)
        .background(DesignTokens.Palette.panel)
    }
}
