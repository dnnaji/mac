function gfetch --description "Gemini web fetch"
    if not type -q gemini
        echo "gemini not found (install: bun add -g @google/gemini-cli)" >&2
        return 127
    end
    if test (count $argv) -eq 0
        echo "Usage: gfetch <prompt with URLs>" >&2
        return 1
    end
    gemini --model gemini-3-pro-preview -p "Use web_fetch(prompt=\"$argv\")" -y
end
