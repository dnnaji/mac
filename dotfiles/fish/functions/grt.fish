function grt --description "cd to git repo root"
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root"
        cd $root
    else
        echo "Not in a git repository"
        return 1
    end
end
