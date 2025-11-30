#!/usr/bin/env fish
# 02b_ai_tools.fish - Install AI CLI tools
# Idempotent: safe to run multiple times

echo "=== AI CLI Tools ==="
echo ""

# Check dependencies
if not command -q brew
    echo "✗ Homebrew not found, skipping cask installs"
    set -l skip_brew 1
end

if not command -q bun
    echo "✗ Bun not found, skipping bun package installs"
    set -l skip_bun 1
end

# Ollama (local LLM runner)
if not set -q skip_brew
    if brew list --cask ollama &>/dev/null
        echo "· Ollama already installed"
    else
        echo "Installing Ollama..."
        brew install --cask ollama; and echo "✓ Ollama installed"; or echo "✗ Ollama install failed"
    end
end

# Gemini CLI (via bun)
if not set -q skip_bun
    if bun pm ls -g 2>/dev/null | string match -q '*@google/gemini-cli*'
        echo "· Gemini CLI already installed"
    else
        echo "Installing Gemini CLI..."
        bun add -g @google/gemini-cli; and echo "✓ Gemini CLI installed"; or echo "✗ Gemini CLI install failed"
    end

    # Codex CLI (via bun)
    if bun pm ls -g 2>/dev/null | string match -q '*@openai/codex*'
        echo "· Codex CLI already installed"
    else
        echo "Installing Codex CLI..."
        bun add -g @openai/codex; and echo "✓ Codex CLI installed"; or echo "✗ Codex CLI install failed"
    end
end

echo ""
echo "=== API Key Setup ==="
echo "Configure these environment variables:"
echo "  GEMINI_API_KEY  - for gemini CLI"
echo "  OPENAI_API_KEY  - for codex CLI"
echo ""
echo "Claude Code installation:"
echo "  Visit https://claude.ai/download or run:"
echo "  curl -fsSL https://claude.ai/install.sh -o /tmp/claude-install.sh && less /tmp/claude-install.sh && bash /tmp/claude-install.sh"
