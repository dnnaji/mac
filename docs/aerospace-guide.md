# Aerospace + macOS Sequoia Guide

Aerospace is a keyboard-driven tiling window manager for macOS. This guide covers optimal configuration with macOS Sequoia (15.x).

## Core Concept

Aerospace workspaces are **independent** from macOS Spaces. They don't sync.

- Aerospace manages windows within a single macOS Space
- Workspaces 1-5 are virtual containers Aerospace tracks
- Switching `alt-1` moves windows in/out of view, not macOS Spaces

**Best practice**: Use one macOS Space per monitor, let Aerospace handle all window organization.

## Focus Behavior

The config uses `on-focus-changed = ['move-mouse window-lazy-center']` to move the mouse to the focused window. This reduces jarring context switches and makes focus more predictable.

## Keybindings

### Window Focus (vim-style)
| Key | Action |
|-----|--------|
| `alt-h` | Focus left |
| `alt-j` | Focus down |
| `alt-k` | Focus up |
| `alt-l` | Focus right |

### Move Windows
| Key | Action |
|-----|--------|
| `alt-shift-h` | Move window left |
| `alt-shift-j` | Move window down |
| `alt-shift-k` | Move window up |
| `alt-shift-l` | Move window right |

### Workspaces
| Key | Action |
|-----|--------|
| `alt-1` to `alt-5` | Switch to workspace |
| `alt-shift-1` to `alt-shift-5` | Move window to workspace |
| `ctrl-alt-left/right` | Cycle prev/next workspace |

### Layout
| Key | Action |
|-----|--------|
| `alt-f` | Toggle fullscreen |
| `alt-/` | Toggle horizontal/vertical split |
| `alt-,` | Accordion layout |
| `alt-shift-space` | Toggle floating/tiling |
| `alt--` | Resize smaller |
| `alt-=` | Resize larger |

## Monitor Assignment

Workspaces are pinned to monitors:

| Workspace | Monitor | Purpose |
|-----------|---------|---------|
| 1-3 | main | General use |
| 4 | secondary | Repo Prompt (auto-routed) |
| 5 | secondary | Free |

## macOS Gestures

Aerospace is keyboard-first. Most gestures conflict or are redundant.

### Keep These
| Gesture | Action | Why |
|---------|--------|-----|
| 3-finger swipe up | Mission Control | Useful overview of all windows |
| Pinch with thumb | Launchpad | Quick app launch (or use Raycast) |

### Disable/Ignore These
| Gesture | Conflict |
|---------|----------|
| 3-finger swipe L/R | Switches macOS Spaces, not Aerospace workspaces |
| 4-finger swipe L/R | Same conflict |
| Drag to edge | Triggers Sequoia tiling, conflicts with Aerospace |

### System Settings Applied
The bootstrap disables conflicting features:
```bash
# Disable Sequoia edge-tiling
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false

# Don't auto-rearrange Spaces
defaults write com.apple.dock mru-spaces -bool false

# Displays have separate Spaces (required for multi-monitor)
defaults write com.apple.spaces spans-displays -bool false

# Group windows by app in Mission Control
defaults write com.apple.dock expose-group-apps -bool true
```

## Initial Setup

### 1. Clean Up macOS Spaces
After installing Aerospace, consolidate to one Space per monitor:

1. Open Mission Control (`F3` or 3-finger swipe up)
2. Drag all windows to a single Space
3. Delete extra Spaces (hover over Space, click X)

### 2. Grant Accessibility Permission
System Settings → Privacy & Security → Accessibility → Enable AeroSpace

### 3. Reload Config
After editing `~/.config/aerospace/aerospace.toml`:
```bash
aerospace reload-config
```

## Auto-Routing Apps

Only Repo Prompt is auto-routed (pinned to secondary monitor as a reference tool). Other apps open on your current workspace.

| App | Workspace |
|-----|-----------|
| Repo Prompt | 4 |

To add more, edit `aerospace.toml`:
```toml
[[on-window-detected]]
if.app-id = 'com.example.app'
run = 'move-node-to-workspace 1'
```

Find app bundle IDs:
```bash
osascript -e 'id of app "AppName"'
```

## Common Workflows

### Split Terminal + Editor
1. `alt-2` → Switch to workspace 2 (Ghostty)
2. `alt-shift-e` → New split right (in Ghostty)
3. Work in split terminals

### Quick Window Arrangement
1. Open apps normally (auto-routed to workspaces)
2. `alt-/` → Toggle split direction
3. `alt-shift-h/l` → Rearrange windows
4. `alt--` or `alt-=` → Resize

### Temporary Floating
Some apps work better floating (dialogs, preferences):
1. Focus the window
2. `alt-shift-space` → Toggle floating
3. Drag/resize freely
4. `alt-shift-space` → Return to tiling

## Troubleshooting

### Windows Not Tiling
- Check Accessibility permission is granted
- Run `aerospace reload-config`
- Some apps resist tiling (use floating mode)

### Config Not Loading
```bash
# Check for syntax errors
aerospace reload-config

# If ambiguous config error, remove old location
rm ~/.aerospace.toml  # Keep only ~/.config/aerospace/aerospace.toml
```

### Mission Control Shows Tiny Windows
Enable "Group Windows by Application" in System Settings → Desktop & Dock → Mission Control

## Resources

- [Aerospace GitHub](https://github.com/nikitabobko/AeroSpace)
- [Aerospace Docs](https://nikitabobko.github.io/AeroSpace/guide)
- Config location: `~/.config/aerospace/aerospace.toml`
