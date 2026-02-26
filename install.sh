#!/usr/bin/env bash
# install.sh — Automated installer for Copilot for Xcode
# https://github.com/intitni/CopilotForXcode
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/intitni/CopilotForXcode/main/install.sh | bash
# or, if you have already cloned the repo:
#   bash install.sh

set -euo pipefail

# ── Constants ─────────────────────────────────────────────────────────────────
MIN_MACOS_MAJOR=13

# ── Colour helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
step()    { echo -e "\n${BOLD}▶ $*${NC}"; }
manual()  { echo -e "${YELLOW}  ➤ MANUAL STEP REQUIRED:${NC} $*"; }

# ── Step 0: Platform check ────────────────────────────────────────────────────
step "Checking platform"

if [[ "$(uname)" != "Darwin" ]]; then
    error "Copilot for Xcode requires macOS. This system is $(uname)."
    exit 1
fi

MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)
MACOS_MINOR=$(echo "$MACOS_VERSION" | cut -d. -f2)

if [[ "$MACOS_MAJOR" -lt $MIN_MACOS_MAJOR ]]; then
    error "macOS $MIN_MACOS_MAJOR (Ventura) or later is required. Found: $MACOS_VERSION"
    exit 1
fi

success "macOS $MACOS_VERSION detected (requirement: $MIN_MACOS_MAJOR+)"

# ── Step 1: Install via Homebrew (preferred) ──────────────────────────────────
step "Installing Copilot for Xcode"

if command -v brew &>/dev/null; then
    info "Homebrew found. Installing via 'brew install --cask copilot-for-xcode' ..."
    if brew install --cask copilot-for-xcode; then
        success "Copilot for Xcode installed via Homebrew."
    else
        error "Homebrew installation failed."
        echo
        echo "  Fallback — Download manually:"
        echo "    https://github.com/intitni/CopilotForXcode/releases/latest"
        echo "    Then move 'Copilot for Xcode.app' into /Applications."
        echo
        read -rp "  Press ENTER once the app is in /Applications to continue ..."
    fi
else
    warn "Homebrew is not installed."
    echo
    echo "  Option A — Install Homebrew first, then re-run this script:"
    echo "    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo
    echo "  Option B — Download manually:"
    echo "    https://github.com/intitni/CopilotForXcode/releases/latest"
    echo "    Then move 'Copilot for Xcode.app' into /Applications."
    echo
    read -rp "  Press ENTER once the app is in /Applications to continue ..."
fi

# ── Step 2: Verify the app exists and open it ─────────────────────────────────
step "Opening Copilot for Xcode"

APP_PATH="/Applications/Copilot for Xcode.app"

if [[ ! -d "$APP_PATH" ]]; then
    error "Could not find '$APP_PATH'. Make sure the app is in the Applications folder."
    exit 1
fi

open "$APP_PATH"
success "Copilot for Xcode launched. It will register its background service automatically."

# ── Step 3: Node.js check ─────────────────────────────────────────────────────
step "Checking Node.js (required for GitHub Copilot suggestions)"

if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    success "Node.js $NODE_VERSION found at $(command -v node)"
else
    warn "Node.js was not found in PATH."
    echo
    echo "  Node.js is required to use GitHub Copilot suggestions."
    echo "  Install it from https://nodejs.org/ or via Homebrew:"
    echo "    brew install node"
fi

# ── Step 4: Manual steps summary ─────────────────────────────────────────────
step "Manual steps required after installation"

MACOS_DISPLAY="macOS $MACOS_MAJOR.$MACOS_MINOR"

echo
echo "  The following steps cannot be automated and must be done manually:"
echo

echo "  1. Enable the Xcode Source Editor Extension in System Settings:"
if [[ "$MACOS_MAJOR" -ge 15 ]]; then
    manual "System Settings → General → Login Items & Extensions → Xcode Source Editor → tick 'Copilot for Xcode'"
elif [[ "$MACOS_MAJOR" -eq 14 ]]; then
    manual "System Settings → Privacy & Security → Extensions → Xcode Source Editor → tick 'Copilot'"
else
    manual "System Preferences → Extensions → tick 'Copilot'"
fi

echo
echo "  2. Grant Accessibility API permission:"
manual "System Settings → Privacy & Security → Accessibility → add 'CopilotForXcodeExtensionService.app'"
echo "     (Click 'Reveal Extension App in Finder' inside Copilot for Xcode.app to locate it.)"

echo
echo "  3. Sign in to GitHub Copilot inside the app:"
manual "Open Copilot for Xcode → Service → GitHub Copilot → Install → Sign In"

echo
echo "  4. (Optional) Set up key bindings in Xcode:"
manual "Xcode → Settings → Key Bindings → search 'copilot'"

echo
success "Installation complete! Follow the manual steps above, then restart Xcode."
echo
echo -e "  ${CYAN}Full guide:${NC} https://github.com/intitni/CopilotForXcode#installation-and-setup"
echo -e "  ${CYAN}Guía en español:${NC} https://github.com/intitni/CopilotForXcode/blob/main/INSTALL_ES.md"
