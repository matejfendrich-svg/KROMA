import KromaRegistry
import KromaUI
import Observation
import SwiftUI

/// Stav stránky Color – kola a posuvníky na lokálních hodnotách (M3 napojí na node graf).
@Observable
final class ColorPageState {
    var wheels: [String: CGPoint] = [
        "lift": CGPoint(x: 0.1, y: -0.1),
        "gamma": CGPoint(x: 0.05, y: 0.12),
        "gain": CGPoint(x: -0.08, y: -0.05),
        "offset": CGPoint(x: 0, y: 0),
    ]
    var saturace = 6.0
    var vibrance = 14.0
    var teplota = -8.0
    var nodes: [KromaNodeTree.Node] = [
        KromaNodeTree.Node(label: "Still 01 · Korekce", on: true),
        KromaNodeTree.Node(label: "Balancer", on: true),
        KromaNodeTree.Node(label: "Qualifier · obloha", on: true),
        KromaNodeTree.Node(label: "LUT Fuji K", on: false),
    ]
}

public struct ColorPage: PageModule {
    public static let id = "color"
    public static let title = "Color"
    public static let icon = "circle.grid.3x3.filled"
    public static let shortcutKeys = ["3"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    @MainActor public static func makeView(host: any PageHost) -> AnyView {
        AnyView(ColorPageView(state: ColorPageState()))
    }
}

private struct ColorPageView: View {
    let state: ColorPageState

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                viewer
                Divider().background(DesignTokens.Palette.separator)
                inspector
            }
            Divider().background(DesignTokens.Palette.separator)
            nodeTree
        }
        .background(DesignTokens.Palette.base)
    }

    private var viewer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hue: 0.58, saturation: 0.5, brightness: 0.42),
                    Color(hue: 0.07, saturation: 0.55, brightness: 0.16),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: 860)
            .aspectRatio(1000.0 / 640.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(DesignTokens.Palette.separator, lineWidth: 1))
            .padding(16)
            VStack {
                HStack(spacing: 4) {
                    badge("VECTORSKOP")
                    Spacer()
                }
                .padding(8)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var inspector: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                KromaLabel("Balanční kola")
                HStack(spacing: 12) {
                    ForEach(["lift", "gamma", "gain", "offset"], id: \.self) { name in
                        KromaColorWheel(
                            name: name,
                            position: Binding(
                                get: { state.wheels[name] ?? .zero },
                                set: { state.wheels[name] = $0 }
                            )
                        )
                    }
                }
                KromaLabel("Sytost")
                KromaSlider(title: "Saturace", value: $state.saturace, range: -100...100, step: 1)
                KromaSlider(title: "Vibrance", value: $state.vibrance, range: -100...100, step: 1)
                KromaSlider(title: "Teplota", value: $state.teplota, range: -100...100, step: 1)
            }
            .padding(12)
        }
        .frame(width: 248)
        .background(DesignTokens.Palette.panel)
    }

    private var nodeTree: some View {
        VStack(alignment: .leading, spacing: 4) {
            KromaLabel("Node tree · kliknutí zapne/vypne uzel")
                .padding(.horizontal, 12)
            KromaNodeTree(nodes: $state.nodes) {
                state.nodes.append(KromaNodeTree.Node(label: "Uzel \(state.nodes.count + 1)", on: true))
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 4)
        .background(DesignTokens.Palette.panel)
    }

    private func badge(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(DesignTokens.Palette.textPrimary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
