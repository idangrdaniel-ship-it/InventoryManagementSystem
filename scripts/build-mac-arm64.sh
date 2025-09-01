#!/usr/bin/env bash
set -euo pipefail

# Package InventoryManagement as a macOS Apple Silicon app bundle and DMG.
# Requires JDK 17+ with jpackage installed on an Apple Silicon macOS machine.

APP_NAME="InventoryManagement"
MAIN_JAR="InventoryManagement.jar"
DIST_DIR="$(dirname "$0")/../dist"
OUTPUT_DIR="$(dirname "$0")/../out/mac"
RUNTIME_DIR="$OUTPUT_DIR/runtime"

mkdir -p "$OUTPUT_DIR"

# Create a trimmed runtime image for Apple Silicon.
jlink \
  --module-path "$JAVA_HOME/jmods" \
  --add-modules java.desktop,java.sql \
  --output "$RUNTIME_DIR" \
  --strip-debug \
  --no-man-pages \
  --no-header-files \
  --compress=2

# Package the application as a DMG targeting arm64.
jpackage \
  --type dmg \
  --name "$APP_NAME" \
  --input "$DIST_DIR" \
  --main-jar "$MAIN_JAR" \
  --runtime-image "$RUNTIME_DIR" \
  --dest "$OUTPUT_DIR" \
  --target-arch aarch64 \
  "$@"
