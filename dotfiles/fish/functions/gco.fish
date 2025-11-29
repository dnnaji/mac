function gco --description "Git checkout with fzf branch selection"
    if not command -q fzf
        echo "fzf not installed"
        return 1
    end

    set -l branch (git branch -a --format='%(refname:short)' | fzf --height 40% --reverse)
    if test -n "$branch"
        git checkout $branch
    end
end
