function gsha --description "copy HEAD SHA to clipboard"
    set -l sha (git rev-parse HEAD)
    echo $sha | pbcopy
    echo "Copied: "(git rev-parse --short HEAD)
end
