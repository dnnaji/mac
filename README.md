# Mac Bootstrap

> **WARNING**: This project executes shell scripts with sudo, modifies system preferences, installs software, and symlinks dotfiles. Review scripts before execution.

Claude Code-driven macOS setup. Fish shell, idempotent, agent-runnable.

## Quick Start (Fresh Mac)

Copy-paste these commands on a brand new Mac.

### Step 1: Prerequisites (Terminal)

```bash
# Xcode Command Line Tools
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (run the command Homebrew tells you)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Fish shell
brew install fish
sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'
chsh -s /opt/homebrew/bin/fish

# Node.js (for Claude Code)
brew install node

# Claude Code
npm install -g @anthropic-ai/claude-code
```

### Step 2: Clone Public Repo

```bash
# Create dev directory
mkdir -p ~/i

# Clone public bootstrap repo (HTTPS - no SSH key needed yet)
git clone https://github.com/dnnaji/mac.git ~/i/mac
cd ~/i/mac
```

### Step 3: SSH & Git Setup (Terminal)

Run these interactively to set up SSH and authenticate with GitHub:

```fish
fish scripts/03_ssh.fish      # Generate SSH key, shows public key to copy
fish scripts/03b_git.fish     # Git config + GitHub CLI auth (opens browser)
```

**Important**: Add your SSH key to GitHub before proceeding:
1. Copy the public key shown by `03_ssh.fish`
2. Go to https://github.com/settings/keys → New SSH key → Paste

### Step 4: Clone Private Repo

```bash
# Now SSH works - clone your private overlay
git clone git@github.com:dnnaji/mac-private.git ~/i/mac/private
```

### Step 5: Run Bootstrap

Open **two terminal windows**:

**Window 1 - Claude Code:**
```fish
cd ~/i/mac
claude
# Then type: /mac-bootstrap
```

Claude Code runs the remaining scripts automatically.

### Step 6: Post-Install (System Settings)

Grant permissions manually:
- **AeroSpace**: System Settings → Privacy & Security → Accessibility
- **Ice**: System Settings → Privacy & Security → Accessibility

Logout/restart for macOS defaults to take effect.

---

## Manual Bootstrap (Without Claude Code)

If you prefer to run scripts manually:

```fish
cd ~/i/mac

# 1. Audit current state
fish scripts/00_discover.fish

# 2. Core CLI tools
fish scripts/01_core_cli.fish

# 3. Node/TypeScript
fish scripts/02_node_typescript.fish

# 4. AI tools (Ollama, Gemini, Codex)
fish scripts/02b_ai_tools.fish

# 5. SSH key (interactive - prompts for email)
fish scripts/03_ssh.fish

# 6. Git config (interactive - prompts for name/email, opens browser)
fish scripts/03b_git.fish

# 7. Fish plugins
fish scripts/04_fish_setup.fish

# 8. Dotfiles + private overlay
fish scripts/05_dotfiles.fish

# 9. macOS preferences
fish scripts/06_macos_defaults.fish -y

# 10. Cursor extensions
fish scripts/07_cursor_extensions.fish

# 11. Manual apps (Ice)
fish scripts/08_manual_apps.fish

# Optional: GUI apps
brew bundle --file=Brewfile.casks --no-lock
brew bundle --file=Brewfile.apps --no-lock
brew bundle --file=Brewfile.mas --no-lock    # Requires App Store login
```

---

## Two-Repo Architecture

```
~/i/mac/                    # Public repo (github.com/dnnaji/mac)
├── scripts/                # Bootstrap scripts
├── dotfiles/               # Generic configs (no personal info)
├── Brewfile*               # Package lists
└── private/                # ← .gitignored

~/i/mac/private/            # Private repo (github.com/dnnaji/mac-private)
├── CLAUDE.md               # Personal workflow preferences
├── gitconfig.local         # Git identity (name, email, signing key)
├── ssh/config              # SSH host aliases
└── fish/                   # Private functions/configs
```

The `05_dotfiles.fish` script automatically loads private configs if present.

---

## Structure

```
scripts/
├── 00_discover.fish         # Audit current state (JSON)
├── 01_core_cli.fish         # Core CLI tools
├── 02_node_typescript.fish  # fnm + Node + tsx + ni
├── 02b_ai_tools.fish        # Ollama, Gemini CLI, Codex CLI
├── 03_ssh.fish              # SSH key generation
├── 03b_git.fish             # Git + GitHub CLI
├── 04_fish_setup.fish       # Fisher + plugins
├── 05_dotfiles.fish         # Symlink configs + private overlay
├── 06_macos_defaults.fish   # Finder, Dock, keyboard
├── 07_cursor_extensions.fish
└── 08_manual_apps.fish      # Ice menu bar

Brewfile                     # Core CLI (always)
Brewfile.casks               # GUI apps (Cursor, Ghostty, Raycast)
Brewfile.apps                # Common apps (Signal, Slack, Notion)
Brewfile.cloud               # AWS/Azure/GCP
Brewfile.k8s                 # Kubernetes tools
Brewfile.security            # LuLu, Malwarebytes, BlockBlock
Brewfile.mas                 # Mac App Store
```

---

## Fish Functions

| Function | Description |
|----------|-------------|
| `i [dir]` | cd to ~/i/ or ~/i/dir |
| `r [dir]` | cd to ~/r/ (reproductions) |
| `clone <url>` | git clone + cd |
| `clonei <url>` | clone to ~/i/ + open in Cursor |
| `cloner <url>` | clone to ~/r/ + open in Cursor |
| `gs` | git status |
| `gp` | git push |
| `gpf` | git push --force-with-lease |
| `gpl` | git pull --rebase |
| `main` | checkout main |
| `grt` | cd to git root |
| `gsha` | copy HEAD SHA to clipboard |
| `d` / `build` / `t` / `s` / `lint` | Run package.json scripts via ni |
| `b` | Brew maintenance (update, upgrade, cleanup) |
| `gsearch` | Gemini web search |
| `gfetch` | Gemini web fetch (multi-URL) |
| `cx` | Codex code review (GPT 5.1) |

---

## AeroSpace (Window Manager)

i3-style tiling. Config: `dotfiles/aerospace/aerospace.toml`

| Keys | Action |
|------|--------|
| `⌥ h/j/k/l` | Focus window |
| `⌥⇧ h/j/k/l` | Move window |
| `⌥ 1-5` | Switch workspace |
| `⌥⇧ 1-5` | Move to workspace |
| `⌥ f` | Fullscreen |
| `⌥ /` | Toggle split direction |
| `⌥⇧ Space` | Toggle floating |

Full guide: [docs/aerospace-guide.md](docs/aerospace-guide.md)

---

## Security Tools

After `brew bundle --file=Brewfile.security`:

1. **LuLu**: Approve System Extension → Allow Network Filter
2. **Malwarebytes**: Grant Full Disk Access
3. **BlockBlock**: Approve System Extension

---

## Manual Downloads

| App | URL |
|-----|-----|
| Wispr Flow | https://wisprflow.ai/get-started |
| Bitwarden CLI (bws) | https://github.com/bitwarden/sdk/releases |

---

## Idempotency

All scripts check before acting. Re-running is safe.

## Influences

- [Omarchy](https://github.com/basecamp/omarchy) v3.2.0
- [antfu/dotfiles](https://github.com/antfu/dotfiles)
