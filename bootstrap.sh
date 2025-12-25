#!/bin/bash

set -e

# OS and OS_TYPE are expected to be set by `dotfiles.sh` (sourced)

echo "------- Running bootstrap..."

####################
# USER CONFIRMATIONS
####################

# Allow skipping interactive confirmations by setting DOTFILES_ASSUME_YES=1
if [ "${DOTFILES_ASSUME_YES:-}" != "1" ]; then
  echo "WARNING: This bootstrap may overwrite files or change your system. Double check your bootstrap files before continuing." >&2
  read -r -p "Do you want to continue? (y/N) " reply
  case "$reply" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) echo "Aborted by user."; exit 1 ;;
  esac

  # Very emphasized second confirmation
  cat <<'EOFWARN'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!  VERY IMPORTANT: THIS ACTION CAN OVERWRITE FILES, REMOVE DATA, OR MODIFY  !!!
!!!  YOUR SYSTEM. THIS IS IRREVERSIBLE UNLESS YOU HAVE BACKUPS.               !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOFWARN

  # Second confirmation (yes/no) — emphasized but simple
  read -r -p "Are you ABSOLUTELY SURE you want to proceed? This may overwrite data. (y/N) " reply2
  case "$reply2" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) echo "Aborted by user."; exit 1 ;;
  esac
fi

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
elif [[ "$OS" =~ Linux ]]; then
  OS_DIR="$DOTFILES/bootstrap/linux"
  echo "------- Running Linux-specific bootstrap scripts from $OS_DIR..."
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
