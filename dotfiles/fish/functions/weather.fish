function weather --description "Get weather forecast"
    set -l location $argv[1]
    if test -z "$location"
        curl -s "wttr.in?format=3"
    else
        curl -s "wttr.in/$location?format=3"
    end
end
