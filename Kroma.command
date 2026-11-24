#!/usr/bin/env bash
#
# Kroma – sestavení na tomto MacBooku jedním dvojklikem.
# Spustí scripts/release.sh (swift build + ad-hoc podpis + DMG)
# a výsledný Kroma-*.dmg přesune na Plochu.
# Poté stačí DMG otevřít a přetáhnout Kroma do složky Applications.

set -euo pipefail

cd "$(dirname "$0")"

echo "==> Sestavuji Kroma (scripts/release.sh)..."
./scripts/release.sh

echo ""
echo "==> Ověřuji DMG (scripts/test-release.sh – bez varování Gatekeeperu, spustitelnost)..."
./scripts/test-release.sh

DMG="$(ls -t ./*.dmg 2>/dev/null | head -n 1 || true)"
if [[ -n "${DMG}" ]]; then
    mv "${DMG}" ~/Desktop/
    echo ""
    echo "Hotovo: ~/Desktop/${DMG##*/}"
    echo "Otevři ten soubor a přetáhni Kroma do Applications."
else
    echo "DMG se nevytvořilo – viz výstup výše." >&2
    exit 1
fi
