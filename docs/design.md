# Design Kroma – podle interaktivního prototypu (monochrom)

Zdroj: interaktivní React prototyp dodaný autorem (spec + prototyp). ADR 0006. Dřívější inspirace FR_APP (MONO/FRAME) viz ADR 0005 – monochromní princip zůstává, finální tokeny jsou podle prototypu.

## Paleta (spec 3.3, shodná s prototypem)

| Token | Hex | Použití |
|---|---|---|
| `base` | #0D0E0F | pozadí aplikace |
| `deep` | #08090A | pozadí timeline |
| `headerBg` | #0A0B0C | hlavička a dock |
| `panel` | #151719 | boční panely, karty, toolbar |
| `elevated` | #1C1F22 | vstupy, badges, aktivní dock, modál |
| `separator` | #26282B | 1px linky |
| `textPrimary` | #F4F4F2 | hlavní text |
| `textSecondary` | #A6A8AA | popisky, hodnoty, neaktivní prvky |
| `faint` | #3A3E44 | meta text, neaktivní hvězdy |
| `onAccent` | #0A0A0B | text na akcentu |

**Akcent** (nastavení): `seda` #C9CED4 (výchozí) nebo `bila` #FFFFFF; volitelně vlastní hex. Stavové barvy jen pro indikátor tepla (spec 8.2): #2AA06B / oranžová / #D9483B.

**Jediný barevný prvek UI: balanční kola** – conic přes #2AA06B, #D9483B, #7B6CE0, #3E8FD6, #D9C548 (`Palette.wheelColors`), bílý knob, mono hodnota `hue° sat`.

Štítky klipů: 8 šedých odstínů `DesignTokens.labelPalette` (#2A2C30 … #B4BAC0).

## Typografie

SF Pro (`.system(size:)`) a SF Mono pro hodnoty (`.system(size:design:.monospaced)`). Label styl: 9–11 px, medium, uppercase, tracking ~0.2 em, barva secondary → `KromaLabel`.

## Rozměry a pohyb

- Hlavička 44 px, dock 64 px, boční panely výchozí 190 px (levé) / 248 px (pravé), tažné za 6px hranu, dvojklik reset.
- Přechod stránek: 220 ms, opacity + scale 0.985 + y 10 (vstup), opacity (výstup).
- Ovládací prvky: 180 ms ease-out, tlačítka při stisku scale 0.96–0.98.
- Radius: ovládací prvky 4 px, dlaždice/karty 6 px, badge pill.
- Slider: tenký track, akcent; hodnota v mono, dvojklik na hodnotu = reset (spec 3.4).

## Komponenty (prototyp → KromaUI)

| Prototyp | KromaUI |
|---|---|
| dock s ikonami, čísly kláves, zářícím podtržením | `DockView` (64 px) |
| hlavička s logem K, cache badge, thermal tečkou | `HeaderView` |
| tažné hrany panelů | `PanelDivider` |
| `.label` | `KromaLabel` |
| primární/sekundární/ghost tlačítko | `KromaButton` |
| karta | `KromaPanel` |
| badge s tečkou | `KromaBadge` |
| segmented/chipy | `KromaSegmented`, chipy v nastavení |
| toggle switch | `KromaToggle` |
| slider s labelem a mono hodnotou | `KromaSlider` |
| balanční kolo (jediný barevný prvek) | `KromaColorWheel` |
| node tree – řetěz uzlů, klik přepíná, „+“ přidá | `KromaNodeTree` |
| importní mřížka s hvězdami a zamítnutím | `ImportPage` (maketa; M1 napojí data) |
| modální nastavení 720×520, vyhledávání, sekce | `SettingsView` |

## Stránky podle prototypu

- **Import**: toolbar (složka, řazení, filtr, počty, tlačítko Importovat) + mřížka dlaždic (min 168 px), výběr 2px akcent, zamítnuté ztlumené s X, 5 hvězd, klávesy 1–5/X.
- **Obraz**: levý seznam fotek, střed prohlížeč (badge FIT 100%), inspektor s posuvníky expozice…texture.
- **Color**: 4 balanční kola, saturace/vibrance/teplota, node tree dole.
- **FX**: výběr typu rastru, velikost prvku, úhel, mix, písmeno pro písmenný raster.
- **Edit**: toolbar (timecode, J/K/L, snapping, razor Cmd+B, I/O), stopy FOTO/ADJ/TEXT, inspektor klipu (štítky, mix, kopírovat/vložit grade).
- **Export**: záložky Foto/Video/Animace, formát/kvalita/barevný prostor, velký akcentní export s progress.
- **Nastavení**: 6 sekcí podle spec 8.1 (prostředí, výkon, projekt, export, zkratky, rozšířené).
