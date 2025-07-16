#!/bin/bash

echo -e "\n==== GITHUB DEPLOY KEY SETUP ====\n"

# Prompt for the SSH repo URL
read -p "Enter the SSH repo URL (e.g., git@github.com:user/repo.git): " REPO_URL

# Basic validation
if [[ ! "$REPO_URL" =~ ^git@github.com:.*\.git$ ]]; then
  echo "Error: Invalid URL format. It should be in SSH format, e.g., git@github.com:user/repo.git"
  exit 1
fi

# Extract repo and user name
REPO_FULL_NAME=$(echo "$REPO_URL" | cut -d':' -f2 | sed 's/.git$//')
REPO_USER=$(echo "$REPO_FULL_NAME" | cut -d'/' -f1)
REPO_NAME=$(echo "$REPO_FULL_NAME" | cut -d'/' -f2)

# Suggested values
DEFAULT_KEY_NAME="github_deploy_${REPO_NAME//-/_}"
DEFAULT_ALIAS="github-${REPO_NAME//_/-}"

# Prompt for SSH key name
read -p "SSH key file name [${DEFAULT_KEY_NAME}]: " KEY_NAME
KEY_NAME=${KEY_NAME:-$DEFAULT_KEY_NAME}

# Prompt for SSH config alias
read -p "SSH config alias [${DEFAULT_ALIAS}]: " REPO_ALIAS
REPO_ALIAS=${REPO_ALIAS:-$DEFAULT_ALIAS}

# Paths
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"

# Ensure .ssh exists
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generate the key if it doesn't exist
if [[ -f "$KEY_PATH" ]]; then
  echo "Key $KEY_PATH already exists. It will not be overwritten."
else
  ssh-keygen -t rsa -b 4096 -C "deploy-key-${REPO_NAME}" -f "$KEY_PATH" -N ""
fi

# Add SSH config entry if it doesn't exist
CONFIG_ENTRY="Host $REPO_ALIAS
    HostName github.com
    User git
    IdentityFile $KEY_PATH
"

if ! grep -q "$REPO_ALIAS" "$SSH_DIR/config" 2>/dev/null; then
  echo "$CONFIG_ENTRY" >> "$SSH_DIR/config"
  chmod 600 "$SSH_DIR/config"
  echo "SSH config entry added for '$REPO_ALIAS'."
else
  echo "SSH config entry for '$REPO_ALIAS' already exists."
fi

# Show public key to copy
echo -e "\n--- COPY THE FOLLOWING PUBLIC KEY AND ADD IT TO GITHUB AS A DEPLOY KEY ---\n"
cat "${KEY_PATH}.pub"

# Ask to clone
echo ""
read -p "Do you want to clone the repository now? (y/n): " CLONE_NOW

if [[ "$CLONE_NOW" =~ ^[Yy]$ ]]; then
  read -p "Enter the path where the repository should be cloned: " CLONE_PATH

  if [[ -z "$CLONE_PATH" ]]; then
    echo "No path entered. Skipping clone."
    exit 0
  fi

  if [[ -e "$CLONE_PATH" ]]; then
    read -p "Warning: '$CLONE_PATH' already exists. Overwrite? (y/n): " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
      echo "Aborting clone to avoid overwriting existing directory."
      exit 0
    else
      rm -rf "$CLONE_PATH"
    fi
  fi

  echo -e "\nCloning into: $CLONE_PATH"
  git clone "git@${REPO_ALIAS}:${REPO_FULL_NAME}.git" "$CLONE_PATH"
  if [[ $? -eq 0 ]]; then
    echo "Repository cloned successfully."
  else
    echo "Error while cloning. Make sure the Deploy Key has been added in GitHub."
  fi
else
  echo -e "\nYou can later clone using:"
  echo "git clone git@${REPO_ALIAS}:${REPO_FULL_NAME}.git"
fi

# Final message
echo -e "\n--- Made with love from the Dominican Republic by SmartTec ---"
echo "Visit us at https://smarttec.com.do"