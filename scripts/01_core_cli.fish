#!/usr/bin/env fish
# 01_core_cli.fish - Install core CLI tools via Brewfile
# Idempotent: safe to run multiple times

set -l SCRIPT_DIR (dirname (status filename))
set -l ROOT_DIR (dirname $SCRIPT_DIR)

if not command -q brew
    echo "ERROR: Homebrew not installed."
    echo "Run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
end

echo "=== Installing Core CLI Tools ==="
echo ""

# Update Homebrew
echo "Updating Homebrew..."
brew update; or begin
    echo "ERROR: brew update failed"
    exit 1
end

# Verify Brewfile exists
if not test -f "$ROOT_DIR/Brewfile"
    echo "ERROR: Brewfile not found at $ROOT_DIR/Brewfile"
    exit 1
end

# Install from Brewfile
echo ""
echo "Installing from Brewfile..."
brew bundle --file="$ROOT_DIR/Brewfile"

# Check for orphaned packages (not in Brewfile)
set -l orphans (brew bundle cleanup --file="$ROOT_DIR/Brewfile" 2>/dev/null)
if test -n "$orphans"
    echo ""
    echo "=== Orphaned Packages ==="
    echo "These packages are installed but not in Brewfile:"
    echo "$orphans"
    echo ""
    if command -q gum
        if gum confirm "Remove these packages?"
            brew bundle cleanup --file="$ROOT_DIR/Brewfile" --force
            echo "✓ Orphaned packages removed"
        else
            echo "· Skipped cleanup"
        end
    else
        echo "Run 'brew bundle cleanup --force' to remove manually"
    end
end

# Verify key tools
echo ""
echo "=== Verification ==="
set -l required git gh fzf rg fd zoxide bat eza jq yq tmux lazygit starship direnv nvim

set -l missing 0
for cmd in $required
    if command -q $cmd
        echo "✓ $cmd"
    else
        echo "✗ $cmd - MISSING"
        set missing (math $missing + 1)
    end
end

echo ""
if test $missing -eq 0
    echo "All core CLI tools installed successfully."
    exit 0
else
    echo "WARNING: $missing tool(s) missing. Check Brewfile."
    exit 1
end
