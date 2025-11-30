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

echo ""
echo "=== Post-Install Steps ==="
echo "Ice: System Settings → Privacy & Security → Accessibility → Enable Ice"
