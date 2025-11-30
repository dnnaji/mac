function r --description "cd to ~/r/ reproductions directory"
    if test (count $argv) -eq 0
        cd ~/r
    else
        cd ~/r/$argv[1]
    end
end
