function ports --description "Show listening ports"
    if test (count $argv) -eq 0
        lsof -iTCP -sTCP:LISTEN -n -P
    else
        lsof -iTCP:$argv[1] -sTCP:LISTEN -n -P
    end
end
