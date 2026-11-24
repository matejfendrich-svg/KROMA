# 0003 – Distribuce výhradně přes podepsaný DMG

- Stav: přijato
- Datum: 2026-02-14

## Kontext
Autor chce instalaci přetažením do Applications, bez App Store (kvůli sandboxu a přístupu ke složkám) a bez PKG/ZIP/Homebrew. Aktualizace řeší Sparkle.

## Rozhodnutí
Jediný distribuční artefakt je DMG vytvořený `scripts/release.sh`. Produkční build je podepsaný Developer ID a notarizovaný přes `notarytool`. Dokud certifikát není k dispozici, skript vytváří ad-hoc podepsané DMG určené jen pro autora – lokální vývoj na vlastním MacBooku na certifikátu nezávisí.

## Důsledky
- `scripts/release.sh` je závazný a opakovatelný; release nikdy ručními kroky.
- Notarizace běží v CI přes tajné údaje (`DEVELOPER_ID`, `NOTARIZE_KEYCHAIN_PROFILE`).
- Entitlements: sandbox vypnutý, síťový klient zapnutý (Sparkle) – viz `Resources/Kroma.entitlements`.
