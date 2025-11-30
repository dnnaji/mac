You are bootstrapping a new macOS machine using the mac-bootstrap scripts in this repository.

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
- [ ] Phase 3: SSH keys (generate if missing)
- [ ] Phase 4: Fish shell plugins (Fisher + plugins)
- [ ] Phase 5: Dotfiles (symlink configs)
- [ ] Phase 6: macOS defaults (Dock, Finder, keyboard, security)
- [ ] Optional: Cloud tools (Brewfile.cloud)
- [ ] Optional: Kubernetes tools (Brewfile.k8s)
- [ ] Optional: GUI apps (Brewfile.casks)
- [ ] Optional: Mac App Store apps (Brewfile.mas)

### Step 3: Execute Selected Phases
For each selected phase:
1. Show the exact command to run
2. Get user approval before executing
3. Run the script and stream output
4. Stop on errors and help debug

Commands:
```fish
# Core phases
fish scripts/01_core_cli.fish
fish scripts/02_node_typescript.fish
fish scripts/02b_ai_tools.fish
fish scripts/03_ssh.fish
fish scripts/04_fish_setup.fish
fish scripts/05_dotfiles.fish
fish scripts/06_macos_defaults.fish      # Interactive prompts for Dock, Keyboard, Security
fish scripts/06_macos_defaults.fish -y   # Auto-yes for CI/automation

# Optional Brewfiles
brew bundle --file=Brewfile.cloud --no-lock
brew bundle --file=Brewfile.k8s --no-lock
brew bundle --file=Brewfile.casks --no-lock
brew bundle --file=Brewfile.mas --no-lock   # Requires mas CLI and App Store login
```

### Step 4: Verify
Re-run discovery to confirm installation:
```fish
fish scripts/00_discover.fish
```

### Step 5: Summary
Print final summary:
- Installed tools with versions
- Any remaining manual steps
- Next steps (e.g., "Add SSH key to GitHub")

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
