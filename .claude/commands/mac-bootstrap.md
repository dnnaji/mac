You are bootstrapping a new macOS machine using the mac-bootstrap scripts in this repository.

The user has **two windows open**: Claude Code (you) and a separate Terminal for interactive steps.

## Prerequisites Check
Before running any scripts, verify Phase 0 is complete:
- Xcode Command Line Tools installed
- Homebrew installed and on PATH
- Fish shell installed and set as default
- Claude Code installed

## Workflow

### Step 1: Discovery
Run the discovery script to assess current state:
```fish
fish scripts/00_discover.fish
```
Parse the JSON output and display a summary table showing:
- What's already installed (✓)
- What's missing (✗)

### Step 2: Present Options
Ask which phases to install:
- [ ] Phase 1: Core CLI tools (Brewfile)
- [ ] Phase 2: Node/TypeScript (fnm + Node LTS)
- [ ] Phase 2b: AI tools (Ollama, Gemini CLI, Codex CLI)
- [ ] Phase 3: SSH keys + Git config (⚠️ TERMINAL - interactive)
- [ ] Phase 4: Fish shell plugins (Fisher + plugins)
- [ ] Phase 5: Dotfiles (symlink configs)
- [ ] Phase 6: macOS defaults (Dock, Finder, keyboard, security)
- [ ] Phase 7: Cursor extensions
- [ ] Phase 8: Manual apps (Ice)
- [ ] Optional: GUI apps (Brewfile.casks)
- [ ] Optional: Mac App Store apps (Brewfile.mas)
- [ ] Optional: Common apps (Brewfile.apps)

### Step 3: Execute Phases

**Claude Code Phases** (you run these):
```fish
fish scripts/00_discover.fish
fish scripts/01_core_cli.fish
fish scripts/02_node_typescript.fish
fish scripts/02b_ai_tools.fish
fish scripts/04_fish_setup.fish
fish scripts/05_dotfiles.fish
fish scripts/06_macos_defaults.fish -y    # Use -y for non-interactive
fish scripts/07_cursor_extensions.fish
fish scripts/08_manual_apps.fish
```

**Terminal Phases** (user runs in separate window):
When you reach Phase 3, STOP and tell the user:

> "Phase 3 requires interactive input. Run these in your Terminal window:"
> ```fish
> fish scripts/03_ssh.fish      # Prompts for SSH key details
> fish scripts/03b_git.fish     # Prompts for git config, opens browser for gh auth
> ```
> "Let me know when done, and I'll continue with Phase 4."

**Optional Brewfiles** (you run these):
```fish
brew bundle --file=Brewfile.casks --no-lock
brew bundle --file=Brewfile.mas --no-lock   # Requires App Store login
brew bundle --file=Brewfile.apps --no-lock
```

### Step 4: Verify
Re-run discovery to confirm installation:
```fish
fish scripts/00_discover.fish
```

### Step 5: Summary
Print final summary:
- Installed tools with versions
- Remaining manual steps (permissions below)
- Next steps (e.g., "Add SSH key to GitHub")

**Post-Install Manual Steps** - remind user:
- Grant Accessibility: AeroSpace, Ice (System Settings → Privacy & Security → Accessibility)
- Approve security extensions if Brewfile.security was installed
- Logout/restart for macOS defaults to take effect

## Constraints
- All scripts are Fish shell (not bash)
- Scripts are idempotent - safe to run multiple times
- Never run destructive commands without explicit approval
- Brewfiles are the source of truth for packages
- Dotfiles are symlinked, not copied (except fish functions)
- macOS defaults script has interactive prompts (use -y to skip)
- Security settings in 06_macos_defaults.fish require sudo

## Error Handling
If a script fails:
1. Show the error output
2. Explain what went wrong
3. Suggest fix (usually re-run after addressing the issue)
4. Do NOT continue to next phase until current one succeeds
