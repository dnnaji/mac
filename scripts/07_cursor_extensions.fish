#!/usr/bin/env fish
# 07_cursor_extensions.fish - Install Cursor extensions
# Idempotent: safe to run multiple times (skips already installed)

if not command -q cursor
    echo "ERROR: Cursor not installed."
    echo "Install via: brew install --cask cursor"
    exit 1
end

set -l EXTENSIONS_FILE (dirname (status filename))/../dotfiles/cursor/extensions.txt

if not test -f $EXTENSIONS_FILE
    echo "ERROR: Extensions file not found at $EXTENSIONS_FILE"
    exit 1
end

echo "=== Installing Cursor Extensions ==="
echo ""

# Get currently installed extensions
set -l installed (cursor --list-extensions 2>/dev/null)

set -l count 0
set -l skipped 0

# Read file line-by-line (not token-by-token)
while read -l line
    set line (string trim $line)
    # Skip comments and empty lines
    if test -z "$line"; or string match -q '#*' "$line"
        continue
    end

    set -l ext $line

    # Check if already installed
    if contains $ext $installed
        echo "· $ext (already installed)"
        set skipped (math $skipped + 1)
    else
        echo "Installing $ext..."
        cursor --install-extension $ext --force 2>/dev/null
        if test $status -eq 0
            echo "✓ $ext"
            set count (math $count + 1)
        else
            echo "✗ $ext (failed)"
        end
    end
end < "$EXTENSIONS_FILE"

echo ""
echo "=== Cursor Extensions Complete ==="
echo "Installed: $count new | Skipped: $skipped (already installed)"
