# paths.fish - Additional PATH entries for tools with custom install locations

# Bun (installed via curl -fsSL https://bun.com/install | bash)
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

# Deno (installed via curl -fsSL https://deno.land/install.sh | sh)
set -gx DENO_INSTALL $HOME/.deno
fish_add_path $DENO_INSTALL/bin
