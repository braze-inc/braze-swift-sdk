#! /bin/bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

# This scripts is embedded in the generated DocC documentation website directory. It allows to serve
# the DocC documentation using the python3 http.server module.

# Get the www website / script directory
www="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Hosting base path is the first argument or default to `braze-swift-sdk`
hostingBasePath="${1:-braze-swift-sdk}"

# Create a symbolic link from the `braze-swift-sdk` directory to the website directory
ln -sfn "$www" "$www/$hostingBasePath"

# Serve the documentation
echo "Serving documentation at http://localhost:8000/$hostingBasePath"
echo "- Killing process on port 8000 if any"
lsof -i :8000 | awk 'NR>1 {print $2}' | xargs kill -9 || true

echo "- Press Ctrl+C to stop the server"
echo ""
python3 -m http.server --directory "$www" 8000
