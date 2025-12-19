#!/bin/bash

set -e

# Check OS
OS=$(uname -o)

echo "------- Running bootstrap..."

####################
# OS-SPECIFIC BOOTSTRAP
####################

# Determine OS folder
if [[ "$OS" = Darwin ]]; then
  OS_DIR="$DOTFILES/bootstrap/mac"
  echo "------- Running macOS-specific bootstrap scripts from $OS_DIR..."
elif [[ "$OS" =~ Cygwin|Msys|MinGw|MinGW ]]; then
  OS_DIR="$DOTFILES/bootstrap/windows"
  echo "------- Running Windows-specific bootstrap scripts from $OS_DIR..."
else
  echo "Unsupported OS detected: $OS"
  exit 1
fi

# Run OS-specific scripts
set +e
if [ -d "$OS_DIR" ]; then
  for script in "$OS_DIR"/*.sh; do
    [ -e "$script" ] || continue
    if [ -f "$script" ] && [ -x "$script" ]; then
      echo "Running ➡ $script"
      "$script" || echo "Script failed ➡ $script"
    elif [ -f "$script" ]; then
      echo "Sourcing ➡ $script"
      . "$script" || echo "Script (sourced) failed ➡ $script"
    fi
  done
else
  echo "OS-specific directory $OS_DIR not found. Skipping OS-specific bootstrap."
fi
set -e

####################
# UNIVERSAL BOOTSTRAP
####################

set +e
universal_dir="$DOTFILES/bootstrap"
echo "------- Running universal bootstrap scripts from $universal_dir..."

# Run universal scripts (only top-level .sh files, not in subdirectories)
for script in "$universal_dir"/*.sh; do
  [ -e "$script" ] || continue
  # Skip if it's not a file
  [ -f "$script" ] || continue
  
  if [ -x "$script" ]; then
    echo "Running ➡ $script"
    "$script" || echo "Script failed ➡ $script"
  else
    echo "Sourcing ➡ $script"
    . "$script" || echo "Script (sourced) failed ➡ $script"
  fi
done
set -e

echo ""
echo "------- Bootstrap complete!"
