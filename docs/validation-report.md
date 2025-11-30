# Mac Bootstrap Validation Report

Generated: 2025-11-30

---

## 05_dotfiles.fish

### Must Fix

- **Quote all path variables** - `$src`, `$dest`, `$DOTFILES_DIR` in `test`, `rm`, `mv`, `mkdir`, `ln`, `cp` calls to avoid breakage with spaces/globs (e.g. `test -e "$src"`, `rm "$dest"`)
- **Idempotent backup handling** - `mv $dest $dest.bak` overwrites existing `.bak` without warning; add checks or use unique suffix
- **Create target directories** - Add `mkdir -p ~/.config/fish/functions ~/.config/fish/conf.d` before `cp` to prevent failures
- **Handle `realpath` failure** - Check `status` and exit with clear error if `dotfiles` dir doesn't exist or `realpath` binary is missing

### Should Improve

- Use `function safe_link --argument-names src dest` for clearer signature
- Return non-zero from `safe_link` when operations fail; don't print success unconditionally
- Consider Fish builtin `realpath` (≥3.6) or portable fallback (`cd` + `pwd -P`)

---

## 06_macos_defaults.fish

### Must Fix

- **Line 232: Invalid Fish syntax** - `if not (set -q _flag_yes; or set -q CI; or set -q NONINTERACTIVE)` errors with "command substitutions not allowed in command position". Replace with:
  ```fish
  if not set -q _flag_yes; and not set -q CI; and not set -q NONINTERACTIVE
  ```

### Should Fix

- **Line 244** - Quote variable: `test "$security_can_run" -eq 1`
- **`confirm` function (lines 35-45)** - Make return logic explicit:
  ```fish
  if test -z "$response"; or string match -qi 'y*' -- "$response"
      return 0
  else
      return 1
  end
  ```
- **Screenshot settings** - Add `killall SystemUIServer 2>/dev/null` for changes to take effect immediately
- **Lines 293-294** - Comment says "Disable LSQuarantine dialog" but code doesn't change it; update comment to match reality

### Security Notes

- `FXEnableExtensionChangeWarning -bool false` slightly reduces safety against spoofed extensions; consider making opt-in
- If CI requires security changes, `exit 1` when `security_can_run` ends up `0` in non-interactive mode

---

## 02b_ai_tools.fish

### Must Fix

- **Add dependency checks** - All installs assume `brew`/`bun` exist:
  ```fish
  command -q brew; or begin; echo "brew not found"; return 1; end
  command -q bun; or begin; echo "bun not found"; return 1; end
  ```
- **Conditional success messages** - Currently prints "✓ installed" even on failure:
  ```fish
  brew install --cask ollama; and echo "✓ Ollama installed"; or echo "✗ Ollama install failed"
  ```
- **Propagate failures** - Script exits 0 even if installs fail; add `or return 1` after failed installs

### Should Fix

- **Ollama idempotency** - `/Applications/Ollama.app` check misses manual installs; use `brew list --cask ollama` instead
- **Package detection** - `bun pm ls -g | grep -q` is loose text search; anchor match or use structured check
- **Security: Line 41-42** - `curl -fsSL ... | bash` is unsafe; recommend downloading and reviewing script first

---

## Fish Functions (cx.fish, gfetch.fish, gsearch.fish)

### cx.fish

- **Add existence check**:
  ```fish
  type -q codex; or begin; echo 'codex not found'; return 127; end
  ```
- **Prevent option injection** - Add `--` before `$argv`:
  ```fish
  codex exec --full-auto --skip-git-repo-check -- $argv
  ```

### gfetch.fish & gsearch.fish

- **Escape double quotes in `$argv`** - User input containing `"` breaks the prompt format
- **Add existence check** - `type -q gemini` with friendly error
- **Handle empty `$argv`** - Print usage message instead of sending empty prompt

---

## aerospace.toml

### Verified OK

- TOML syntax valid (parsed with Python tomllib)
- No duplicate keybindings in `[mode.main.binding]`
- Workspaces 1-5 consistent across bindings, monitor assignment, and `on-window-detected` rules

### Must Verify

- **Monitor identifiers** - Confirm `'main'` and `'secondary'` match output of `aerospace list-monitors`
- **App bundle IDs** - Verify each `if.app-id` matches actual apps:
  - `com.openai.chat`
  - `com.openai.atlas.web.helper.plugin`
  - `com.mitchellh.ghostty`
  - `com.todesktop.230313mzl4w4u92`
  - `com.google.antigravity`
  - `com.pvncher.repoprompt`

### Optional

- Add bindings for: close window, reload config, toggle floating

---

## Summary

| File | Critical | Important | Optional |
|------|----------|-----------|----------|
| 05_dotfiles.fish | 4 | 3 | 0 |
| 06_macos_defaults.fish | 1 | 4 | 2 |
| 02b_ai_tools.fish | 3 | 3 | 0 |
| Fish functions | 0 | 5 | 1 |
| aerospace.toml | 0 | 2 | 1 |
| **Total** | **8** | **17** | **4** |
