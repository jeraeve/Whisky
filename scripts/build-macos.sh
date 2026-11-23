#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! xcodebuild -version >/dev/null 2>&1; then
    echo 'Xcode complet est requis. Installez-le et sélectionnez-le avec xcode-select.' >&2
    exit 1
fi
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"
if ! command -v swiftlint >/dev/null 2>&1; then
    echo 'SwiftLint est requis par le projet : brew install swiftlint' >&2
    exit 1
fi
swift test --package-path WhiskyKit
xcodebuild -project Whisky.xcodeproj -scheme Whisky \
    -configuration Release -destination 'generic/platform=macOS' \
    -derivedDataPath build/DerivedData \
    MACOSX_DEPLOYMENT_TARGET=14.0 ARCHS=arm64 \
    CODE_SIGNING_ALLOWED=NO build
mkdir -p build/artifacts
ditto -c -k --sequesterRsrc --keepParent \
    build/DerivedData/Build/Products/Release/Whisky.app \
    build/artifacts/Whisky-unsigned.zip
