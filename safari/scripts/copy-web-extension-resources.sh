#!/bin/sh
# Copy shared web-extension assets from the repo root into the built .appex Resources.
# Xcode: Run Script phase on the Safari Web Extension target, before Copy Bundle Resources.
# Optional: export NYTNA_WEBROOT="/absolute/path/to/NYTimesCleaner" if the .xcodeproj is not under safari/.
set -eu
WEBROOT="${NYTNA_WEBROOT:-${PROJECT_DIR}/..}"
WRAPPER="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"
OUT="${WRAPPER}/Contents/Resources"
mkdir -p "${OUT}"
for f in manifest.json background.js; do
  if [ -f "${WEBROOT}/${f}" ]; then
    cp "${WEBROOT}/${f}" "${OUT}/"
  fi
done
mkdir -p "${OUT}/sites"
if [ -d "${WEBROOT}/sites" ]; then
  rsync -a "${WEBROOT}/sites/" "${OUT}/sites/"
fi
if [ -d "${WEBROOT}/icons" ]; then
  mkdir -p "${OUT}/icons"
  rsync -a "${WEBROOT}/icons/" "${OUT}/icons/"
fi
