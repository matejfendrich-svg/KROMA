import KromaRegistry
import KromaUI
import Observation
import SwiftUI

/// Stav stránky Import (M1 napojí na reálná data ze složky; teď maketa podle prototypu).
@Observable
final class ImportPageState {
    var count = 24
    var ratings: [Int: Int] = [0: 3, 2: 5, 4: 4, 7: 2]
    var rejected: Set<Int> = [1]
    var selected: Set<Int> = [0]

    func toggleSelected(_ index: Int) {
        if selected.contains(index) { selected.remove(index) } else { selected.insert(index) }
    }

    func setRating(_ index: Int, _ stars: Int) {
        ratings[index] = ratings[index] == stars ? 0 : stars
    }

    func toggleRejected(_ index: Int) {
        if rejected.contains(index) { rejected.remove(index) } else { rejected.insert(index) }
    }
}

public struct ImportPage: PageModule {
    public static let id = "import"
    public static let title = "Import"
    public static let icon = "tray.and.arrow.down"
    public static let shortcutKeys = ["1"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    @MainActor public static func makeView(host: any PageHost) -> AnyView {
        AnyView(ImportPageView(state: ImportPageState()))
    }
}

private struct ImportPageView: View {
    let state: ImportPageState

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 168), spacing: 8)], spacing: 8) {
                    ForEach(0..<state.count, id: \.self) { index in
                        tile(index)
                    }
                }
                .padding(12)
            }
        }
        .background(DesignTokens.Palette.base)
    }

    private var toolbar: some View {
        HStack(spacing: 8) {
            Button {} label: {
                HStack(spacing: 8) {
                    Image(systemName: "folder")
                        .font(.system(size: 13))
                    Text("/Fotky/XT5/hrad")
                        .font(.system(size: 11))
                }
                .foregroundStyle(DesignTokens.Palette.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(DesignTokens.Palette.elevated)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
            }
            .buttonStyle(.plain)
            styledPicker(title: "Řadit: datum sestupně", options: ["Řadit: datum sestupně", "Řadit: hodnocení"])
            styledPicker(title: "Filtr: vše", options: ["Filtr: vše", "Filtr: bez zamítnutých", "Filtr: 4 hvězdy a více"])
            Spacer()
            Text("\(state.selected.count) vybráno · \(state.rejected.count) zamítnuto")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textSecondary)
            KromaButton("Importovat do projektu", variant: .primary) {}
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(DesignTokens.Palette.panel)
        .overlay(alignment: .bottom) {
            Divider().background(DesignTokens.Palette.separator)
        }
    }

    private func styledPicker(title: String, options: [String]) -> some View {
        Picker(title, selection: Binding(get: { title }, set: { _ in })) {
            ForEach(options, id: \.self) { Text($0).tag($0) }
        }
        .font(.system(size: 11))
        .foregroundStyle(DesignTokens.Palette.textSecondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(DesignTokens.Palette.elevated)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func tile(_ index: Int) -> some View {
        let rejected = state.rejected.contains(index)
        let selected = state.selected.contains(index)
        let hue = Double(index) * 0.13
        return ZStack(alignment: .bottom) {
            mockPhoto(hue: hue)
                .frame(height: 104)
            if rejected {
                Color.black.opacity(0.45)
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.shared.onAccent)
                    .frame(width: 20, height: 20)
                    .background(Theme.shared.accentBase)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(4)
            }
            HStack {
                Text("DSCF\(4120 + index * 7)")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                Spacer()
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Button {
                            state.setRating(index, star)
                        } label: {
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundStyle((state.ratings[index] ?? 0) >= star ? DesignTokens.Palette.textPrimary : DesignTokens.Palette.faint)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.72))
            Button {
                state.toggleRejected(index)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                    .frame(width: 20, height: 20)
                    .background(Color.black.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(4)
            .help("Zamítnout (X)")
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(tileBorder(selected: selected, rejected: rejected), lineWidth: selected || rejected ? 2 : 1)
        )
        .opacity(rejected ? 0.35 : 1)
        .onTapGesture {
            state.toggleSelected(index)
        }
    }

    private func tileBorder(selected: Bool, rejected: Bool) -> Color {
        if selected { return Theme.shared.accentBase }
        if rejected { return DesignTokens.Palette.textSecondary }
        return DesignTokens.Palette.separator
    }

    private func mockPhoto(hue: Double) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hue: hue, saturation: 0.55, brightness: 0.55),
                    Color(hue: hue + 0.08, saturation: 0.6, brightness: 0.3),
                    Color(hue: hue + 0.15, saturation: 0.65, brightness: 0.12),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            Circle()
                .fill(Color(hue: hue + 0.12, saturation: 0.7, brightness: 0.9).opacity(0.9))
                .frame(width: 26, height: 26)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(y: -14)
        }
    }
}
