#!/usr/bin/env fish
# 03b_git.fish - Git and GitHub CLI configuration
# Idempotent: safe to run multiple times
# Run after: 03_ssh.fish (SSH key needed for gh auth)

echo "=== Git & GitHub CLI Setup ==="
echo ""

# Check gh is installed
if not command -q gh
    echo "ERROR: gh (GitHub CLI) not installed. Run 01_core_cli.fish first."
    exit 1
end

# Git global config
echo "Configuring git..."

# Get current values to check if already set
set -l current_name (git config --global user.name 2>/dev/null)
set -l current_email (git config --global user.email 2>/dev/null)

if test -z "$current_name"
    read -P "Git user.name (e.g., Derrick): " git_name
    if test -n "$git_name"
        git config --global user.name "$git_name"
        echo "✓ Set user.name: $git_name"
    end
else
    echo "· user.name already set: $current_name"
end

if test -z "$current_email"
    read -P "Git user.email: " git_email
    if test -n "$git_email"
        git config --global user.email "$git_email"
        echo "✓ Set user.email: $git_email"
    end
else
    echo "· user.email already set: $current_email"
end

# Sensible defaults
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true
git config --global pull.rebase true
git config --global fetch.prune true
git config --global core.autocrlf input
git config --global rerere.enabled true
echo "✓ Applied git defaults (main branch, auto remote, rebase pull, prune fetch)"

# GitHub CLI auth
echo ""
echo "=== GitHub CLI Authentication ==="

if gh auth status &>/dev/null
    echo "· Already authenticated with GitHub:"
    gh auth status
else
    echo "GitHub CLI not authenticated."
    echo ""
    echo "This will open a browser for authentication."
    echo "Choose: SSH protocol, use existing SSH key"
    echo ""
    read -P "Authenticate now? [y/N]: " do_auth
    if test "$do_auth" = y -o "$do_auth" = Y
        gh auth login -p ssh -h github.com
    else
        echo "· Skipped. Run 'gh auth login' later."
    end
end

# Verify SSH connection
echo ""
echo "=== Verification ==="
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com 2>&1 | head -1
echo ""
echo "Git setup complete."
