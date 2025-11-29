function clone --description "git clone and cd into repo"
    git clone $argv[1]
    if test $status -eq 0
        cd (basename $argv[1] .git)
    end
end
