# try - Fresh directories for experiments
# https://github.com/tobi/try
# Install: curl -sL https://raw.githubusercontent.com/tobi/try/refs/heads/main/try.rb > ~/.local/bin/try && chmod +x ~/.local/bin/try
if test -x ~/.local/bin/try
    SHELL=fish eval (~/.local/bin/try init ~/r | string collect)
end
