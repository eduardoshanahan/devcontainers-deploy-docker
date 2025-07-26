#!/bin/bash

# Load environment variables from .devcontainer/.env
if [ -f .devcontainer/.env ]; then
    export $(grep -v '^#' .devcontainer/.env | xargs)
    grep -v '^#' .devcontainer/.env
fi

# Source the SSH agent setup script from the .devcontainer directory.
if [ -f ".devcontainer/ssh-agent-setup.sh" ]; then
    source ".devcontainer/ssh-agent-setup.sh"
    echo "SSH agent setup script found and sourced."
else
    echo "SSH agent setup script not found in .devcontainer directory."
fi

# Verify that environment variables are set
echo $HOST_USERNAME
echo $HOST_UID
echo $HOST_GID
echo $GIT_USER_NAME
echo $GIT_USER_EMAIL
ssh-add -l

# Launch VS Code
code .
