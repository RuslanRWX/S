#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${1:-$HOME/.local/bin}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.S"

echo "Installing S..."
echo "  Target: $INSTALL_DIR/S"

mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"

cp "$SCRIPT_DIR/S" "$INSTALL_DIR/S"
chmod +x "$INSTALL_DIR/S"

# Install Python dependencies
echo "Installing Python dependencies..."
if python3 -c "import yaml" &>/dev/null; then
    echo "  PyYAML already installed."
elif command -v apt-get &>/dev/null && apt-get install -y python3-yaml &>/dev/null; then
    echo "  Installed PyYAML via apt."
elif pip3 install --quiet --user pyyaml 2>/dev/null; then
    echo "  Installed PyYAML via pip."
elif pip3 install --quiet --user --break-system-packages pyyaml 2>/dev/null; then
    echo "  Installed PyYAML via pip (--break-system-packages)."
elif command -v pipx &>/dev/null; then
    echo "  Warning: could not install PyYAML automatically."
    echo "  Try: pipx inject S pyyaml  or  sudo apt install python3-yaml"
else
    echo "  Warning: could not install PyYAML automatically."
    echo "  Try: sudo apt install python3-yaml"
fi

echo "Done."
echo ""

# Check PATH
if ! printf '%s\n' "${PATH//:/$'\n'}" | grep -qx "$INSTALL_DIR"; then
    echo "Note: $INSTALL_DIR is not in your PATH."
    echo "Add to ~/.bashrc or ~/.zshrc:"
    echo ""
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
    echo ""
fi

echo "Get started:"
echo "  S config --name myenv --inventory /path/to/inventory.yml"
echo "  S list env"
echo "  S env myenv"
echo ""
echo "Optional — set a default env via shell variable:"
echo "  export S_ENV=myenv"
