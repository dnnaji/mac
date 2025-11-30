function gfetch --description "Gemini web fetch"
    gemini --model gemini-3-pro-preview -p "Use web_fetch(prompt=\"$argv\")" -y
end
