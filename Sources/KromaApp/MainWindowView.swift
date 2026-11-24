import KromaSettings
import KromaUI
import SwiftUI

/// Hlavní okno podle prototypu: hlavička, resizable levý panel, střed se zoom přechodem
/// stránek, resizable inspektor, dock dole, modální nastavení.
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
                        .frame(width: model.leftPanelWidth)
                    PanelDivider(
                        width: $model.leftPanelWidth,
                        minWidth: DesignTokens.sidebarMinWidth,
                        maxWidth: DesignTokens.sidebarMaxWidth
                    ) {
                        model.leftPanelWidth = DesignTokens.sidebarDefaultWidth
                    }
                    Divider().background(DesignTokens.Palette.separator)
                }
                VStack(spacing: 0) {
                    ZStack {
                        currentPage
                    }
                    .id(model.selectedPageID)
                    .transition(
                        .asymmetric(
                            insertion: .opacity
                                .combined(with: .scale(scale: 0.985))
                                .combined(with: .offset(y: 10)),
                            removal: .opacity
                        )
                    )
                    .animation(.easeOut(duration: DesignTokens.pageTransitionDuration), value: model.selectedPageID)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: "#050607"))
                    Divider().background(DesignTokens.Palette.separator)
                    DockView(model: model)
                }
                if model.showInspector {
                    Divider().background(DesignTokens.Palette.separator)
                    PanelDivider(
                        width: $model.inspectorPanelWidth,
                        minWidth: DesignTokens.inspectorMinWidth,
                        maxWidth: DesignTokens.inspectorMaxWidth,
                        inverted: true
                    ) {
                        model.inspectorPanelWidth = DesignTokens.inspectorDefaultWidth
                    }
                    InspectorView(model: model)
                        .frame(width: model.inspectorPanelWidth)
                }
            }
        }
        .background(DesignTokens.Palette.base)
        .foregroundStyle(DesignTokens.Palette.textPrimary)
        .onKeyPress { press in
            if press.characters == "\u{1B}" {
                if model.showSettings {
                    model.showSettings = false
                    return .handled
                }
                return .ignored
            }
            if model.handleShortcut(press.characters) {
                return .handled
            }
            return .ignored
        }
        .sheet(isPresented: $model.showSettings) {
            SettingsView(store: model.settings) {
                model.showSettings = false
            }
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
