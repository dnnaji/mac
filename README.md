# Mac Bootstrap

> **WARNING**: Automating macOS setup with AI tools can be dangerous. This project executes shell scripts with elevated privileges (sudo), modifies system preferences via `defaults write`, installs software, and symlinks dotfiles. **Proceed at your own risk.** Review all scripts before execution.

Claude Code-driven macOS setup. All scripts are Fish shell, idempotent, and agent-runnable.

## Workflow (Two Windows)

**Window 1: Claude Code** - orchestrates scripts
**Window 2: Terminal** - interactive steps

### Phase 0: Prerequisites (Terminal)

Run manually before Claude Code can help:

```bash
# Xcode CLT
xcode-select --install

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Fish shell
brew install fish
sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells'
chsh -s /opt/homebrew/bin/fish

# Claude Code
npm install -g @anthropic-ai/claude-code
```

Then clone and start Claude Code:

```fish
git clone <repo> ~/i/mac
cd ~/i/mac
claude
```

### Phase 1-2: Core Setup (Claude Code)

Run `/mac-bootstrap` - Claude Code handles:
- `00_discover.fish` - audit current state
- `01_core_cli.fish` - CLI tools (Brewfile)
- `02_node_typescript.fish` - fnm + Node
- `02b_ai_tools.fish` - AI CLIs (Ollama, Gemini, Codex)

### Phase 3: SSH & Git (Terminal)

**Interactive prompts** - run in your terminal window:

```fish
fish scripts/03_ssh.fish      # Prompts for SSH key details
fish scripts/03b_git.fish     # Prompts for git config, opens browser for gh auth
```

Tell Claude Code when done to continue.

### Phase 4-6: Config (Claude Code)

Claude Code continues with:
- `04_fish_setup.fish` - Fisher + plugins
- `05_dotfiles.fish` - symlink configs
- `06_macos_defaults.fish -y` - system prefs (auto-yes)
- `07_cursor_extensions.fish` - Cursor extensions
- `08_manual_apps.fish` - Ice menu bar manager

### Optional: GUI Apps (Claude Code)

```fish
brew bundle --file=Brewfile.casks --no-lock    # Cursor, Ghostty, Raycast, etc.
brew bundle --file=Brewfile.mas --no-lock      # Mac App Store (requires login)
brew bundle --file=Brewfile.apps --no-lock     # Signal, Slack, Notion, etc.
```

### Post-Install: Permissions (System Settings)

Manual approval required after installation:
- **AeroSpace**: Privacy & Security → Accessibility
- **Ice**: Privacy & Security → Accessibility
- **Security tools**: Privacy & Security → Security (system extensions)

Logout/restart for macOS defaults to take effect.

## Structure

```
scripts/                     # Numbered Fish scripts (00-08)
├── 00_discover.fish         # Audit current state (JSON output)
├── 01_core_cli.fish         # Install core CLI tools (includes gh)
├── 02_node_typescript.fish  # fnm + Node + tsx + ni
├── 02b_ai_tools.fish        # AI CLI tools (Ollama, Gemini, Codex)
├── 03_ssh.fish              # SSH key generation
├── 03b_git.fish             # Git config + GitHub CLI auth
├── 04_fish_setup.fish       # Fisher + plugins
├── 05_dotfiles.fish         # Symlink dotfiles
├── 06_macos_defaults.fish   # Configure Finder, Dock, keyboard, Aerospace
├── 07_cursor_extensions.fish # Install Cursor extensions
└── 08_manual_apps.fish      # Apps requiring manual install (Ice)

Brewfile                     # Core CLI tools (always)
Brewfile.casks               # GUI apps (Cursor, Ghostty, Raycast, etc.)
Brewfile.apps                # Common apps (Signal, Slack, Notion, etc.)
Brewfile.cloud               # AWS/Azure/GCP (optional)
Brewfile.k8s                 # Kubernetes (optional)
Brewfile.security            # LuLu, Malwarebytes, BlockBlock
Brewfile.mas                 # Mac App Store apps (Pandan, Amphetamine)

docs/
└── aerospace-guide.md       # Aerospace + macOS Sequoia usage guide

dotfiles/
├── CLAUDE.md                # Claude Code root config
├── aerospace/aerospace.toml # Aerospace window manager config
├── ghostty/config           # Ghostty terminal config
├── gitconfig
├── npmrc
├── starship.toml
├── cursor/extensions.txt    # Cursor extension list
├── fish/functions/          # Fish functions (23)
└── ssh/config.template
```

## Fish Functions

| Function       | Description                                 |
| -------------- | ------------------------------------------- |
| `i [dir]`      | cd to ~/i/ or ~/i/dir                       |
| `grt`          | cd to git root                              |
| `clone <url>`  | git clone + cd                              |
| `clonei <url>` | clone to ~/i/ + open in cursor              |
| `gs`           | git status                                  |
| `gp`           | git push                                    |
| `gpf`          | git push --force-with-lease                 |
| `gpl`          | git pull --rebase                           |
| `main`         | checkout main                               |
| `gsha`         | copy HEAD SHA to clipboard                  |
| `d`            | run dev script via ni                       |
| `build`        | run build script via ni                     |
| `t`            | run test script via ni                      |
| `s`            | run start script via ni                     |
| `lint`         | run lint script via ni                      |
| `b`            | brew maintenance (update, upgrade, cleanup) |
| `r [dir]`      | cd to ~/r/ reproductions                    |
| `cloner <url>` | clone to ~/r/ + open in cursor              |
| `gsearch`      | Gemini web search                           |
| `gfetch`       | Gemini web fetch (multi-URL)                |
| `cx`           | Codex code review (GPT 5.1)                 |

## AeroSpace (Tiling Window Manager)

i3-style tiling window manager. Config: `dotfiles/aerospace/aerospace.toml`

### Setup

1. Launch: `open -a AeroSpace`
2. Grant Accessibility permission when prompted
3. Auto-starts on login after first run

### Keybindings

| Keys | Action |
| ---- | ------ |
| `⌥ h/j/k/l` | Focus window left/down/up/right |
| `⌥⇧ h/j/k/l` | Move window left/down/up/right |
| `⌥ 1-5` | Switch to workspace 1-5 |
| `⌥⇧ 1-5` | Move window to workspace 1-5 |
| `⌥ f` | Toggle fullscreen |
| `⌥ /` | Toggle horizontal/vertical split |
| `⌥ ,` | Toggle accordion layout |
| `⌥⇧ Space` | Toggle floating/tiling |
| `⌥ -` | Resize smaller |
| `⌥ =` | Resize larger |

### Notes

- **Conflicts with Rectangle**: Disable Rectangle if using AeroSpace (both manage windows)
- Gaps: 8px inner/outer by default
- Workspaces are virtual desktops (not tied to displays)

## Security Tools

After `brew bundle --file=Brewfile.security`:

1. **LuLu**: Open app → Approve System Extension → Allow Network Filter
2. **Malwarebytes**: Grant Full Disk Access in System Settings
3. **BlockBlock**: Approve System Extension in System Settings

These require manual approval due to macOS security restrictions.

## Menu Bar

### Ice
Menu bar manager (Bartender alternative, free/open source). Installed via `08_manual_apps.fish` from GitHub releases because Homebrew version doesn't support macOS Tahoe.

After installation:
1. Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → Enable Ice
2. Configure hidden items by clicking the Ice icon

## Window Management

### Aerospace
Tiling window manager (i3-style). After installation:

1. Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → Enable AeroSpace
2. Start: `open -a AeroSpace` or enable "start-at-login" in config

**Quick Reference** (alt = option key):
| Key | Action |
|-----|--------|
| `alt-h/j/k/l` | Focus window (vim-style) |
| `alt-shift-h/j/k/l` | Move window |
| `alt-1-5` | Switch workspace |
| `alt-shift-1-5` | Move to workspace |
| `alt-f` | Fullscreen |

**Full guide**: [docs/aerospace-guide.md](docs/aerospace-guide.md) - keybindings, gestures, troubleshooting

## Password Management

### Bitwarden
- **App**: Installed via Mac App Store (`Brewfile.mas`)
- **Secrets Manager CLI**: Manual install from https://github.com/bitwarden/sdk/releases
  ```bash
  # Download bws-macos-universal from releases
  # Move to /usr/local/bin/bws
  chmod +x /usr/local/bin/bws
  ```

## Idempotency

All scripts check before acting:
- `command -q <tool>` for CLI tools
- `test -f <path>` for files
- `test -L <path>` for symlinks

Re-running any script is safe.

## Influences

This setup is inspired by:
- [Omarchy](https://github.com/basecamp/omarchy) v3.2.0 - CLI tools (btop, lazydocker, dust, procs, try), Ghostty/Aerospace configs
- [antfu/dotfiles](https://github.com/antfu/dotfiles) - Directory structure (`~/i/` projects, `~/r/` reproductions)
