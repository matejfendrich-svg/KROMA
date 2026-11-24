# 0001 – Build výhradně přes Package.swift, žádný .xcodeproj

- Stav: přijato
- Datum: 2026-02-14

## Kontext
Specifikace kapitola 11 vyžaduje, aby CLI agent buildoval výhradně přes manifest `Package.swift` a aby se v repozitáři nikdy nevytvářel `.xcodeproj` ani `.xcworkspace`. Release skript musí fungovat jen s Xcode Command Line Tools.

## Rozhodnutí
Jediný build systém je Swift Package Manager (`swift build`, `swift test`). `.app` balíček pro DMG se skládá ručně v `scripts/release.sh` (MacOS/ + Info.plist + PkgInfo). Žádný soubor Xcode projektu se necommituje.

## Důsledky
- CI běží `swift build` / `swift test` přímo, bez `xcodebuild`.
- Ikony v docku používají SF Symbols místo asset catalogu (ten by vyžadoval Xcode).
- Při změně struktury targetů se edituje jen `Package.swift`.
