#!/bin/bash

set -e

# Check OS
OS=$(uname -o)

####################
# FONTS
####################

# i noooo... nested if statment wholesale. dont feel like refactoring. bite me!
install_fonts() {
  if [ -d "$DOTFILES/bootstrap/fonts" ]; then
    echo "------- Bootstrapping fonts from $DOTFILES/bootstrap/fonts directory..."
    for font in "$DOTFILES"/bootstrap/fonts/*; do
      if [ -f "$font" ]; then

        # windows part
        if [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then
          if [[ ! -f "C:/Windows/Fonts/$(basename "$font")" ]]; then
            cp "$font" 'C:/Windows/Fonts/' &&
              echo "Successfully installed ➡ $font" || echo "Failed to install ➡ $font"
          else
            echo "Already installed ➡ ($(basename "$font"))"
          fi

        # mac part
        elif [[ "$OS" = Darwin ]]; then
          if [[ ! -f "$HOME/Library/Fonts/$(basename "$font")" ]]; then
            cp "$font" ~/Library/Fonts/ &&
              echo "Successfully installed ➡ $font" || echo "Failed to install ➡ $font"
          else
            echo "Already installed ➡ ($(basename "$font"))"
          fi
        else
          echo "Unsupported OS detected: $OS"
          exit 1
        fi
      fi
    done
  else
    echo "Fonts directory $DOTFILES/bootstrap/fonts not found or no fonts. Skipping font installation."
  fi
}

install_fonts # Run before stuff

####################
# MAC
####################

if [[ "$OS" = Darwin ]]; then
  echo ""
  echo "------- Bootstrapping Mac..."

  # Check if Homebrew is installed
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
      echo "Successfully installed ➡ Homebrew" ||
      {
        echo "Error installing homebrew, please install manually"
        exit 1
      }
    echo ''

  else
    echo "Homebrew (brew) already installed, yippie!"
  fi

  # Check if Homebrew Bundle is installed
  if ! brew tap | grep -q -i "Homebrew/bundle"; then
    echo "Homebrew bundle tap not found. Installing Homebrew bundle..."
    brew tap Homebrew/bundle
    echo ''
  fi

  # Check for Brewfile
  if [ -f "$DOTFILES/bootstrap/mac/Brewfile" ]; then
    echo "Found Brewfile. Installing packages..."
    brew bundle -v --file="$DOTFILES/bootstrap/mac/Brewfile"
  else
    echo "Brewfile not found in $DOTFILES/bootstrap/mac/. Please provide a Brewfile."
  fi

  echo ""
  echo "------- Bootstrapping Node and fnm..."

  # Install fnm and Node.js
  command -v fnm >/dev/null && echo "fnm found, skipping.." || {
    echo 'installing fnm...'
    curl -o- https://fnm.vercel.app/install | bash
  }
  command -v node >/dev/null && echo "node found, skipping..." || {
    echo 'installing Node.js v22...'
    fnm install 22
  }

####################
# WINDOWS
####################

# TODO: add winget and its packages to bootstrap (eza,yazi)

elif [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then
  echo ""
  echo "------- Bootstrapping Windows"

  # Check if choco is installed
  if ! command -v choco &>/dev/null; then
    echo "Chocolatey (choco) is not installed. Installing choco is a bit more complicated so please install Chocolatey first."
    exit 1
  else
    echo "Chocolatey (choco) already installed, yippie!"
  fi

  # Check if choco export file exists
  if [ -f "$DOTFILES/bootstrap/windows/packages.config" ]; then
    echo "Found packages.config. Installing packages..."
    choco install "$DOTFILES"/bootstrap/windows/packages.config
  else
    echo "packages.config not found in $DOTFILES/bootstrap/windows/. Please provide a valid choco export file. choco export [<options/switches>]"
    echo "see choco docs for export command"
    exit 1
  fi

else
  echo "Unsupported OS detected: $OS"
  exit 1
fi

echo ""
echo "------- Bootstrapping Node and fnm..."

# Install fnm and Node.js
command -v fnm >/dev/null && echo "fnm found, skipping..." || {
  echo 'installing fnm...'
  winget install Schniz.fnm
}
command -v node >/dev/null && echo "node found, skipping..." || {
  echo 'installing Node.js v22...'
  fnm install 22
}

####################
# NPM PACKAGES
####################

echo ""
echo "------- Bootstrapping NPM global packages..."

NPM_PACKAGES_FILE="$DOTFILES/bootstrap/npm-packages.txt"

if [ ! -f "$NPM_PACKAGES_FILE" ]; then
  echo "npm-packages.txt not found in $DOTFILES/bootstrap/. Skipping global npm package installation."

# Check if npm is installed
elif ! command -v npm &>/dev/null; then
  echo "npm not found. Skipping global npm package installation."

else
  echo "Found npm-packages.txt"
  while IFS= read -r pkg; do
    # trim stray \r and whitespace
    pkg="${pkg//$'\r'/}"
    pkg="${pkg#"${pkg%%[![:space:]]*}"}"
    pkg="${pkg%"${pkg##*[![:space:]]}"}"
    [ -z "$pkg" ] && continue

    if npm ls -g --depth=0 "$pkg" >/dev/null 2>&1; then
      echo "$pkg already installed, skipping..."
    else
      echo "$pkg not found, installing..."
      npm install --global "$pkg" || echo "Failed to install $pkg"
    fi
    # stripping carrage return
  done < <(tr -d '\r' <"$NPM_PACKAGES_FILE")
fi

####################
# EXTRAS
####################

set +e
extras_file="$DOTFILES"/bootstrap/extras.sh
[[ -e "$extras_file" ]] &&
  echo "------- Bootstrapping extras..." &&
  . "$extras_file"
set -e

echo ""
echo "------- Bootstrapping complete, please restart terminal..."
