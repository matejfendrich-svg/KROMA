import AppKit
import SwiftUI
import Testing
import KromaUI

private func hexString(_ color: NSColor) -> String {
    String(
        format: "#%02X%02X%02X",
        Int(round(color.redComponent * 255)),
        Int(round(color.greenComponent * 255)),
        Int(round(color.blueComponent * 255))
    )
}

@Test func paletteMatchesPrototypeTokens() {
    #expect(hexString(NSColor(DesignTokens.Palette.base)) == "#0D0E0F")
    #expect(hexString(NSColor(DesignTokens.Palette.deep)) == "#08090A")
    #expect(hexString(NSColor(DesignTokens.Palette.headerBg)) == "#0A0B0C")
    #expect(hexString(NSColor(DesignTokens.Palette.panel)) == "#151719")
    #expect(hexString(NSColor(DesignTokens.Palette.elevated)) == "#1C1F22")
    #expect(hexString(NSColor(DesignTokens.Palette.separator)) == "#26282B")
    #expect(hexString(NSColor(DesignTokens.Palette.textPrimary)) == "#F4F4F2")
    #expect(hexString(NSColor(DesignTokens.Palette.textSecondary)) == "#A6A8AA")
    #expect(hexString(NSColor(DesignTokens.Palette.faint)) == "#3A3E44")
    #expect(hexString(NSColor(DesignTokens.Palette.onAccent)) == "#0A0A0B")
}

@Test func paletteIsNearMonochrome() {
    let colors: [NSColor] = [
        NSColor(DesignTokens.Palette.base),
        NSColor(DesignTokens.Palette.deep),
        NSColor(DesignTokens.Palette.headerBg),
        NSColor(DesignTokens.Palette.panel),
        NSColor(DesignTokens.Palette.elevated),
        NSColor(DesignTokens.Palette.separator),
        NSColor(DesignTokens.Palette.textPrimary),
        NSColor(DesignTokens.Palette.textSecondary),
        NSColor(DesignTokens.Palette.faint),
        NSColor(DesignTokens.Palette.onAccent),
        NSColor(AccentPreset.seda.base),
        NSColor(AccentPreset.bila.base),
    ]
    for color in colors {
        #expect(abs(color.redComponent - color.greenComponent) < 0.05)
        #expect(abs(color.greenComponent - color.blueComponent) < 0.05)
    }
}

@Test func labelPaletteHasEightGraySteps() {
    #expect(DesignTokens.labelPalette.count == 8)
    let first = NSColor(DesignTokens.labelPalette[0])
    let last = NSColor(DesignTokens.labelPalette[7])
    #expect(first.redComponent < last.redComponent)
}

@Test func colorHexParser() {
    let parsed = NSColor(Color(hex: "#C9CED4"))
    #expect(abs(parsed.redComponent - 0xC9 / 255.0) < 0.01)
    #expect(abs(parsed.greenComponent - 0xCE / 255.0) < 0.01)
    #expect(abs(parsed.blueComponent - 0xD4 / 255.0) < 0.01)
}

@Test func defaultAccentIsSeda() {
    #expect(AccentPreset.seda.base == Color(hex: "#C9CED4"))
    #expect(AccentPreset.bila.base == Color(hex: "#FFFFFF"))
    #expect(AccentPreset.seda.onAccent == DesignTokens.Palette.onAccent)
}
