function cx --description "Codex code review (GPT 5.1)"
    if not type -q codex
        echo "codex not found (install: bun add -g @openai/codex)" >&2
        return 127
    end
    if test (count $argv) -eq 0
        echo "Usage: cx <prompt>" >&2
        return 1
    end
    codex exec --full-auto --skip-git-repo-check -- $argv
end
