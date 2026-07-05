#!/usr/bin/env bash
# Exports the Godot project as a web build and zips it for itch.io upload.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GODOT_PROJECT="$REPO_ROOT/mr-astro-junior-3d"
BUILD_DIR="$REPO_ROOT/build"
WEB_DIR="$BUILD_DIR/web"
ZIP_PATH="$BUILD_DIR/mr-astro-junior-3d-web.zip"

# Locate the Godot editor binary.
GODOT_BIN="${GODOT_BIN:-}"
if [[ -z "$GODOT_BIN" ]]; then
  if [[ -x "/Applications/Godot.app/Contents/MacOS/Godot" ]]; then
    GODOT_BIN="/Applications/Godot.app/Contents/MacOS/Godot"
  elif command -v godot >/dev/null 2>&1; then
    GODOT_BIN="godot"
  else
    echo "ERROR: Godot editor not found. Set GODOT_BIN or add 'godot' to PATH." >&2
    exit 1
  fi
fi

# Spinner that runs while a long command executes.
# Usage: _start_spinner "label"; PID=$!; <command>; _stop_spinner $?
SPINNER_FRAMES=( "|" "/" "-" "\\" )
SPINNER_INDEX=0

_start_spinner() {
  local label="$1"
  _SPINNER_LABEL="$label"
  _SPINNER_PID=""
  (
    while true; do
      printf "\r\033[K%s... [%s]" "$_SPINNER_LABEL" "${SPINNER_FRAMES[$((SPINNER_INDEX % 4))]}"
      SPINNER_INDEX=$((SPINNER_INDEX + 1))
      sleep 0.1
    done
  ) &
  _SPINNER_PID=$!
}

_stop_spinner() {
  local status=$1
  if [[ -n "${_SPINNER_PID:-}" ]]; then
    kill "$_SPINNER_PID" >/dev/null 2>&1 || true
    wait "$_SPINNER_PID" >/dev/null 2>&1 || true
    _SPINNER_PID=""
  fi
  printf "\r\033[K"
  if [[ "$status" -eq 0 ]]; then
    printf "%s... done\n" "$_SPINNER_LABEL"
  else
    printf "%s... FAILED\n" "$_SPINNER_LABEL"
  fi
}

echo "Using Godot: $GODOT_BIN"
"$GODOT_BIN" --version

# Clean the entire build folder before exporting.
rm -rf "$BUILD_DIR"
mkdir -p "$WEB_DIR"

_start_spinner "Exporting Web release"
if "$GODOT_BIN" --headless --export-release "Web" \
    --path "$GODOT_PROJECT" \
    "$WEB_DIR/index.html"; then
  _stop_spinner 0
else
  _stop_spinner $?
  echo "ERROR: Godot export failed." >&2
  exit 1
fi

if [[ ! -f "$WEB_DIR/index.html" ]]; then
  echo "ERROR: Export failed - index.html not produced." >&2
  exit 1
fi

_start_spinner "Packaging zip"
if ( cd "$BUILD_DIR" && zip -rq "$(basename "$ZIP_PATH")" "$(basename "$WEB_DIR")" ); then
  _stop_spinner 0
else
  _stop_spinner $?
  echo "ERROR: zip failed." >&2
  exit 1
fi

echo "Done: $ZIP_PATH"
ls -lh "$ZIP_PATH"