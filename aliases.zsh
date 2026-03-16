### COLORS ###
alias ls='ls --color=tty'
if command -v gdircolors >/dev/null 2>&1; then
    eval "$(gdircolors)"
elif command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors)"
fi
