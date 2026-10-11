#!/bin/bash
cmd='source ~/.config/zsh/zshrc'
rc="$HOME/.zshrc"
found=$(grep "$cmd" ~/.zshrc 2>/dev/null)
if [[ -z "$found" ]]; then
  echo "Adding '$cmd' to $rc"
  echo "$cmd" >>"$rc"
else
  echo "'$cmd' already present in $rc"
fi
