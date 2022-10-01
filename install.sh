#!/bin/bash
# ./install.sh

# initial setup of the CLI

SOURCE_STRING="source $(pwd)/src/global-cli.sh"

# check if source command already exists in file
if ! grep -Fxq "$SOURCE_STRING" $HOME/.bash_profile; then
  echo "Modifying "$HOME"/.bash_profile..."
  echo "$SOURCE_STRING" >> $HOME/.bash_profile
else
  echo ""$HOME"/.bash_profile already updated."
fi

if ! grep -Fxq "$SOURCE_STRING" $HOME/.zprofile; then
  echo "Modifying "$HOME"/.zprofile..."
  echo "$SOURCE_STRING" >> $HOME/.zprofile
else
  echo ""$HOME"/.zprofile already updated."
fi

