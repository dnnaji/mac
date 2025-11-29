function i --description "cd to ~/i/ dev directory"
    if test (count $argv) -eq 0
        cd ~/i
    else
        cd ~/i/$argv[1]
    end
end
