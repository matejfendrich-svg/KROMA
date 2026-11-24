# 0004 – Lokální spustitelnost DMG se ověřuje skriptem, ne ručně

- Stav: přijato
- Datum: 2026-11-24

## Kontext
Autor vyžaduje (specifikace kapitola 11, bod 8 a kapitola 12, bod 6): DMG sestavený lokálně na jeho MacBooku s Apple Silicon bez certifikátu (ad-hoc podpis) musí jít otevřít bez varování Gatekeeperu a bez ručního zásahu do zabezpečení; aplikace po přetažení do Applications musí fungovat. Tuto vlastnost musí CLI agent ověřit u každého milníku, kde vzniká spustitelná aplikace.

## Rozhodnutí
Kontrola je součástí `scripts/test-release.sh`, nikoliv ručního postupu. Skript ověří: obsah DMG (Kroma.app + odkaz na Applications), platnost podpisu (`codesign --verify --deep --strict`), přijetí Gatekeeperem (`spctl --assess`, absence `com.apple.quarantine`) a – když běží WindowServer – simulaci instalace se spuštěním aplikace. Skript běží v CI (krok po `swift test`) a lokálně přes `Kroma.command` po každém release.

## Důsledky
- Každý milník se spustitelnou aplikací končí během `scripts/test-release.sh`.
- V headless prostředí (CI bez WindowServer) se přeskočí jen krok spuštění procesu; podpis a Gatekeeper se kontrolují vždy.
- Produkční notarizovaný build zůstává cílem `scripts/release.sh` přes `DEVELOPER_ID`/`NOTARIZE_KEYCHAIN_PROFILE`.
