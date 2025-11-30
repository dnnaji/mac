# Mac Bootstrap

> **WARNING**: Automating macOS setup with AI tools can be dangerous. This project executes shell scripts with elevated privileges (sudo), modifies system preferences via `defaults write`, installs software, and symlinks dotfiles. **Proceed at your own risk.** Review all scripts before execution.

Claude Code-driven macOS setup. All scripts are Fish shell, idempotent, and agent-runnable.

## Quick Start (New Mac)

1. Install prerequisites manually:
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
   curl -fsSL https://claude.ai/install.sh | bash
   ```

2. Clone and run:
   ```fish
   git clone <repo> ~/i/adr
   cd ~/i/adr/mac-bootstrap
   claude
   # Then: /mac-bootstrap
   ```

## Structure

```
scripts/                     # Numbered Fish scripts (00-07)
├── 00_discover.fish         # Audit current state (JSON output)
├── 01_core_cli.fish         # Install core CLI tools (includes gh)
├── 02_node_typescript.fish  # fnm + Node + tsx + ni
├── 03_ssh.fish              # SSH key generation
├── 03b_git.fish             # Git config + GitHub CLI auth
├── 04_fish_setup.fish       # Fisher + plugins
├── 05_dotfiles.fish         # Symlink dotfiles
├── 06_macos_defaults.fish   # Configure Finder, Dock, keyboard
└── 07_cursor_extensions.fish # Install Cursor extensions

Brewfile                     # Core CLI tools (always)
Brewfile.casks               # GUI apps (Cursor, Ghostty, Raycast, etc.)
Brewfile.cloud               # AWS/Azure/GCP (optional)
Brewfile.k8s                 # Kubernetes (optional)
Brewfile.security            # LuLu, Malwarebytes, BlockBlock
Brewfile.mas                 # Mac App Store apps (Pandan)

dotfiles/
├── aerospace/aerospace.toml # Aerospace window manager config
├── ghostty/config           # Ghostty terminal config
├── gitconfig
├── npmrc
├── starship.toml
├── cursor/extensions.txt    # Cursor extension list
├── fish/functions/          # 20 Fish functions
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

## Security Tools

After `brew bundle --file=Brewfile.security`:

1. **LuLu**: Open app → Approve System Extension → Allow Network Filter
2. **Malwarebytes**: Grant Full Disk Access in System Settings
3. **BlockBlock**: Approve System Extension in System Settings

These require manual approval due to macOS security restrictions.

## Window Management

### Aerospace
Tiling window manager (i3-style). After installation:

1. Grant Accessibility permission: System Settings → Privacy & Security → Accessibility → Enable AeroSpace
2. Start: `open -a AeroSpace` or enable "start-at-login" in config

**Keybindings** (alt = option key):
| Key | Action |
|-----|--------|
| `alt-h/j/k/l` | Focus window (vim-style) |
| `alt-shift-h/j/k/l` | Move window |
| `alt-1-5` | Switch workspace |
| `alt-shift-1-5` | Move to workspace |
| `alt-f` | Fullscreen |
| `alt-/` | Toggle horizontal/vertical |
| `alt-,` | Accordion layout |
| `alt--/=` | Resize |

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
