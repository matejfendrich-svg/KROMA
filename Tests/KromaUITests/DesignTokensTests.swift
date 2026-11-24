import AppKit
import SwiftUI
import Testing
import KromaUI

private func hexString(_ color: NSColor) -> String {
    String(
        format: "#%02X%02X%02X",
        Int(color.redComponent * 255),
        Int(color.greenComponent * 255),
        Int(color.blueComponent * 255)
    )
}

@Test func paletteMatchesFRAppMonoTokens() {
    #expect(hexString(NSColor(DesignTokens.Palette.base)) == "#000000")
    #expect(hexString(NSColor(DesignTokens.Palette.panel)) == "#0A0A0A")
    #expect(hexString(NSColor(DesignTokens.Palette.elevated)) == "#141414")
    #expect(hexString(NSColor(DesignTokens.Palette.separator)) == "#262626")
    #expect(hexString(NSColor(DesignTokens.Palette.separatorStrong)) == "#3D3D3D")
    #expect(hexString(NSColor(DesignTokens.Palette.textPrimary)) == "#FFFFFF")
    #expect(hexString(NSColor(DesignTokens.Palette.textSecondary)) == "#A3A3A3")
    #expect(hexString(NSColor(DesignTokens.Palette.textFaint)) == "#525252")
    #expect(hexString(NSColor(DesignTokens.Palette.accent)) == "#FFFFFF")
}

@Test func paletteIsMonochrome() {
    let colors: [NSColor] = [
        NSColor(DesignTokens.Palette.base),
        NSColor(DesignTokens.Palette.panel),
        NSColor(DesignTokens.Palette.elevated),
        NSColor(DesignTokens.Palette.separator),
        NSColor(DesignTokens.Palette.separatorStrong),
        NSColor(DesignTokens.Palette.textPrimary),
        NSColor(DesignTokens.Palette.textSecondary),
        NSColor(DesignTokens.Palette.textFaint),
        NSColor(DesignTokens.Palette.accent),
    ]
    for color in colors {
        #expect(abs(color.redComponent - color.greenComponent) < 0.02)
        #expect(abs(color.greenComponent - color.blueComponent) < 0.02)
    }
}

@Test func colorHexParser() {
    let parsed = NSColor(Color(hex: "#2AA06B"))
    #expect(abs(parsed.redComponent - 0x2A / 255.0) < 0.01)
    #expect(abs(parsed.greenComponent - 0xA0 / 255.0) < 0.01)
    #expect(abs(parsed.blueComponent - 0x6B / 255.0) < 0.01)
}

@Test func defaultAccentIsMono() {
    #expect(AccentPreset.mono.base == DesignTokens.Palette.accent)
    #expect(AccentPreset.mono.onAccent == DesignTokens.Palette.onAccent)
}
