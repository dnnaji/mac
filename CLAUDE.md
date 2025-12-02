# Mac Bootstrap Project

This repository contains idempotent Fish shell scripts for bootstrapping a new macOS machine.

## Context
- All scripts are Fish shell (not Bash/Zsh)
- User: Derrick
- Dev directories: ~/i/ (projects), ~/r/ (reproductions)
- Primary tools: bun, ni, cursor, ghostty, aerospace

## Repository Structure
- `~/i/mac/` - Public bootstrap repo (github.com/dnnaji/mac)
- `~/i/mac/private/` - **Separate private repo** (github.com/dnnaji/mac-private)
  - Gitignored from parent repo
  - Contains: personal configs, ssh keys, local overrides, notes
  - Commit/push to private repo separately: `cd private && git add . && git commit && git push`

## Key Constraints
- Scripts must be idempotent (safe to run multiple times)
- Security tools require manual system extension approval
- Never store secrets in dotfiles (use private/ repo instead)
