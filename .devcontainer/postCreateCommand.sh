#!/bin/zsh

set -e

python3 /workspaces/rds-backend/.devcontainer/setupVenv.py
# echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/workspaces/waveflow/.devcontainer/.zsh_history" >> ~/.zshrc
# echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/workspaces/waveflow/.devcontainer/.bash_history" >> ~/.bashrc
exit
