# Kroma

Nedestruktivní editor fotografií a videí pro macOS (Apple Silicon, macOS 14+).
Nativní Swift 6 + SwiftUI + Metal, žádný Electron, žádný `.xcodeproj` – build výhradně přes `Package.swift`.

Kompletní specifikace: [docs/spec.md](docs/spec.md). Architektonická rozhodnutí: [docs/adr/](docs/adr/). Konvence: [docs/conventions.md](docs/conventions.md).

## Vývoj

```bash
swift build          # sestavení
swift run Kroma      # lokální spuštění
swift test           # testy (Swift Testing)
swiftlint lint       # lint
```

Požadavky: Xcode Command Line Tools (stačí `xcode-select --install`), plné Xcode není potřeba.

## Release

```bash
scripts/release.sh   # build + podpis (ad-hoc nebo Developer ID) + DMG
```

Na vlastním MacBooku stačí jednou dvojkliknout na soubor **`Kroma.command`** v kořeni repozitáře: sestaví aplikaci a hotové `Kroma-*.dmg` položí na Plochu. DMG pak otevřeš normálně a přetáhneš Kromu do Applications (lokálně sestavené DMG nevyžaduje certifikát a nevyvolá varování Gatekeeperu).

Produkční build s notarizací přes proměnné `DEVELOPER_ID` a `NOTARIZE_KEYCHAIN_PROFILE` (viz hlavička skriptu).

## Struktura

```
Sources/
  KromaApp/        vstupní bod, okno, dock, routování stránek
  KromaUI/         design system, tokeny, komponenty
  KromaCore/       média, node graf, projekt, perzistence
  KromaEngine/     render DAG, Metal kernely (Kernels/)
  KromaRegistry/   EffectRegistry, PageRegistry, schémata parametrů
  KromaMediaKit/   import, RAW, proxy, cache
  KromaColor/      ICC, LUT, pracovní prostor, soft proofing
  KromaFX/         definice efektů
  KromaPages/      ImportPage ObrazPage ColorPage FXPage EditPage ExportPage
  KromaExporter/   export a fronta
  KromaSettings/   nastavení
Tests/             unit testy + golden render testy
scripts/release.sh release přes DMG
docs/              specifikace, ADR, konvence
```
