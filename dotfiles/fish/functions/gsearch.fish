function gsearch --description "Gemini web search"
    if not type -q gemini
        echo "gemini not found (install: bun add -g @google/gemini-cli)" >&2
        return 127
    end
    if test (count $argv) -eq 0
        echo "Usage: gsearch <query>" >&2
        return 1
    end
    gemini --model gemini-3-pro-preview -p "Use google_web_search(query=\"$argv\")" -y
end
