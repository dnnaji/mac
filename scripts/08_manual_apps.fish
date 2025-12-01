#!/usr/bin/env fish
# 08_manual_apps.fish - Install apps not available via Homebrew
# Idempotent: safe to run multiple times

echo "=== Manual App Installs ==="
echo ""

# Ice - Menu bar manager (Bartender alternative)
# Homebrew has older version; Tahoe requires latest from GitHub
# https://github.com/jordanbaird/Ice
if test -d /Applications/Ice.app
    echo "· Ice already installed"
else
    echo "Installing Ice (menu bar manager)..."
    set -l ice_url (curl -sL "https://api.github.com/repos/jordanbaird/Ice/releases" | jq -r '.[0].assets[] | select(.name == "Ice.zip") | .browser_download_url')

    if test -n "$ice_url"
        curl -L -o /tmp/Ice.zip "$ice_url"
        unzip -o /tmp/Ice.zip -d /tmp/Ice_app
        mv /tmp/Ice_app/Ice.app /Applications/
        rm -rf /tmp/Ice.zip /tmp/Ice_app
        echo "✓ Ice installed"
    else
        echo "ERROR: Could not fetch Ice download URL"
    end
end

# Wispr Flow - AI Voice Dictation
# No Homebrew cask; download from official site
# https://wisprflow.ai
if test -d "/Applications/Wispr Flow.app"
    echo "· Wispr Flow already installed"
else
    echo "Installing Wispr Flow (AI voice dictation)..."
    curl -L -o /tmp/WisprFlow.dmg "https://dl.wisprflow.ai/mac-apple/latest"
    hdiutil attach /tmp/WisprFlow.dmg -quiet
    # Volume name includes version, find it dynamically
    set -l vol (ls -d /Volumes/Flow-* 2>/dev/null | head -1)
    if test -n "$vol" -a -d "$vol/Wispr Flow.app"
        cp -R "$vol/Wispr Flow.app" /Applications/
        hdiutil detach "$vol" -quiet
        rm /tmp/WisprFlow.dmg
        echo "✓ Wispr Flow installed"
    else
        echo "ERROR: Could not find Wispr Flow in mounted volume"
        hdiutil detach "$vol" -quiet 2>/dev/null
    end
end

echo ""
echo "=== Post-Install Steps ==="
echo "Ice: System Settings → Privacy & Security → Accessibility → Enable Ice"
echo "Wispr Flow: Grant Microphone & Accessibility permissions"
