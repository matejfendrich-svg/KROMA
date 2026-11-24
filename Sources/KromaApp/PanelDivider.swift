import Observation
import SwiftUI
import KromaUI

/// Tenká (6 px) tažná hrana mezi panely: přetáhnutí mění šířku, dvojklik resetuje (prototyp).
public struct PanelDivider: View {
    @Binding public var width: CGFloat
    public let minWidth: CGFloat
    public let maxWidth: CGFloat
    public let inverted: Bool
    public let onReset: () -> Void

    private let drag = PanelDragState()

    public init(width: Binding<CGFloat>, minWidth: CGFloat, maxWidth: CGFloat, inverted: Bool = false, onReset: @escaping () -> Void) {
        self._width = width
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.inverted = inverted
        self.onReset = onReset
    }

    public var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 6)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { value in
                        if !drag.started {
                            drag.startWidth = width
                            drag.started = true
                        }
                        let delta = inverted ? -value.translation.width : value.translation.width
                        width = min(maxWidth, max(minWidth, drag.startWidth + delta))
                    }
                    .onEnded { _ in
                        drag.started = false
                    }
            )
            .onTapGesture(count: 2) {
                onReset()
            }
    }
}

@Observable
private final class PanelDragState {
    var started = false
    var startWidth: CGFloat = 0
}
