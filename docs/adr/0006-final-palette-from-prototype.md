# 0006 – Finální paleta podle interaktivního prototypu (spec 3.3 + šedý/bílý akcent)

- Stav: přijato (pokyn autora)
- Datum: 2026-11-24

## Kontext
Po inspiraci FR_APP (ADR 0005) autor dodal interaktivní React prototyp rozhraní Kroma („monochrom“). Prototyp používá paletu ze specifikace kapitola 3.3 (bg #0D0E0F, panel #151719, elev #1C1F22, sep #26282B, text #F4F4F2, secondary #A6A8AA) s akcentem **moderní šedá #C9CED4** (výchozí) nebo **čistá bílá #FFFFFF**, textem na akcentu #0A0A0B. Jediným barevným prvkem rozhraní jsou balanční kola ve stránce Color (reprezentují skutečnou barvu obrazu).

## Rozhodnutí
`DesignTokens.Palette` odpovídá přesně prototypu/spec 3.3 (test `KromaUITests` hlídá hex hodnoty). `AccentPreset` = `seda` (výchozí) / `bila`, volitelně vlastní hex (spec 8.1). Štítky klipů: osm šedých odstínů `labelPalette`. Dock 64 px s čísly kláves a zářícím bílým podtržením aktivní stránky; přechod stránek 220 ms; boční panely tažné (výchozí 190/248 px, dvojklik reset). Fonty: SF Pro / SF Mono (nativní ekvivalent Space Grotesk / JetBrains Mono z FR_APP).

## Důsledky
- ADR 0005 (FR_APP #000–#FFF) se tímto přepisuje pro finální vzhled; monochromní princip zůstává.
- `docs/design.md` obsahuje aktuální mapování prototyp → KromaUI.
