#!/usr/bin/env fish
# 05_dotfiles.fish - Install dotfiles via symlinks
# Idempotent: safe to run multiple times

set -l SCRIPT_DIR (dirname (status filename))
set -l DOTFILES_DIR (realpath $SCRIPT_DIR/../dotfiles)

echo "=== Dotfiles Installation ==="
echo "Source: $DOTFILES_DIR"
echo ""

function safe_link
    set -l src $argv[1]
    set -l dest $argv[2]

    if not test -e $src
        echo "· Skipping $dest (source not found)"
        return 0
    end

    if test -L $dest
        set -l current_target (readlink $dest)
        if test "$current_target" = "$src"
            echo "✓ $dest (already linked correctly)"
            return 0
        else
            echo "⚠ $dest linked elsewhere, relinking..."
            rm $dest
        end
    else if test -e $dest
        echo "⚠ $dest exists, backing up to $dest.bak"
        mv $dest $dest.bak
    end

    mkdir -p (dirname $dest)
    ln -s $src $dest
    echo "✓ Linked $dest → $src"
end

# Git config
safe_link $DOTFILES_DIR/gitconfig ~/.gitconfig

# npm config
safe_link $DOTFILES_DIR/npmrc ~/.npmrc

# Starship prompt config
safe_link $DOTFILES_DIR/starship.toml ~/.config/starship.toml

# Ghostty terminal config
safe_link $DOTFILES_DIR/ghostty/config ~/.config/ghostty/config

# Aerospace window manager config
safe_link $DOTFILES_DIR/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml

# Fish functions (copy instead of symlink for flexibility)
echo ""
echo "=== Fish Functions ==="
if test -d $DOTFILES_DIR/fish/functions
    for func in $DOTFILES_DIR/fish/functions/*.fish
        if test -f $func
            set -l fname (basename $func)
            set -l dest ~/.config/fish/functions/$fname

            if test -f $dest
                echo "· $fname exists, skipping"
            else
                cp $func $dest
                echo "✓ Copied $fname"
            end
        end
    end
else
    echo "· No fish functions to install"
end

# Fish conf.d snippets
echo ""
echo "=== Fish conf.d ==="
if test -d $DOTFILES_DIR/fish/conf.d
    for conf in $DOTFILES_DIR/fish/conf.d/*.fish
        if test -f $conf
            set -l fname (basename $conf)
            set -l dest ~/.config/fish/conf.d/$fname

            if test -f $dest
                echo "· $fname exists, skipping"
            else
                cp $conf $dest
                echo "✓ Copied $fname"
            end
        end
    end
else
    echo "· No conf.d files to install"
end

echo ""
echo "Dotfiles installation complete."
