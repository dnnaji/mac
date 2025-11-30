# Claude Code Configuration
# Customize this file with your preferences and place at ~/CLAUDE.md

# Communication Style
- Direct, concise - no fluff
- Trust my judgment - don't be patronizing
- "do it" = execute without discussion (skip confirmation, I've already decided)
- When corrected, adapt immediately

# Implementation vs Research
Research keywords (gather info, don't implement):
- "research", "investigate", "explore", "consult"
- Output: documentation, issues, notes, plans

Action keywords (implement directly):
- "implement", "create", "set up", "execute", "do it"
- Output: working code, changes committed

When ambiguous, ask: "Implement this or document the approach?"

# Preferred Workflow
For complex tasks:
1. Explore: Read relevant files first, understand context
2. Plan: Use "think hard" for detailed planning
3. Code: Implement the solution
4. Commit: Descriptive commit messages

For simple/clear tasks: Skip planning, implement directly

# Shell & Environment
- Fish shell (not Bash/Zsh)
- Functions: ~/.config/fish/functions/
- Dev repos: ~/i/

# Tool Preferences
- `bun` over `npm`
- `jq` for JSON, `yq` for YAML, `dasel` for multi-format
- `jless` - JSON exploration
- `gh` - GitHub CLI for GitHub operations

## AI CLI Tools
Fish functions for external AI tools:
- `gsearch "query"` - Gemini web search (cleaner synthesis, no URL clutter)
- `gfetch "prompt with URLs"` - Gemini fetch/compare up to 20 URLs
- `cx "prompt"` - Codex code review/logic validation (GPT 5.1)

Use cases:
- `gsearch` - Quick answers, current events, documentation lookups
- `gfetch` - Compare multiple pages, summarize articles
- `cx` - Code review, architecture questions, logic validation, second opinion

Use Claude Code WebSearch when you need source URLs for citations.

## Claude Code Tool Selection
Use native tools (optimized for context management):
- Grep for content search (not `rg`/`grep`)
- Glob for file patterns (not `fd`/`find`)
- Read for file contents (not `cat`/`head`/`tail`)
- Edit for modifications (not `sed`/`awk`)
- Bash only for: git, bun, docker, terminal ops

# Workflow Preferences
- Create GitHub issues for research findings
- Prefer incremental commits
- Paste screenshots for UI work (2-3 visual iterations)

# Testing
- Be specific: "test foo.py covering edge case X" over "write tests"
- TDD: write failing tests, commit, then implement
- Verify tests pass before committing

# Context Management
- `/clear` between unrelated tasks
- Long tasks: use full context before completion
- Complex investigations: use subagents to preserve main context

# Output Preferences
- Prefer editing existing files over creating new ones
- Only create .md files when explicitly requested
