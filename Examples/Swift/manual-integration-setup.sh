#! /bin/bash

# Usage: ./manual-integration-setup.sh
# 
# This script downloads the Braze Swift SDK prebuilt archive and extracts it to 
# the 'braze-swift-sdk-prebuilt' directory.
# 
# The 'Example-Manual.xcodeproj' project targets are configured to:
# - link against the XCFrameworks in the 'braze-swift-sdk-prebuilt' directory.
# - copy the resource bundles from the 'braze-swift-sdk-prebuilt' directory.

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Verify that the script is being run from the script directory
if [ ! -f "manual-integration-setup.sh" ]; then
  echo "ERROR: This script must be run from the script directory."
  exit 1
fi

# Constants
url="https://github.com/braze-inc/braze-swift-sdk/releases/download/6.2.0/braze-swift-sdk-prebuilt.zip"

echo "→" "Cleaning up"
rm -rf braze-swift-sdk-prebuilt
rm -rf braze-swift-sdk-prebuilt.zip

echo "→" "Downloading braze-swift-sdk-prebuilt.zip"
echo "  ∙" "URL: $url"
curl -s -L -o braze-swift-sdk-prebuilt.zip "$url"

echo "→" "Extracting braze-swift-sdk-prebuilt.zip"
unzip -q braze-swift-sdk-prebuilt.zip -d braze-swift-sdk-prebuilt

echo "→" "Removing braze-swift-sdk-prebuilt.zip"
rm braze-swift-sdk-prebuilt.zip
