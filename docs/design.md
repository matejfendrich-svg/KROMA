# Design Kroma podle FR_APP (MONO/FRAME)

Zdroj: `matejfendrich-svg/FR_APP`, větev `vibe/stop-motion-studio-ca068b` (PR #1 „MONO/FRAME — Stop Motion Studio PWA“). Rozhodnutí viz ADR 0005.

## Paleta (pouze #000–#FFF, audit „jen paleta + bílá alfa")

| FR_APP (Tailwind) | Hex | Kroma token | Použití |
|---|---|---|---|
| `bg` | #000000 | `Palette.base` | pozadí aplikace |
| `surface` | #0A0A0A | `Palette.panel` | panely, karty, dock, hlavička |
| `surface2` | #141414 | `Palette.elevated` | vstupy, modály, přepínače |
| `border` | #262626 | `Palette.separator` | 1px linky, rámečky karet |
| `borderStrong` | #3D3D3D | `Palette.separatorStrong` | hover rámečky, slider track |
| `text` | #FFFFFF | `Palette.textPrimary` | hlavní text |
| `dim` | #A3A3A3 | `Palette.textSecondary` | popisky, neaktivní prvky |
| `faint` | #525252 | `Palette.textFaint` | meta text, hinty kláves |
| `accent` | #FFFFFF | `Palette.accent` | aktivní stavy, bílé tlačítko (text na něm #000) |

Stavové barvy mimo mono téma (spec 8.2): `statusGreen` #2AA06B, `statusOrange`, `statusRed` #D9483B – jen indikátor tepla.

## Typografie

- FR_APP: Space Grotesk (sans 400/500/700) + JetBrains Mono, self-hosted.
- Kroma (macOS): SF Pro + SF Mono jako nativní ekvivalent – `.system(size:)` a `.system(size:design:.monospaced)`.
- `.label`: 11 px, medium, uppercase, tracking 0.18 em (~2 pt), barva dim → `KromaLabel`.
- Čísla a hodnoty: mono, např. `font-mono text-[11px]`.

## Rozměry a pohyb

- Karty: radius 12 px (`card`), badge: pill 999 px.
- Pohyby: 180 ms, `cubic-bezier(0.2, 0, 0, 1)` („snap“); tlačítka při stisku `scale(0.98)`.
- Slider: track 2 px #3D3D3D, thumb 14 px bílý kruh se září `0 0 8px rgba(255,255,255,0.6)`.
- Výběr textu invertovaný (bílé pozadí, černý text); scrollbar tenký, thumb #3D3D3D.
- `bg-grid`: mřížka 32 px, linky rgba(255,255,255,0.03) za středovou plochou → `KromaGridBackground`.

## Komponenty (mapování FR_APP → KromaUI)

| FR_APP třída/komponenta | KromaUI |
|---|---|
| `.label` | `KromaLabel` |
| `.btn-primary` / `.btn-secondary` / `.btn-ghost` | `KromaButton` (variant) |
| `.icon-btn` | kulaté ikonové tlačítko s borderem (dock gear) |
| `.card` | `KromaPanel` |
| `.badge` + `.badge-dot(-active)` | `KromaBadge` |
| `.seg` / `.seg-btn(-active)` | `KromaSegmented` |
| Toggle (switch) | `KromaToggle` |
| Slider (input range) | `KromaSlider` |
| `.input` | mono text field, surface2, focus borderStrong |
| Modal / ConfirmDialog | `bg-black/80` overlay + karta, hlavička s labelem |

## Layout

- 3 sloupce jako EditorPage FR_APP: levý panel 230 px (seznam médií), střed (prohlížeč na bg-grid), pravý inspektor 300 px; dole dock stránek 56 pt.
- Hlavička: název projektu bold uppercase tracking, cesta v mono faint, stavové tečky.
- Klávesové hinty jako faint mono 9 px uppercase (viz levý panel editoru FR_APP).
