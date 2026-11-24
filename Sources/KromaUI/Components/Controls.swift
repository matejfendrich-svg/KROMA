import SwiftUI

/// Popisek ve stylu FR_APP: 11 px, medium, uppercase, tracking 0.18 em, sekundární barva.
public struct KromaLabel: View {
    public let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .tracking(2)
            .textCase(.uppercase)
            .foregroundStyle(DesignTokens.Palette.textSecondary)
    }
}

public enum KromaButtonVariant {
    case primary
    case secondary
    case ghost
}

/// Tlačítko ve stylu FR_APP: uppercase, tracking, kartičkový radius, efekt stisku scale 0.98.
public struct KromaButton: View {
    public let title: String
    public let variant: KromaButtonVariant
    public let action: () -> Void

    public init(_ title: String, variant: KromaButtonVariant = .primary, action: @escaping () -> Void) {
        self.title = title
        self.variant = variant
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.system(size: 13, weight: variant == .primary ? .bold : .medium))
                .tracking(1.8)
                .foregroundStyle(foreground)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(background)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius)
                        .stroke(border, lineWidth: variant == .secondary ? 1 : 0)
                )
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
        }
        .buttonStyle(KromaPressStyle())
    }

    private var foreground: Color {
        switch variant {
        case .primary: return Theme.shared.onAccent
        case .secondary, .ghost: return DesignTokens.Palette.textPrimary
        }
    }

    private var background: Color {
        switch variant {
        case .primary: return Theme.shared.accentBase
        case .secondary, .ghost: return .clear
        }
    }

    private var border: Color {
        variant == .secondary ? DesignTokens.Palette.separatorStrong : .clear
    }
}

struct KromaPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: DesignTokens.snapDuration), value: configuration.isPressed)
    }
}

/// Badge ve stylu FR_APP: pill s tečkou (aktivní tečka svítí), mono 10 px uppercase.
public struct KromaBadge: View {
    public let text: String
    public var active: Bool

    public init(_ text: String, active: Bool = false) {
        self.text = text
        self.active = active
    }

    public var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(active ? Theme.shared.accentBase : DesignTokens.Palette.faint)
                .frame(width: 6, height: 6)
                .shadow(color: active ? Color.white.opacity(0.9) : .clear, radius: 8)
            Text(text)
                .font(.system(size: 10, design: .monospaced))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(DesignTokens.Palette.textSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .overlay(Capsule().stroke(DesignTokens.Palette.separator, lineWidth: 1))
        .clipShape(Capsule())
    }
}

/// Segmented control ve stylu FR_APP: kontejner s border, aktivní segment bílý s černým textem.
public struct KromaSegmented<Value: Hashable>: View {
    public let options: [(value: Value, label: String)]
    @Binding public var selection: Value

    public init(options: [(value: Value, label: String)], selection: Binding<Value>) {
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                Button {
                    selection = option.value
                } label: {
                    Text(option.label.uppercased())
                        .font(.system(size: 11, weight: .medium))
                        .tracking(1.2)
                        .foregroundStyle(selection == option.value ? Theme.shared.onAccent : DesignTokens.Palette.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selection == option.value ? Theme.shared.accentBase : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .background(DesignTokens.Palette.panel)
        .overlay(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius).stroke(DesignTokens.Palette.separator, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.cardCornerRadius))
    }
}

/// Toggle ve stylu FR_APP: pill 44x24, zapnuto = bílé s černým kolečkem.
public struct KromaToggle: View {
    public let label: String?
    @Binding public var isOn: Bool

    public init(_ label: String? = nil, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }

    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack {
                if let label {
                    Text(label)
                        .font(.system(size: 13))
                        .foregroundStyle(DesignTokens.Palette.textPrimary)
                }
                Spacer()
                ZStack {
                    Capsule()
                        .fill(isOn ? Theme.shared.accentBase : DesignTokens.Palette.elevated)
                        .overlay(Capsule().stroke(DesignTokens.Palette.separatorStrong, lineWidth: 1))
                    Circle()
                        .fill(isOn ? Theme.shared.onAccent : DesignTokens.Palette.faint)
                        .frame(width: 16, height: 16)
                        .offset(x: isOn ? 10 : -10)
                }
                .frame(width: 44, height: 24)
            }
        }
        .buttonStyle(.plain)
    }
}
