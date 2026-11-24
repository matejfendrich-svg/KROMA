import SwiftUI
import KromaRegistry
import KromaUI

/// Modální okno nastavení: vyhledávání nahoře, seznam sekcí vlevo (kapitola 8).
public struct SettingsView: View {
    @Bindable public var store: SettingsStore
    @State private var search: String = ""
    @State private var selection: SettingsSection? = .workspace

    public init(store: SettingsStore) {
        self.store = store
    }

    private var filteredSections: [SettingsSection] {
        if search.isEmpty { return SettingsSection.allCases }
        return SettingsSection.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(search)
        }
    }

    public var body: some View {
        NavigationSplitView {
            List(filteredSections, selection: $selection) { section in
                Text(section.rawValue)
            }
            .searchable(text: $search, prompt: "Hledat nastavení")
            .navigationSplitViewColumnWidth(min: 180, ideal: 220)
        } detail: {
            if let selection {
                sectionView(selection)
            } else {
                Text("Vyberte sekci")
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
        }
        .frame(minWidth: 640, minHeight: 420)
        .background(DesignTokens.Palette.base)
        .foregroundStyle(DesignTokens.Palette.textPrimary)
    }

    @ViewBuilder
    private func sectionView(_ section: SettingsSection) -> some View {
        Form {
            switch section {
            case .workspace:
                Picker("Výchozí režim nových projektů", selection: Binding(
                    get: { store.settings.defaultWorkMode },
                    set: { newValue in store.update { $0.defaultWorkMode = newValue } }
                )) {
                    Text("Galerie").tag(WorkMode.gallery)
                    Text("Resolve").tag(WorkMode.resolve)
                }
                Picker("Dominantní barva", selection: Binding(
                    get: { store.settings.accent },
                    set: { newValue in store.update { $0.accent = newValue } }
                )) {
                    ForEach(AccentPreset.allCases) { preset in
                        Text(preset.rawValue.capitalized).tag(preset)
                    }
                }
                TextField("Vlastní hex barva", text: Binding(
                    get: { store.settings.customAccentHex ?? "" },
                    set: { newValue in store.update { $0.customAccentHex = newValue.isEmpty ? nil : newValue } }
                ))
                Toggle("Mini náhled timeline", isOn: Binding(
                    get: { store.settings.showTimelineFilmstrip },
                    set: { newValue in store.update { $0.showTimelineFilmstrip = newValue } }
                ))
            case .performance:
                Picker("Eko režim", selection: Binding(
                    get: { store.settings.ekoMode },
                    set: { newValue in store.update { $0.ekoMode = newValue } }
                )) {
                    Text("Nikdy").tag(EkoMode.never)
                    Text("Jen na baterii").tag(EkoMode.onBattery)
                    Text("Vždy").tag(EkoMode.always)
                }
            case .project:
                Toggle("Kopírovat originály do knihovny", isOn: Binding(
                    get: { store.settings.copyOriginalsIntoLibrary },
                    set: { newValue in store.update { $0.copyOriginalsIntoLibrary = newValue } }
                ))
                Toggle("Zapisovat XML sidecar (XMP)", isOn: Binding(
                    get: { store.settings.writeXMPSidecar },
                    set: { newValue in store.update { $0.writeXMPSidecar = newValue } }
                ))
            case .export, .shortcuts, .advanced:
                Text("Připraveno v dalším milníku.")
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
        }
        .formStyle(.grouped)
        .background(DesignTokens.Palette.base)
        .navigationTitle(section.rawValue)
    }
}
