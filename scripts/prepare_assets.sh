#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_ICON="$ROOT_DIR/public/r4-icon.png"
SOURCE_LOGO="$ROOT_DIR/public/r4-logo.png"
ASSET_ROOT="$ROOT_DIR/R4/Resources/Assets.xcassets"
APP_ICON_DIR="$ASSET_ROOT/AppIcon.appiconset"
LOGO_DIR="$ASSET_ROOT/R4Logo.imageset"

if [[ ! -f "$SOURCE_ICON" ]]; then
  echo "Missing source icon: $SOURCE_ICON" >&2
  exit 1
fi

if [[ ! -f "$SOURCE_LOGO" ]]; then
  echo "Missing source logo: $SOURCE_LOGO" >&2
  exit 1
fi

mkdir -p "$APP_ICON_DIR" "$LOGO_DIR"

# Apple requires a 1024x1024 marketing/app icon source. The repository master
# can remain larger; CI derives the production asset deterministically.
sips -z 1024 1024 "$SOURCE_ICON" --out "$APP_ICON_DIR/r4-icon-1024.png" >/dev/null

# Keep the in-app logo at the original uploaded resolution/transparency.
cp "$SOURCE_LOGO" "$LOGO_DIR/r4-logo.png"

echo "Prepared R4 iOS assets."
