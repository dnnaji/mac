#!/usr/bin/env fish
# 05_dotfiles.fish - Install dotfiles via symlinks
# Idempotent: safe to run multiple times

set -l SCRIPT_DIR (dirname (status filename))
set -l DOTFILES_DIR (realpath "$SCRIPT_DIR/../dotfiles" 2>/dev/null)

if test -z "$DOTFILES_DIR"; or not test -d "$DOTFILES_DIR"
    echo "Error: Could not find dotfiles directory"
    exit 1
end

echo "=== Dotfiles Installation ==="
echo "Source: $DOTFILES_DIR"
echo ""

function safe_link --argument-names src dest
    if not test -e "$src"
        echo "· Skipping $dest (source not found)"
        return 0
    end

    if test -L "$dest"
        set -l current_target (readlink "$dest")
        if test "$current_target" = "$src"
            echo "✓ $dest (already linked correctly)"
            return 0
        else
            echo "⚠ $dest linked elsewhere, relinking..."
            rm "$dest"; or return 1
        end
    else if test -e "$dest"
        # Generate unique backup name if .bak already exists
        set -l backup "$dest.bak"
        if test -e "$backup"
            set backup "$dest.bak."(date +%Y%m%d%H%M%S)
        end
        echo "⚠ $dest exists, backing up to $backup"
        mv "$dest" "$backup"; or return 1
    end

    mkdir -p (dirname "$dest"); or return 1
    ln -s "$src" "$dest"; or return 1
    echo "✓ Linked $dest → $src"
end

# Git config
safe_link "$DOTFILES_DIR/gitconfig" ~/.gitconfig

# npm config
safe_link "$DOTFILES_DIR/npmrc" ~/.npmrc

# Starship prompt config
safe_link "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml

# Ghostty terminal config
safe_link "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config

# Aerospace window manager config
safe_link "$DOTFILES_DIR/aerospace/aerospace.toml" ~/.config/aerospace/aerospace.toml

# Fish functions (copy instead of symlink for flexibility)
echo ""
echo "=== Fish Functions ==="
mkdir -p ~/.config/fish/functions ~/.config/fish/conf.d
if test -d "$DOTFILES_DIR/fish/functions"
    for func in "$DOTFILES_DIR"/fish/functions/*.fish
        if test -f "$func"
            set -l fname (basename "$func")
            set -l dest ~/.config/fish/functions/$fname

            cp "$func" "$dest"
            echo "✓ $fname"
        end
    end
else
    echo "· No fish functions to install"
end

# Fish conf.d snippets
echo ""
echo "=== Fish conf.d ==="
if test -d "$DOTFILES_DIR/fish/conf.d"
    for conf in "$DOTFILES_DIR"/fish/conf.d/*.fish
        if test -f "$conf"
            set -l fname (basename "$conf")
            set -l dest ~/.config/fish/conf.d/$fname

            cp "$conf" "$dest"
            echo "✓ $fname"
        end
    end
else
    echo "· No conf.d files to install"
end

# =============================================================================
# Private Overlay (optional - cloned from mac-private repo)
# =============================================================================
set -l PRIVATE_DIR (realpath "$SCRIPT_DIR/../private" 2>/dev/null)

if test -d "$PRIVATE_DIR"
    echo ""
    echo "=== Private Overlay ==="
    echo "Source: $PRIVATE_DIR"

    # Private git config (user, signingkey, etc.)
    if test -f "$PRIVATE_DIR/gitconfig.local"
        cp "$PRIVATE_DIR/gitconfig.local" ~/.gitconfig.local
        chmod 600 ~/.gitconfig.local
        echo "✓ gitconfig.local"
    end

    # Private SSH config
    if test -f "$PRIVATE_DIR/ssh/config"
        mkdir -p ~/.ssh
        cp "$PRIVATE_DIR/ssh/config" ~/.ssh/config
        chmod 600 ~/.ssh/config
        echo "✓ ssh/config"
    end

    # Private CLAUDE.md (symlink to ~/i/private)
    if test -f "$PRIVATE_DIR/CLAUDE.md"
        ln -sf "$PRIVATE_DIR/CLAUDE.md" ~/CLAUDE.md
        echo "✓ CLAUDE.md → $PRIVATE_DIR/CLAUDE.md"
    else
        echo "· $PRIVATE_DIR/CLAUDE.md not found (optional)"
    end

    # Private fish functions
    if test -d "$PRIVATE_DIR/fish/functions"
        for func in "$PRIVATE_DIR"/fish/functions/*.fish
            if test -f "$func"
                set -l fname (basename "$func")
                cp "$func" ~/.config/fish/functions/$fname
                echo "✓ $fname (private)"
            end
        end
    end

    # Private fish conf.d
    if test -d "$PRIVATE_DIR/fish/conf.d"
        for conf in "$PRIVATE_DIR"/fish/conf.d/*.fish
            if test -f "$conf"
                set -l fname (basename "$conf")
                cp "$conf" ~/.config/fish/conf.d/$fname
                echo "✓ $fname (private)"
            end
        end
    end
else
    echo ""
    echo "· No private overlay found (clone mac-private into private/)"
end

echo ""
echo "Dotfiles installation complete."
