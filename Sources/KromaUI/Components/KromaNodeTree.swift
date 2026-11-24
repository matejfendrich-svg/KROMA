import SwiftUI

/// Node tree podle prototypu: horizontální řetěz uzlů (104 px), kliknutí přepne
/// aktivaci, čárka mezi uzly, na konci přerušované tlačítko „+".
public struct KromaNodeTree: View {
    public struct Node: Identifiable, Sendable {
        public let id: UUID
        public var label: String
        public var on: Bool

        public init(id: UUID = UUID(), label: String, on: Bool = true) {
            self.id = id
            self.label = label
            self.on = on
        }
    }

    @Binding public var nodes: [Node]
    public let onAdd: (() -> Void)?

    public init(nodes: Binding<[Node]>, onAdd: (() -> Void)? = nil) {
        self._nodes = nodes
        self.onAdd = onAdd
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(nodes.enumerated()), id: \.element.id) { index, node in
                    if index > 0 {
                        Rectangle()
                            .fill(DesignTokens.Palette.textSecondary)
                            .frame(width: 16, height: 1)
                    }
                    Button {
                        nodes[index].on.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(node.label)
                                .font(.system(size: 10, weight: .semibold))
                                .lineLimit(1)
                                .foregroundStyle(node.on ? Theme.shared.onAccent : DesignTokens.Palette.textPrimary)
                            Text(node.on ? "aktivní" : "vypnuto")
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundStyle(node.on ? Color(hex: "#2A2C30") : DesignTokens.Palette.textSecondary)
                        }
                        .frame(width: 104, alignment: .leading)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(node.on ? Theme.shared.accentBase : DesignTokens.Palette.elevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.controlRadius)
                                .stroke(node.on ? Theme.shared.accentBase : DesignTokens.Palette.separator, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.controlRadius))
                    }
                    .buttonStyle(.plain)
                }
                if let onAdd {
                    Rectangle()
                        .fill(DesignTokens.Palette.textSecondary)
                        .frame(width: 16, height: 1)
                    Button(action: onAdd) {
                        Image(systemName: "plus")
                            .font(.system(size: 12))
                            .foregroundStyle(DesignTokens.Palette.textSecondary)
                            .frame(width: 32, height: 42)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignTokens.controlRadius)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                    .foregroundStyle(DesignTokens.Palette.separator)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
    }
}
