#!/usr/bin/env fish
# 02_node_typescript.fish - Node/TypeScript setup via fnm
# Idempotent: safe to run multiple times

if not command -q fnm
    echo "ERROR: fnm not installed."
    echo "Run 01_core_cli.fish first, or: brew install fnm"
    exit 1
end

echo "=== Setting up Node/TypeScript ==="
echo ""

# Create fnm Fish config (idempotent)
set -l fnm_conf ~/.config/fish/conf.d/fnm.fish
if not test -f $fnm_conf
    mkdir -p (dirname $fnm_conf)
    echo '# fnm (Fast Node Manager) - auto-generated' > $fnm_conf
    echo 'fnm env --use-on-cd --shell fish | source' >> $fnm_conf
    echo "✓ Created $fnm_conf"
else
    echo "· $fnm_conf already exists"
end

# Source fnm for this session
fnm env --use-on-cd --shell fish | source

# Install Node LTS if not present
if not command -q node
    echo ""
    echo "Installing Node.js LTS..."
    fnm install --lts
    fnm default lts-latest
    echo "✓ Node LTS installed and set as default"
else
    echo "· Node already installed: "(node -v)
end

# Reload fnm to pick up new Node
fnm env --use-on-cd --shell fish | source

echo ""
echo "=== Node Environment ==="
echo "Node: "(node -v)
echo "npm: "(npm -v)

# Check for bun (installed via Brewfile)
if command -q bun
    echo "Bun: "(bun --version)
end

# Install global TypeScript tools (optional)
echo ""
echo "=== TypeScript Tools ==="

if not command -q tsx
    echo "Installing tsx..."
    npm install -g tsx
    echo "✓ tsx installed"
else
    echo "· tsx already installed"
end

if not command -q tsc
    echo "Installing typescript..."
    npm install -g typescript
    echo "✓ typescript installed"
else
    echo "· typescript already installed: "(tsc --version)
end

# Verify ni (universal package manager, installed via Brewfile)
echo ""
echo "=== Package Manager ==="
if command -q ni
    echo "✓ ni (universal package manager) available"
    echo "  Commands: ni, nr, nlx, nun, nci"
else
    echo "· ni not installed - run: brew install ni"
end

echo ""
echo "Node/TypeScript setup complete."
