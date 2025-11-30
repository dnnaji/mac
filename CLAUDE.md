# Mac Bootstrap Project

This repository contains idempotent Fish shell scripts for bootstrapping a new macOS machine.

## Context
- All scripts are Fish shell (not Bash/Zsh)
- User: Derrick
- Dev directories: ~/i/ (projects), ~/r/ (reproductions)
- Primary tools: bun, ni, cursor, ghostty, aerospace

## Key Constraints
- Scripts must be idempotent (safe to run multiple times)
- Security tools require manual system extension approval
- Never store secrets in dotfiles
