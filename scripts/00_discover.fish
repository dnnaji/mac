#!/usr/bin/env fish
# 00_discover.fish - Audit current Mac state
# Returns JSON status for agent consumption
# Usage: fish scripts/00_discover.fish | jq .

function check_cmd
    command -q $argv[1]; and echo "true"; or echo "false"
end

function check_file
    test -f $argv[1]; and echo "true"; or echo "false"
end

function check_dir
    test -d $argv[1]; and echo "true"; or echo "false"
end

function check_cmd_or_path
    # Check command in PATH or explicit file path
    command -q $argv[1]; or test -x $argv[2]; and echo "true"; or echo "false"
end

echo "{"
echo '  "system": {'
echo '    "macos": "'(sw_vers -productVersion)'",'
echo '    "arch": "'(uname -m)'",'
echo '    "chip": "'(sysctl -n machdep.cpu.brand_string 2>/dev/null | string trim)'",'
echo '    "hostname": "'(hostname -s)'"'
echo '  },'

echo '  "phase0_prerequisites": {'
echo '    "xcode_clt": '(xcode-select -p >/dev/null 2>&1; and echo "true"; or echo "false")','
echo '    "homebrew": '(check_cmd brew)','
echo '    "fish": '(check_cmd fish)','
echo '    "claude": '(check_cmd claude)
echo '  },'

echo '  "phase1_cli": {'
echo '    "git": '(check_cmd git)','
echo '    "gh": '(check_cmd gh)','
echo '    "fzf": '(check_cmd fzf)','
echo '    "rg": '(check_cmd rg)','
echo '    "fd": '(check_cmd fd)','
echo '    "zoxide": '(check_cmd zoxide)','
echo '    "bat": '(check_cmd bat)','
echo '    "eza": '(check_cmd eza)','
echo '    "delta": '(check_cmd delta)','
echo '    "jq": '(check_cmd jq)','
echo '    "yq": '(check_cmd yq)','
echo '    "jless": '(check_cmd jless)','
echo '    "dasel": '(check_cmd dasel)','
echo '    "tmux": '(check_cmd tmux)','
echo '    "lazygit": '(check_cmd lazygit)','
echo '    "starship": '(check_cmd starship)','
echo '    "direnv": '(check_cmd direnv)','
echo '    "neovim": '(check_cmd nvim)','
echo '    "gum": '(check_cmd gum)','
echo '    "glow": '(check_cmd glow)','
echo '    "lf": '(check_cmd lf)
echo '  },'

echo '  "phase2_node": {'
echo '    "fnm": '(check_cmd fnm)','
echo '    "node": '(check_cmd node)','
echo '    "npm": '(check_cmd npm)','
echo '    "bun": '(check_cmd_or_path bun ~/.bun/bin/bun)','
echo '    "deno": '(check_cmd_or_path deno ~/.deno/bin/deno)','
echo '    "tsx": '(check_cmd tsx)','
echo '    "typescript": '(check_cmd tsc)
echo '  },'

echo '  "phase3_ssh": {'
echo '    "ed25519_key": '(check_file ~/.ssh/id_ed25519)','
echo '    "ed25519_pub": '(check_file ~/.ssh/id_ed25519.pub)','
echo '    "ssh_config": '(check_file ~/.ssh/config)','
echo '    "agent_running": '(ssh-add -l >/dev/null 2>&1; and echo "true"; or echo "false")
echo '  },'

echo '  "phase4_fish": {'
echo '    "fisher": '(functions -q fisher; and echo "true"; or echo "false")','
echo '    "config_exists": '(check_file ~/.config/fish/config.fish)','
echo '    "conf_d_exists": '(check_dir ~/.config/fish/conf.d)','
echo '    "functions_dir": '(check_dir ~/.config/fish/functions)
echo '  },'

echo '  "phase5_dotfiles": {'
echo '    "gitconfig": '(check_file ~/.gitconfig)','
echo '    "npmrc": '(check_file ~/.npmrc)','
echo '    "starship_toml": '(check_file ~/.config/starship.toml)
echo '  },'

echo '  "phase6_macos_defaults": {'
echo '    "dock_autohide": '(defaults read com.apple.dock autohide 2>/dev/null | string match -q "1"; and echo "true"; or echo "false")','
echo '    "finder_pathbar": '(defaults read com.apple.finder ShowPathbar 2>/dev/null | string match -q "1"; and echo "true"; or echo "false")','
echo '    "finder_statusbar": '(defaults read com.apple.finder ShowStatusBar 2>/dev/null | string match -q "1"; and echo "true"; or echo "false")
echo '  },'

echo '  "phase7_editors": {'
echo '    "cursor": '(check_dir "/Applications/Cursor.app")','
echo '    "cursor_extensions": '(command -q cursor; and cursor --list-extensions 2>/dev/null | wc -l | string trim; or echo "0")','
echo '    "zed": '(check_dir "/Applications/Zed.app")','
echo '    "antigravity": '(check_dir "/Applications/Antigravity.app")
echo '  },'

echo '  "optional_cloud": {'
echo '    "awscli": '(check_cmd aws)','
echo '    "azure_cli": '(check_cmd az)','
echo '    "gcloud": '(check_cmd gcloud)
echo '  },'

echo '  "optional_k8s": {'
echo '    "kubectl": '(check_cmd kubectl)','
echo '    "k9s": '(check_cmd k9s)','
echo '    "helm": '(check_cmd helm)','
echo '    "kind": '(check_cmd kind)
echo '  },'

echo '  "optional_security": {'
echo '    "lulu": '(check_dir "/Applications/LuLu.app")','
echo '    "malwarebytes": '(check_dir "/Applications/Malwarebytes.app")','
echo '    "blockblock": '(check_dir "/Applications/BlockBlock Helper.app")
echo '  },'

echo '  "optional_productivity": {'
echo '    "raycast": '(check_dir "/Applications/Raycast.app")','
echo '    "rectangle": '(check_dir "/Applications/Rectangle.app")','
echo '    "stats": '(check_dir "/Applications/Stats.app")','
echo '    "itsycal": '(check_dir "/Applications/Itsycal.app")','
echo '    "pandan": '(check_dir "/Applications/Pandan.app")','
echo '    "alt_tab": '(check_dir "/Applications/AltTab.app")','
echo '    "hiddenbar": '(check_dir "/Applications/Hidden Bar.app")
echo '  }'

echo "}"
