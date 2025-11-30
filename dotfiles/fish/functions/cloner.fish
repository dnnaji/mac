function cloner --description "clone to ~/r/ and open in editor"
    set -l original_dir (pwd)
    set -l target_dir ~/r

    if not test -d $target_dir
        mkdir -p $target_dir
        if test $status -ne 0
            echo "cloner: unable to create $target_dir" >&2
            return 1
        end
    end

    if not cd $target_dir
        echo "cloner: could not enter $target_dir" >&2
        return 1
    end

    git clone $argv[1]
    if test $status -eq 0
        set -l repo (basename $argv[1] .git)
        cd $repo
        cursor .
    else
        cd $original_dir
    end
end
