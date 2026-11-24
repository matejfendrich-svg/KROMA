import AppKit
import SwiftUI
import KromaUI

/// Hlavička podle prototypu: logo K, název + projekt/cesta, cache badge, výkonová úroveň,
/// pulzující termální tečka s popiskem, fullscreen.
public struct HeaderView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(hex: "#0D0E0F"))
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(DesignTokens.Palette.separator, lineWidth: 1))
                Text("K")
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(DesignTokens.Palette.textPrimary)
            }
            .frame(width: 24, height: 24)
            Text("Kroma")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
            if let project = model.projectStore.project {
                Text("· \(project.name.uppercased()) · \(model.projectStore.packageURL?.path ?? "")")
                    .font(.system(size: 11))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Spacer()
            Text("cache —")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(DesignTokens.Palette.elevated)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text("úroveň \(model.settings.settings.performanceLevel ?? 3)")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            HStack(spacing: 6) {
                TimelineView(.periodic(from: .now, by: 2.4)) { context in
                    Circle()
                        .fill(model.thermalState.color)
                        .frame(width: 8, height: 8)
                        .opacity(pulse(context.date))
                }
                Text(model.thermalState.label.replacingOccurrences(of: "Teplota: ", with: "thermal ").lowercased())
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
            .help(model.thermalState.label)
            Button {
                NSApp.windows.first?.toggleFullScreen(nil)
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 13))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
            .buttonStyle(.plain)
            .help("Celá obrazovka")
        }
        .padding(.horizontal, 12)
        .frame(height: DesignTokens.headerHeight)
        .background(DesignTokens.Palette.headerBg)
    }

    private func pulse(_ date: Date) -> Double {
        let phase = date.timeIntervalSince1970.truncatingRemainder(dividingBy: 2.4) / 2.4
        return phase < 0.5 ? 1 - 0.65 * 2 * phase : 0.35 + 0.65 * 2 * (phase - 0.5)
    }
}
