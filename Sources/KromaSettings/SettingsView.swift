import Observation
import SwiftUI
import KromaRegistry
import KromaUI

/// Lokální stav pohledu přes @Observable (bez @State – build jen s Command Line Tools).
@Observable
private final class SettingsViewState {
    var search: String = ""
    var selection: SettingsSection = .workspace
}

/// Modální okno nastavení podle prototypu: hlavička s vyhledáváním a zavřením,
/// levý seznam sekcí, obsah se sekcemi podle kapitoly 8.1.
public struct SettingsView: View {
    @Bindable public var store: SettingsStore
    public let onClose: () -> Void
    private let viewState = SettingsViewState()

    public init(store: SettingsStore, onClose: @escaping () -> Void) {
        self.store = store
        self.onClose = onClose
    }

    private var filteredSections: [SettingsSection] {
        if viewState.search.isEmpty { return SettingsSection.allCases }
        return SettingsSection.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(viewState.search)
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            header
            HStack(spacing: 0) {
                sectionNav
                Divider().background(DesignTokens.Palette.separator)
                ScrollView {
                    content
                        .padding(16)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 720, height: 520)
        .background(DesignTokens.Palette.elevated)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(DesignTokens.Palette.separator, lineWidth: 1))
        .foregroundStyle(DesignTokens.Palette.textPrimary)
    }

    private var header: some View {
        HStack(spacing: 16) {
            Image(systemName: "gearshape")
                .font(.system(size: 14))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
            Text("Nastavení")
                .font(.system(size: 12, weight: .semibold))
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
                TextField("hledat nastavení", text: Binding(
                    get: { viewState.search },
                    set: { viewState.search = $0 }
                ))
                .textFieldStyle(.plain)
                .font(.system(size: 11))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
                .frame(width: 180)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(DesignTokens.Palette.panel)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
            }
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(DesignTokens.Palette.textPrimary)
                    .frame(width: 32, height: 32)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .overlay(alignment: .bottom) {
            Divider().background(DesignTokens.Palette.separator)
        }
    }

    private var sectionNav: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(filteredSections) { section in
                    let active = viewState.selection == section
                    Button {
                        viewState.selection = section
                    } label: {
                        Text(section.rawValue)
                            .font(.system(size: 11))
                            .foregroundStyle(active ? Theme.shared.onAccent : DesignTokens.Palette.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(active ? Theme.shared.accentBase : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(active ? Theme.shared.accentBase : Color.clear, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(6)
        }
        .frame(width: 190)
        .background(DesignTokens.Palette.panel)
    }

    @ViewBuilder
    private var content: some View {
        switch viewState.selection {
        case .workspace: workspaceSection
        case .performance: performanceSection
        case .project: projectSection
        case .export: exportSection
        case .shortcuts: shortcutsSection
        case .advanced: advancedSection
        }
    }

    private var workspaceSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            group("Pracovní režim nových projektů") {
                chipGroup(options: ["Galerie", "Resolve"], value: Binding(
                    get: { store.settings.defaultWorkMode == .resolve ? "Resolve" : "Galerie" },
                    set: { newValue in store.update { $0.defaultWorkMode = newValue == "Resolve" ? .resolve : .gallery } }
                ))
                note("Resolve: projekt je timeline s fotkami, adjustment a text klipy. Galerie: klasický fotoeditor, Edit jen u videa/animace.")
            }
            group("Akcent rozhraní") {
                chipGroup(options: AccentPreset.allCases.map(\.displayName), value: Binding(
                    get: { store.settings.accent.displayName },
                    set: { name in store.update { $0.accent = AccentPreset.allCases.first { $0.displayName == name } ?? .seda } }
                ))
                note("Monochromní rozhraní: černá, bílá a šedá. Barevná jsou výhradně balanční kola ve stránce Color.")
                TextField("vlastní hex", text: Binding(
                    get: { store.settings.customAccentHex ?? "" },
                    set: { newValue in store.update { $0.customAccentHex = newValue.isEmpty ? nil : newValue } }
                ))
                .textFieldStyle(.plain)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(DesignTokens.Palette.textPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(DesignTokens.Palette.panel)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
                .frame(width: 180)
            }
            group("Měřítko rozhraní") {
                KromaSlider(title: "Přiblížení celého UI", value: Binding(
                    get: { Double(store.settings.uiScale) },
                    set: { newValue in store.update { $0.uiScale = Int(newValue) } }
                ), range: 85...125, step: 1, defaultValue: 100, format: "%.0f %%")
                note("Šířky bočních ploch se mění přetahováním za vnitřní hranu, dvojklik na hranu vrátí výchozí šířku.")
            }
            group("Vzhled a panely") {
                KromaToggle("Mini náhled timeline (filmstrip)", isOn: Binding(
                    get: { store.settings.showTimelineFilmstrip },
                    set: { newValue in store.update { $0.showTimelineFilmstrip = newValue } }
                ))
                KromaToggle("Kompaktní velikost ovládacích prvků", isOn: Binding(
                    get: { store.settings.compactControls },
                    set: { newValue in store.update { $0.compactControls = newValue } }
                ))
            }
        }
    }

    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            group("Výkon") {
                styledSelect("Výkonová úroveň", options: ["Automaticky (benchmark)", "1 – úsporná", "2 – vyvážená", "3 – plná"], value: Binding(
                    get: { store.settings.performanceLevel.map { "\($0) – ručně" } ?? "Automaticky (benchmark)" },
                    set: { _ in }
                ))
                styledSelect("Rozlišení náhledu", options: ["Auto (fit panelu)", "1/4", "1/2", "Plné"], value: Binding(
                    get: { store.settings.previewResolution },
                    set: { newValue in store.update { $0.previewResolution = newValue } }
                ))
                styledSelect("Kvalita při interakci", options: ["Nízká", "Střední", "Vysoká"], value: Binding(
                    get: { store.settings.interactionQuality },
                    set: { newValue in store.update { $0.interactionQuality = newValue } }
                ))
            }
            group("Chlazení a baterie") {
                styledSelect("Eko režim", options: EkoMode.allCases.map(\.displayName), value: Binding(
                    get: { store.settings.ekoMode.displayName },
                    set: { name in store.update { $0.ekoMode = EkoMode.allCases.first { $0.displayName == name } ?? .never } }
                ))
                styledSelect("Práh termální reakce", options: ["fair", "serious", "critical"], value: Binding(
                    get: { store.settings.thermalThreshold },
                    set: { newValue in store.update { $0.thermalThreshold = newValue } }
                ))
            }
            group("Cache a proxy") {
                KromaSlider(title: "Maximální velikost cache", value: Binding(
                    get: { Double(store.settings.cacheSizeGB) },
                    set: { newValue in store.update { $0.cacheSizeGB = Int(newValue) } }
                ), range: 5...100, step: 1, defaultValue: 20, format: "%.0f GB")
                KromaToggle("Generování proxy pro 4K video", isOn: Binding(
                    get: { store.settings.generateProxy },
                    set: { newValue in store.update { $0.generateProxy = newValue } }
                ))
            }
        }
    }

    private var projectSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            group("Knihovna médií") {
                KromaToggle("Kopírovat originály do spravované knihovny", isOn: Binding(
                    get: { store.settings.copyOriginalsIntoLibrary },
                    set: { newValue in store.update { $0.copyOriginalsIntoLibrary = newValue } }
                ))
                KromaToggle("Zapisovat XML sidecar vedle originálů", isOn: Binding(
                    get: { store.settings.writeXMPSidecar },
                    set: { newValue in store.update { $0.writeXMPSidecar = newValue } }
                ))
            }
        }
    }

    private var exportSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            group("Exportní fronta") {
                chipGroup(options: ["1", "2", "4"], value: Binding(
                    get: { String(store.settings.exportQueueCount) },
                    set: { newValue in store.update { $0.exportQueueCount = Int(newValue) ?? 2 } }
                ))
                note("Fronta běží na pozadí v nízké prioritě; při termálním varování se úlohy pozastaví (spec 7.3).")
            }
        }
    }

    private var shortcutsSection: some View {
        group("Přehled zkratek") {
            VStack(spacing: 0) {
                ForEach(Array(shortcutRows.enumerated()), id: \.offset) { index, row in
                    HStack(spacing: 12) {
                        Text(row.0)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(Theme.shared.accentBase)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(DesignTokens.Palette.headerBg)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
                        Text(row.1)
                            .font(.system(size: 11))
                            .foregroundStyle(DesignTokens.Palette.textSecondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(index % 2 == 0 ? DesignTokens.Palette.panel : Color.clear)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
        }
    }

    private let shortcutRows: [(String, String)] = [
        ("1 – 7", "Přepnutí stránek"),
        ("mezerník", "Fullscreen prohlížeče"),
        ("\\ (podržet)", "Dočasný náhled originálu"),
        ("T", "Zobrazit nebo skrýt filmstrip"),
        ("J · K · L", "Přetočení zpět · stop · vpřed"),
        ("I · O", "Označení rozsahu"),
        ("Cmd + B", "Razor"),
        ("X", "Zamítnout snímek"),
        ("Escape", "Zavřít nastavení"),
    ]

    private var advancedSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            group("Jazyk a aktualizace") {
                styledSelect("Jazyk aplikace", options: ["Čeština", "English"], value: Binding(
                    get: { store.settings.language },
                    set: { newValue in store.update { $0.language = newValue } }
                ))
                styledSelect("Kanál aktualizací", options: ["Stabilní", "Beta"], value: Binding(
                    get: { store.settings.updateChannel },
                    set: { newValue in store.update { $0.updateChannel = newValue } }
                ))
            }
            group("Diagnostika") {
                Text("Apple Silicon · GPU · thermal \(ProcessInfo.processInfo.thermalState.rawValue) · žádná telemetrie")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
            group("Obnovit") {
                KromaButton("Resetovat nastavení na výchozí", variant: .secondary) {
                    store.update { $0 = AppSettings() }
                }
            }
        }
    }

    private func group<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("◆ \(title)")
                .font(.system(size: 10, weight: .medium))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(DesignTokens.Palette.textPrimary)
            content()
        }
    }

    private func note(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10))
            .foregroundStyle(DesignTokens.Palette.textSecondary)
    }

    private func chipGroup<Value: Hashable>(options: [Value], value: Binding<Value>) -> some View {
        HStack(spacing: 6) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                let active = value.wrappedValue == option
                Button {
                    value.wrappedValue = option
                } label: {
                    Text(String(describing: option))
                        .font(.system(size: 11))
                        .foregroundStyle(active ? Theme.shared.onAccent : DesignTokens.Palette.textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(active ? Theme.shared.accentBase : DesignTokens.Palette.elevated)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(active ? Theme.shared.accentBase : DesignTokens.Palette.separator, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func styledSelect(_ label: String, options: [String], value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            KromaLabel(label)
            Picker(label, selection: value) {
                ForEach(options, id: \.self) { Text($0).tag($0) }
            }
            .font(.system(size: 12))
            .foregroundStyle(DesignTokens.Palette.textPrimary)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(DesignTokens.Palette.elevated)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(DesignTokens.Palette.separator, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}
