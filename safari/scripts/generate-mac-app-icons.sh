#!/bin/sh
# Regenerate Mac host AppIcon (asset catalog + AppIcon.icns) from images/STOP.png.
# Requires macOS sips and iconutil. Usually run via: sh scripts/regenerate-icons.sh
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="$ROOT/safari/Host/Assets.xcassets/AppIcon.appiconset"
ICNS_OUT="$ROOT/safari/Host/AppIcon.icns"
SRC="$ROOT/images/STOP.png"

if [ ! -f "$SRC" ]; then
  echo "Missing source image: $SRC" >&2
  exit 1
fi

mkdir -p "$OUT"
gen() {
  sips -z "$2" "$2" "$SRC" --out "$OUT/$1" >/dev/null
}

gen mac16.png 16
gen mac16@2x.png 32
gen mac32.png 32
gen mac32@2x.png 64
gen mac128.png 128
gen mac128@2x.png 256
gen mac256.png 256
gen mac256@2x.png 512
gen mac512.png 512
gen mac512@2x.png 1024

echo "Wrote Mac AppIcon PNGs in $OUT"

BASE="$(mktemp -d "${TMPDIR:-/tmp}/nytna-appicon.XXXXXX")"
mv "$BASE" "${BASE}.iconset"
ICONSET="${BASE}.iconset"
cleanup() {
  rm -rf "$ICONSET"
}
trap cleanup EXIT

igen() {
  sips -z "$2" "$2" "$SRC" --out "$ICONSET/$1" >/dev/null
}

igen icon_16x16.png 16
igen icon_16x16@2x.png 32
igen icon_32x32.png 32
igen icon_32x32@2x.png 64
igen icon_128x128.png 128
igen icon_128x128@2x.png 256
igen icon_256x256.png 256
igen icon_256x256@2x.png 512
igen icon_512x512.png 512
igen icon_512x512@2x.png 1024

iconutil -c icns "$ICONSET" -o "$ICNS_OUT"
echo "Wrote $ICNS_OUT"
