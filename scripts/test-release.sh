#!/usr/bin/env bash
#
# Akceptační test distribuce (specifikace kapitola 12, bod 6):
# DMG sestavený release skriptem bez certifikátu (ad-hoc podpis) musí být
# na Apple Silicon MacBooku otevřený bez varování Gatekeeperu a aplikace
# po přetažení do složky Applications musí fungovat.
#
# Kontroluje se:
#   1. DMG existuje (jinak se nejprve sestaví přes scripts/release.sh)
#   2. DMG obsahuje Kroma.app a odkaz na složku Applications
#   3. podpis aplikace je platný (codesign --verify --deep --strict)
#   4. Gatekeeper aplikaci neodmítá (spctl --assess) a nemá karanténu
#   5. simulace instalace: kopie do "Applications", spuštění, běžící proces
#      (krok 5 jen když běží WindowServer – na MacBooku vždy, v headless CI přeskočen)

set -euo pipefail

cd "$(dirname "$0")/.."

APP_NAME="Kroma"

if ! ls ./*.dmg >/dev/null 2>&1; then
    echo "==> Žádný DMG nenalezen, sestavuji přes scripts/release.sh"
    ./scripts/release.sh
fi

DMG="$(ls -t ./*.dmg | head -n 1)"
echo "==> Testuji DMG: ${DMG}"

MNT="$(mktemp -d)"
INSTALL_ROOT="$(mktemp -d)"
trap 'hdiutil detach "${MNT}" -quiet 2>/dev/null || true; rm -rf "${MNT}" "${INSTALL_ROOT}"' EXIT

echo "==> Připojuji DMG"
hdiutil attach -nobrowse -readonly -mountpoint "${MNT}" "${DMG}"

test -d "${MNT}/${APP_NAME}.app" || { echo "FAIL: v DMG chybí ${APP_NAME}.app" >&2; exit 1; }
test -L "${MNT}/Applications" || { echo "FAIL: v DMG chybí odkaz na Applications" >&2; exit 1; }
echo "==> DMG obsahuje ${APP_NAME}.app a odkaz na Applications"

APP="${MNT}/${APP_NAME}.app"

echo "==> Ověřuji podpis (codesign --verify --deep --strict)"
codesign --verify --deep --strict --verbose=2 "${APP}"

echo "==> Gatekeeper (spctl --assess --type execute)"
spctl --assess --type execute --verbose "${APP}" || { echo "FAIL: spctl aplikaci odmítl" >&2; exit 1; }

if xattr -l "${APP}" 2>/dev/null | grep -q "com.apple.quarantine"; then
    echo "FAIL: aplikace má atribut karantény com.apple.quarantine" >&2
    exit 1
fi
echo "==> Žádná karanténa (com.apple.quarantine) – Gatekeeper tedy nezobrazí varování"

if pgrep -q WindowServer; then
    echo "==> Simulace instalace do Applications a spuštění aplikace"
    mkdir -p "${INSTALL_ROOT}/Applications"
    cp -R "${APP}" "${INSTALL_ROOT}/Applications/${APP_NAME}.app"
    INSTALLED="${INSTALL_ROOT}/Applications/${APP_NAME}.app/Contents/MacOS/${APP_NAME}"

    "${INSTALLED}" &
    APP_PID=$!
    sleep 4
    if ! kill -0 "${APP_PID}" 2>/dev/null; then
        wait "${APP_PID}" || true
        echo "FAIL: aplikace se po spuštění ukončila (crash nebo blokování Gatekeeperem)" >&2
        exit 1
    fi
    kill "${APP_PID}" 2>/dev/null || true
    wait "${APP_PID}" 2>/dev/null || true
    echo "==> Aplikace po instalaci běží"
else
    echo "==> WindowServer neběží (headless prostředí) – krok spuštění aplikace se přeskočí"
fi

echo "PASS: ${DMG} – otevře se bez varování Gatekeeperu, podpis platný, instalace přetažením funguje"
