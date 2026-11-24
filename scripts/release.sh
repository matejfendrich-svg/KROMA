#!/usr/bin/env bash
#
# Jediný release skript projektu Kroma.
# Sestaví aplikaci přes Swift Package Manager, podepíše ji (Developer ID,
# nebo ad-hoc před pořízením certifikátu), volitelně notarizuje přes
# notarytool a zabalí výsledek do DMG přetažením do složky Applications.
#
# Bez .xcodeproj, funguje s Xcode Command Line Tools.
#
# Proměnné prostředí:
#   DEVELOPER_ID        jméno Developer ID certifikátu (např. "Developer ID Application: ...")
#   NOTARIZE_KEYCHAIN_PROFILE  profil v keychaini pro notarytool (např. "kroma-notary")
#   VERSION             verze releasu (výchozí: git describe nebo 0.1.0)

set -euo pipefail

cd "$(dirname "$0")/.."

APP_NAME="Kroma"
BUNDLE_ID="com.kroma.app"
VERSION="${VERSION:-$(git describe --tags --always 2>/dev/null || echo "0.1.0")}"
CONFIGURATION="${CONFIGURATION:-release}"

echo "==> Release ${APP_NAME} ${VERSION} (${CONFIGURATION})"

echo "==> swift build -c ${CONFIGURATION}"
swift build -c "${CONFIGURATION}"

BINARY=".build/${CONFIGURATION}/${APP_NAME}"
test -x "${BINARY}" || { echo "Chybí binárka ${BINARY}" >&2; exit 1; }

STAGE="$(mktemp -d)"
trap 'rm -rf "${STAGE}"' EXIT

APP_DIR="${STAGE}/${APP_NAME}.app"
mkdir -p "${APP_DIR}/Contents/MacOS" "${APP_DIR}/Contents/Resources"
# Odkaz na Applications, aby se v okně DMG dalo přetáhnout do Applications.
ln -s /Applications "${STAGE}/Applications"

cp "${BINARY}" "${APP_DIR}/Contents/MacOS/${APP_NAME}"
sed -e "s/__VERSION__/${VERSION}/g" Resources/AppInfo.plist > "${APP_DIR}/Contents/Info.plist"
printf 'APPL????' > "${APP_DIR}/Contents/PkgInfo"

if [[ -n "${DEVELOPER_ID:-}" ]]; then
    echo "==> Podpis Developer ID: ${DEVELOPER_ID}"
    codesign --force --options runtime \
        --entitlements Resources/Kroma.entitlements \
        --sign "${DEVELOPER_ID}" "${APP_DIR}"
else
    echo "==> Ad-hoc podpis (bez Developer ID certifikátu)"
    codesign --force --sign - --entitlements Resources/Kroma.entitlements "${APP_DIR}"
fi

echo "==> Kontrola podpisu"
codesign --verify --deep --strict --verbose=2 "${APP_DIR}"

if [[ -n "${NOTARIZE_KEYCHAIN_PROFILE:-}" ]]; then
    echo "==> Notarizace přes notarytool"
    DMG_RAW="${STAGE}/${APP_NAME}-${VERSION}-unsigned.dmg"
    hdiutil create -volname "${APP_NAME}" -srcfolder "${STAGE}" -ov -format UDZO "${DMG_RAW}"
    xcrun notarytool submit "${DMG_RAW}" --keychain-profile "${NOTARIZE_KEYCHAIN_PROFILE}" --wait
    xcrun stapler staple "${DMG_RAW}"
    mv "${DMG_RAW}" "${APP_NAME}-${VERSION}.dmg"
    echo "==> Hotovo: ${APP_NAME}-${VERSION}.dmg (notarizováno)"
else
    echo "==> Přeskakuji notarizaci (není NOTARIZE_KEYCHAIN_PROFILE), DMG bude jen ad-hoc podepsané"
    hdiutil create -volname "${APP_NAME}" -srcfolder "${STAGE}" -ov -format UDZO "${APP_NAME}-${VERSION}.dmg"
    echo "==> Hotovo: ${APP_NAME}-${VERSION}.dmg (pouze pro autora)"
fi
