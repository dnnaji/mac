#!/usr/bin/env fish
# 06_macos_defaults.fish - Configure macOS system preferences
# Idempotent: safe to run multiple times
# Many changes require logout/restart to take effect
#
# Usage:
#   ./06_macos_defaults.fish          # Interactive mode (prompts for Dock, Keyboard, Security)
#   ./06_macos_defaults.fish --yes    # Auto-yes all prompts (for CI/automation)
#   ./06_macos_defaults.fish -y       # Same as --yes

# =============================================================================
# Argument Parsing
# =============================================================================
argparse 'y/yes' 'h/help' -- $argv
or exit 1

if set -q _flag_help
    echo "Usage: 06_macos_defaults.fish [-y|--yes] [-h|--help]"
    echo ""
    echo "Options:"
    echo "  -y, --yes    Skip confirmation prompts (assume yes)"
    echo "  -h, --help   Show this help message"
    echo ""
    echo "Sections with prompts: Dock, Keyboard, Security"
    echo "Auto-applied sections: Finder, Desktop, Trackpad, Screenshots, Misc"
    exit 0
end

# =============================================================================
# Helper Functions
# =============================================================================

# Confirm prompt with automation support
# Returns 0 (true) for yes, 1 (false) for no
function confirm -a prompt_text
    # Auto-yes if --yes flag OR CI/NONINTERACTIVE env
    if set -q _flag_yes; or set -q CI; or set -q NONINTERACTIVE
        echo "$prompt_text [Y/n] (auto-yes)"
        return 0
    end

    read -l -P "$prompt_text [Y/n] " response
    # Default to yes if empty, or if starts with y/Y
    test -z "$response"; or string match -qi 'y*' $response
end

echo "=== Configuring macOS Defaults ==="
echo ""

# =============================================================================
# Dock (prompted)
# =============================================================================
if confirm "Configure Dock (auto-hide, icon size)?"
    echo "Configuring Dock..."

    # Auto-hide the Dock
    defaults write com.apple.dock autohide -bool true

    # Remove the auto-hide delay
    defaults write com.apple.dock autohide-delay -float 0

    # Speed up the animation when hiding/showing the Dock
    defaults write com.apple.dock autohide-time-modifier -float 0.3

    # Don't animate opening applications
    defaults write com.apple.dock launchanim -bool false

    # Don't show recent applications
    defaults write com.apple.dock show-recents -bool false

    # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true

    # Set Dock icon size
    defaults write com.apple.dock tilesize -int 48

    # Minimize windows into their application's icon
    defaults write com.apple.dock minimize-to-application -bool true

    echo "✓ Dock configured"
else
    echo "· Skipping Dock"
end

# =============================================================================
# Finder (auto-applied)
# =============================================================================
echo "Configuring Finder..."

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# New Finder windows open to home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Show hidden files (optional - uncomment if wanted)
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo "✓ Finder configured"

# =============================================================================
# Desktop & Stage Manager (auto-applied)
# =============================================================================
echo "Configuring Desktop..."

# Click wallpaper to reveal desktop only in Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Don't show icons on desktop (optional - uncomment if wanted)
# defaults write com.apple.finder CreateDesktop -bool false

echo "✓ Desktop configured"

# =============================================================================
# Mission Control / Spaces (auto-applied, for Aerospace compatibility)
# =============================================================================
echo "Configuring Mission Control..."

# Group windows by app in Mission Control (helps with Aerospace visibility)
defaults write com.apple.dock expose-group-apps -bool true

# Ensure displays have separate Spaces (required for multi-monitor tiling WMs)
defaults write com.apple.spaces spans-displays -bool false

# Don't automatically rearrange Spaces based on recent use
defaults write com.apple.dock mru-spaces -bool false

# Disable Sequoia's native window tiling (conflicts with Aerospace)
# This prevents drag-to-edge window snapping
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false

echo "✓ Mission Control configured (for Aerospace)"

# =============================================================================
# Keyboard (prompted)
# =============================================================================
if confirm "Configure Keyboard (fast repeat, no autocorrect)?"
    echo "Configuring Keyboard..."

    # Fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2

    # Short delay until key repeat
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable auto-capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable smart dashes
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable smart quotes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable auto period substitution
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    echo "✓ Keyboard configured"
else
    echo "· Skipping Keyboard"
end

# =============================================================================
# Trackpad (auto-applied)
# =============================================================================
echo "Configuring Trackpad..."

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three-finger drag (optional - uncomment if wanted)
# defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

echo "✓ Trackpad configured"

# =============================================================================
# Screenshots (auto-applied)
# =============================================================================
echo "Configuring Screenshots..."

# Save screenshots to ~/Pictures/Screenshots
set -l screenshot_dir ~/Pictures/Screenshots
mkdir -p $screenshot_dir
defaults write com.apple.screencapture location -string $screenshot_dir

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

echo "✓ Screenshots configured (saving to ~/Pictures/Screenshots)"

# Restart SystemUIServer to apply screenshot settings
killall SystemUIServer 2>/dev/null

# =============================================================================
# Security (prompted, requires sudo)
# =============================================================================
if confirm "Configure Security (firewall, guest account)?"
    set -l security_can_run 1

    # Validate sudo availability only when Security is selected
    if not sudo -n true 2>/dev/null
        echo "Elevated privileges are required for Security settings."

        # In interactive mode, request sudo credentials instead of exiting early
        if not set -q _flag_yes; and not set -q CI; and not set -q NONINTERACTIVE
            echo "Requesting sudo credentials..."
            if not sudo -v
                echo "Skipping Security because sudo authentication failed."
                set security_can_run 0
            end
        else
            echo "Skipping Security because sudo credentials are not cached in non-interactive mode."
            set security_can_run 0
        end
    end

    if test "$security_can_run" -eq 1
        echo "Configuring Security..."

        # Disable guest account
        sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

        # Enable firewall
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

        # Enable stealth mode (no response to pings/port scans)
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

        # Enable firewall logging
        sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

        # Disable Safari auto-open "safe" downloads
        defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

        # Secure keyboard entry in Terminal (prevents keyloggers)
        defaults write com.apple.Terminal SecureKeyboardEntry -bool true

        # Require password immediately after sleep/screensaver
        defaults write com.apple.screensaver askForPassword -int 1
        defaults write com.apple.screensaver askForPasswordDelay -int 0

        echo "✓ Security configured"
    else
        echo "· Skipping Security"
    end
else
    echo "· Skipping Security"
end

# =============================================================================
# Misc (auto-applied)
# =============================================================================
echo "Configuring Misc settings..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Note: LSQuarantine ("Are you sure you want to open this application?") is kept enabled
# This warning for downloaded apps is a valuable security layer

echo "✓ Misc settings configured"

# =============================================================================
# Apply Changes
# =============================================================================
echo ""
echo "Restarting affected apps..."

# Restart Dock and Finder to apply changes
killall Dock 2>/dev/null
killall Finder 2>/dev/null

echo ""
echo "=== macOS Defaults Configuration Complete ==="
echo ""
echo "Note: Some changes require logout or restart to take full effect."
echo "Recommended: Log out and back in."
