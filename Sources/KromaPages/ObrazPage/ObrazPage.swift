import KromaRegistry
import KromaUI
import Observation
import SwiftUI

/// Stav stránky Obraz – posuvníky napojené na lokální hodnoty (M2 napojí na node graf).
@Observable
final class ObrazPageState {
    var exposure = 12.0
    var brightness = 4.0
    var contrast = 8.0
    var highlights = -14.0
    var shadows = 18.0
    var clarity = 10.0
    var texture = 6.0
}

public struct ObrazPage: PageModule {
    public static let id = "obraz"
    public static let title = "Obraz"
    public static let icon = "circle.lefthalf.filled"
    public static let shortcutKeys = ["2"]

    public init() {}

    public static func isVisible(in context: PageContext) -> Bool { true }

    @MainActor public static func makeView(host: any PageHost) -> AnyView {
        AnyView(ObrazPageView(state: ObrazPageState()))
    }
}

private struct ObrazPageView: View {
    @Bindable var state: ObrazPageState

    var body: some View {
        HStack(spacing: 0) {
            photoList
            Divider().background(DesignTokens.Palette.separator)
            viewer
            Divider().background(DesignTokens.Palette.separator)
            inspector
        }
        .background(DesignTokens.Palette.base)
    }

    private var photoList: some View {
        VStack(alignment: .leading, spacing: 0) {
            KromaLabel("Složka · XT5")
                .padding(8)
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(0..<8, id: \.self) { index in
                        HStack(spacing: 8) {
                            mockThumb(hue: Double(index) * 0.11)
                                .frame(width: 34, height: 22)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(DesignTokens.Palette.separator, lineWidth: 1))
                            Text("DSCF\(4120 + index * 7)")
                                .font(.system(size: 10))
                                .foregroundStyle(DesignTokens.Palette.textSecondary)
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .frame(width: 190)
        .background(DesignTokens.Palette.panel)
    }

    private var viewer: some View {
        ZStack {
            mockPhotoLarge
                .frame(maxWidth: 860)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(DesignTokens.Palette.separator, lineWidth: 1))
                .padding(16)
            VStack {
                HStack(spacing: 4) {
                    badge("FIT 100%")
                    badge("GALERIE režim", dim: true)
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
                KromaLabel("Základní úprava obrazu")
                KromaSlider(title: "Expozice", value: $state.exposure, range: -50...50, step: 1)
                KromaSlider(title: "Jas", value: $state.brightness, range: -100...100, step: 1)
                KromaSlider(title: "Kontrast", value: $state.contrast, range: -100...100, step: 1)
                KromaSlider(title: "Světlá", value: $state.highlights, range: -100...100, step: 1)
                KromaSlider(title: "Stíny", value: $state.shadows, range: -100...100, step: 1)
                KromaSlider(title: "Clarity", value: $state.clarity, range: -100...100, step: 1)
                KromaSlider(title: "Texture", value: $state.texture, range: -100...100, step: 1)
                Text("podrž \\ pro originál")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(DesignTokens.Palette.textSecondary)
            }
            .padding(12)
        }
        .frame(width: 248)
        .background(DesignTokens.Palette.panel)
    }

    private func badge(_ text: String, dim: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(dim ? DesignTokens.Palette.textSecondary : DesignTokens.Palette.textPrimary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.black.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private func mockThumb(hue: Double) -> some View {
        LinearGradient(
            colors: [
                Color(hue: hue, saturation: 0.55, brightness: 0.55),
                Color(hue: hue + 0.15, saturation: 0.65, brightness: 0.12),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var mockPhotoLarge: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hue: 0.58, saturation: 0.5, brightness: 0.42),
                    Color(hue: 0.62, saturation: 0.45, brightness: 0.24),
                    Color(hue: 0.07, saturation: 0.55, brightness: 0.16),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            Circle()
                .fill(Color(hue: 0.1, saturation: 0.6, brightness: 0.95))
                .frame(width: 60, height: 60)
                .offset(x: 120, y: -60)
        }
        .aspectRatio(1000.0 / 640.0, contentMode: .fit)
    }
}
