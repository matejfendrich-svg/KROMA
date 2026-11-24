# 0005 – Design podle FR_APP (MONO/FRAME): monochromatická paleta, bílý akcent

- Stav: přijato (pokyn autora)
- Datum: 2026-11-24

## Kontext
Autor chce, aby se Kroma inspirovala designem své aplikace FR_APP (repo `matejfendrich-svg/FR_APP`, větev `vibe/stop-motion-studio-ca068b`, PR „MONO/FRAME — Stop Motion Studio PWA“). FR_APP používá čistě černobílý design – audit palety pouze #000–#FFF, bílý akcent, fonty Space Grotesk + JetBrains Mono.

## Rozhodnutí
`KromaUI.DesignTokens` přebírá paletu a principy z FR_APP (viz `docs/design.md`): bg #000000, surface #0A0A0A, surface2 #141414, border #262626, borderStrong #3D3D3D, text #FFFFFF, dim #A3A3A3, faint #525252, accent #FFFFFF (text na akcentu černý). Karty radius 12 px, badge pill 999 px, easing cubic-bezier(0.2, 0, 0, 1) / 180 ms, label 11 px uppercase tracking 0.18 em, bg-grid 32 px. Výchozí předvolba akcentu v nastavení je `mono`; ostatní barevné předvolby zůstávají dostupné. Tím se mění výchozí paleta ze specifikace kapitola 3.3 (zelená) na mono podle novějšího pokynu autora.

Fonty: FR_APP self-hostuje Space Grotesk a JetBrains Mono. Nativní macOS aplikace používá jejich systémový ekvivalent SF Pro a SF Mono (`.system(size:design:.monospaced)`); později lze webfonty přibalit jako Bundle resource + registrace přes CTFontManager.

## Důsledky
- Komponenty v `KromaUI/Components/Controls.swift` (Label, Button, Badge, Segmented, Toggle) kopírují třídy `.label`, `.btn-*`, `.badge`, `.seg`, toggle z `src/index.css` FR_APP.
- Layout: boční panely 230 px (média) a 300 px (inspektor), střed na bg-grid.
- Test `KromaUITests` hlídá, že paleta zůstává přesně podle FR_APP tokenů a monochromatická.
