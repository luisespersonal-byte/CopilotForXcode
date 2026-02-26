#!/usr/bin/env bash
# install.sh — Install Copilot for Xcode on macOS
#
# Usage:
#   bash install.sh
#
# The script will:
#   1. Verify prerequisites (macOS 12+, Xcode installed)
#   2. Install the app via Homebrew cask when available, or download the
#      latest release from GitHub otherwise
#   3. Launch the app once so it registers its background launch agent
#   4. Print step-by-step instructions for the manual post-install tasks
#      (enabling the Source Editor Extension and granting Accessibility access)

set -euo pipefail

# ── color helpers ─────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[info]${RESET}  $*"; }
success() { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET}  $*"; }
error()   { echo -e "${RED}[error]${RESET} $*" >&2; }
step()    { echo -e "\n${BOLD}$*${RESET}"; }

# ── constants ─────────────────────────────────────────────────────────────────
APP_NAME="Copilot for Xcode"
APP_BUNDLE="Copilot for Xcode.app"
APP_PATH="/Applications/${APP_BUNDLE}"
BREW_CASK="copilot-for-xcode"
GITHUB_RELEASES="https://api.github.com/repos/intitni/CopilotForXcode/releases/latest"
MIN_MACOS_MAJOR=12   # macOS Monterey

# ── prerequisite checks ───────────────────────────────────────────────────────
step "1/4  Checking prerequisites"

# macOS version
os_version=$(sw_vers -productVersion 2>/dev/null || echo "0.0")
os_major=$(echo "$os_version" | cut -d. -f1)
if [[ "$os_major" -lt "$MIN_MACOS_MAJOR" ]]; then
    error "${APP_NAME} requires macOS Monterey (12) or later."
    error "Current version: ${os_version}"
    exit 1
fi
success "macOS ${os_version} — compatible"

# Xcode installed (look for the app bundle or xcode-select path)
if ! xcode-select -p &>/dev/null || [[ ! -d "$(xcode-select -p)" ]]; then
    error "Xcode does not appear to be installed."
    error "Install Xcode from the Mac App Store, then re-run this script."
    exit 1
fi
success "Xcode found at $(xcode-select -p)"

# ── installation ──────────────────────────────────────────────────────────────
step "2/4  Installing ${APP_NAME}"

if [[ -d "$APP_PATH" ]]; then
    success "${APP_NAME} is already installed at ${APP_PATH}"
elif command -v brew &>/dev/null; then
    info "Homebrew detected — installing via cask …"
    brew install --cask "$BREW_CASK"
    success "Installed via Homebrew"
else
    warn "Homebrew not found — falling back to manual download."

    # Fetch the download URL of the latest release asset
    info "Fetching latest release information from GitHub …"
    asset_url=$(
        curl -fsSL "$GITHUB_RELEASES" \
        | grep '"browser_download_url"' \
        | grep '\.zip"' \
        | head -1 \
        | sed 's/.*"browser_download_url": "\(.*\)"/\1/'
    )

    if [[ -z "$asset_url" ]]; then
        error "Could not determine the download URL from GitHub."
        error "Please download ${APP_NAME} manually from:"
        error "  https://github.com/intitni/CopilotForXcode/releases"
        exit 1
    fi

    tmp_dir=$(mktemp -d)
    zip_path="${tmp_dir}/CopilotForXcode.zip"

    info "Downloading ${APP_NAME} …"
    curl -fL --progress-bar "$asset_url" -o "$zip_path"

    info "Extracting …"
    unzip -q "$zip_path" -d "$tmp_dir"

    extracted_app=$(find "$tmp_dir" -maxdepth 2 -name "*.app" | head -1)
    if [[ -z "$extracted_app" ]]; then
        error "Could not find the .app bundle inside the downloaded archive."
        rm -rf "$tmp_dir"
        exit 1
    fi

    info "Moving ${APP_BUNDLE} to /Applications …"
    # Remove a stale copy if present (handles re-install after failed attempt)
    [[ -d "$APP_PATH" ]] && rm -rf "$APP_PATH"
    cp -R "$extracted_app" "$APP_PATH"
    rm -rf "$tmp_dir"

    success "Installed to ${APP_PATH}"
fi

# ── launch the app once ───────────────────────────────────────────────────────
step "3/4  Launching ${APP_NAME}"

info "Opening ${APP_NAME} to register its background service …"
open -a "$APP_PATH"

# Give the app a moment to start before we print the next instructions
sleep 3
success "${APP_NAME} has been opened"

# ── post-install instructions ─────────────────────────────────────────────────
step "4/4  Post-install steps (manual)"

os_minor=$(echo "$os_version" | cut -d. -f2)

echo ""
echo -e "${BOLD}A) Enable the Source Editor Extension${RESET}"
if [[ "$os_major" -ge 15 ]]; then
    echo "   Open: System Settings → General → Login Items & Extensions"
    echo "   Click 'Xcode Source Editor' and tick 'Copilot for Xcode'."
elif [[ "$os_major" -eq 14 ]]; then
    echo "   Open: System Settings → Privacy & Security → Extensions"
    echo "   Click 'Xcode Source Editor' and tick 'Copilot'."
else
    echo "   Open: System Preferences → Extensions"
    echo "   Tick 'Copilot' under 'Xcode Source Editor'."
fi

echo ""
echo -e "${BOLD}B) Grant Accessibility permission${RESET}"
echo "   Open: System Settings → Privacy & Security → Accessibility"
echo "   Add 'CopilotForXcodeExtensionService.app' to the list."
echo "   (Click 'Reveal Extension App in Finder' inside ${APP_NAME} to locate it.)"

echo ""
echo -e "${BOLD}C) Set up your AI provider${RESET}"
echo "   • GitHub Copilot: navigate to 'Service → GitHub Copilot' in the host app,"
echo "     click 'Install' then 'Sign In'."
echo "   • Codeium: navigate to 'Service → Codeium', click 'Install' then 'Sign In'."
echo "   • OpenAI / other chat models: navigate to 'Service → Chat Model'."

echo ""
echo -e "${BOLD}D) (Optional) Set up key bindings in Xcode${RESET}"
echo "   Xcode → Settings → Key Bindings → search for 'copilot'"

echo ""
success "Installation complete! Enjoy ${APP_NAME} 🎉"
