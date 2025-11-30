function gsearch --description "Gemini web search"
    gemini --model gemini-3-pro-preview -p "Use google_web_search(query=\"$argv\")" -y
end
