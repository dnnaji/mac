function cloner --description "clone to ~/r/ and open in editor"
    set -l original_dir (pwd)
    cd ~/r
    git clone $argv[1]
    if test $status -eq 0
        set -l repo (basename $argv[1] .git)
        cd $repo
        cursor .
    else
        cd $original_dir
    end
end
