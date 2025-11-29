#!/usr/bin/env fish
# 06_macos_defaults.fish - Configure macOS system preferences
# Idempotent: safe to run multiple times
# Many changes require logout/restart to take effect

echo "=== Configuring macOS Defaults ==="
echo ""

# =============================================================================
# Dock
# =============================================================================
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

# =============================================================================
# Finder
# =============================================================================
echo "Configuring Finder..."

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

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
# Desktop & Stage Manager
# =============================================================================
echo "Configuring Desktop..."

# Click wallpaper to reveal desktop only in Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Don't show icons on desktop (optional - uncomment if wanted)
# defaults write com.apple.finder CreateDesktop -bool false

echo "✓ Desktop configured"

# =============================================================================
# Keyboard
# =============================================================================
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

# =============================================================================
# Trackpad
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
# Screenshots
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

# =============================================================================
# Misc
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

# Disable the "Are you sure you want to open this application?" dialog
# Keeping LSQuarantine enabled - the "downloaded from internet" prompt is a valuable security layer

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
