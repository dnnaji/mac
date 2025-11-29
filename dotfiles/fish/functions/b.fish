function b --description "brew maintenance (update, upgrade, cleanup)"
    # Requires: brew install gum

    if not command -q gum
        echo "gum not installed. Run: brew install gum"
        return 1
    end

    echo ""
    gum style --foreground 212 --bold "BREW MAINTENANCE"
    echo ""

    # Update
    gum spin --spinner dot --title "Updating Homebrew..." -- brew update

    # Check outdated
    set -l outdated (brew outdated)
    if test -z "$outdated"
        echo "All packages up to date"
        return 0
    end

    echo "Outdated packages:"
    echo $outdated
    echo ""

    # Confirm upgrade
    if gum confirm "Upgrade all packages?"
        gum spin --spinner dot --title "Upgrading..." -- brew upgrade
        echo "Upgrade complete"
    else
        echo "Skipped upgrade"
    end

    # Cleanup
    gum spin --spinner dot --title "Cleaning up..." -- brew cleanup --prune=all

    # Doctor
    echo ""
    echo "Running brew doctor..."
    brew doctor

    echo ""
    gum style --foreground 212 "Brew maintenance complete"
end
