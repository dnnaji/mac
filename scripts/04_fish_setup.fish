#!/usr/bin/env fish
# 04_fish_setup.fish - Fish shell configuration
# Idempotent: safe to run multiple times

echo "=== Fish Shell Setup ==="
echo ""

# Ensure Fish config directories exist
mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions ~/.config/fish/completions

# Install Fisher plugin manager if missing
if not functions -q fisher
    echo "Installing Fisher plugin manager..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
    echo "✓ Fisher installed"
else
    echo "· Fisher already installed"
end

# Install essential plugins
echo ""
echo "=== Installing Fish Plugins ==="

set -l plugins \
    "PatrickF1/fzf.fish" \
    "jorgebucaran/autopair.fish" \
    "meaningful-ooo/sponge"

for plugin in $plugins
    set -l plugin_name (string split "/" $plugin)[-1]
    echo "Installing $plugin_name..."
    fisher install $plugin 2>/dev/null
end

# Setup Starship prompt
echo ""
echo "=== Prompt Configuration ==="

set -l starship_conf ~/.config/fish/conf.d/starship.fish
if not test -f $starship_conf
    if command -q starship
        echo 'starship init fish | source' > $starship_conf
        echo "✓ Created Starship config"
    else
        echo "· Starship not installed, skipping"
    end
else
    echo "· Starship config exists"
end

# Setup Zoxide
set -l zoxide_conf ~/.config/fish/conf.d/zoxide.fish
if not test -f $zoxide_conf
    if command -q zoxide
        echo 'zoxide init fish | source' > $zoxide_conf
        echo "✓ Created Zoxide config"
    else
        echo "· Zoxide not installed, skipping"
    end
else
    echo "· Zoxide config exists"
end

# Setup direnv
set -l direnv_conf ~/.config/fish/conf.d/direnv.fish
if not test -f $direnv_conf
    if command -q direnv
        echo 'direnv hook fish | source' > $direnv_conf
        echo "✓ Created direnv config"
    else
        echo "· direnv not installed, skipping"
    end
else
    echo "· direnv config exists"
end

# Vi mode keybindings
echo ""
echo "=== Shell Configuration ==="

# Set vi mode (universal variable, persists)
if not set -q fish_key_bindings; or test "$fish_key_bindings" != "fish_vi_key_bindings"
    set -U fish_key_bindings fish_vi_key_bindings
    echo "✓ Vi key bindings enabled"
else
    echo "· Vi key bindings already set"
end

# Disable greeting
if test -n "$fish_greeting"
    set -U fish_greeting
    echo "✓ Greeting disabled"
else
    echo "· Greeting already disabled"
end

# Brew abbreviations
echo ""
echo "=== Abbreviations ==="
abbr -a bi "brew install" 2>/dev/null
abbr -a bic "brew install --cask" 2>/dev/null
abbr -a bs "brew search" 2>/dev/null
abbr -a binfo "brew info" 2>/dev/null
abbr -a bup "brew update && brew upgrade" 2>/dev/null
echo "✓ Brew abbreviations set (bi, bic, bs, binfo, bup)"

echo ""
echo "Fish setup complete."
echo "Restart your shell or run: exec fish"
