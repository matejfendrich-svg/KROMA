import KromaSettings
import KromaUI
import SwiftUI

/// Hlavní okno: hlavička nahoře, vlevo seznam médií, uprostřed stránka,
/// vpravo inspektor, dole dock stránek.
public struct MainWindowView: View {
    @Bindable public var model: AppModel

    public init(model: AppModel) {
        self.model = model
    }

    public var body: some View {
        VStack(spacing: 0) {
            HeaderView(model: model)
            Divider().background(DesignTokens.Palette.separator)
            HStack(spacing: 0) {
                if model.showMediaPanel {
                    MediaPanelView(model: model)
                        .frame(width: 240)
                    Divider().background(DesignTokens.Palette.separator)
                }
                VStack(spacing: 0) {
                    currentPage
                    Divider().background(DesignTokens.Palette.separator)
                    DockView(model: model)
                }
                if model.showInspector {
                    Divider().background(DesignTokens.Palette.separator)
                    InspectorView(model: model)
                        .frame(width: 280)
                }
            }
        }
        .background(DesignTokens.Palette.base)
        .foregroundStyle(DesignTokens.Palette.textPrimary)
        .onKeyPress { press in
            if model.handleShortcut(press.characters) {
                return .handled
            }
            return .ignored
        }
        .sheet(isPresented: $model.showSettings) {
            SettingsView(store: model.settings)
        }
    }

    private var currentPage: some View {
        let pages = model.visiblePages()
        let page = pages.first { $0.id == model.selectedPageID } ?? pages.first
        return Group {
            if let page {
                page.makeView(host: model)
            } else {
                PagePlaceholderView(title: "Kroma", detail: "Žádné stránky nejsou registrovány")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
