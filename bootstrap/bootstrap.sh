#!/bin/bash

set -e

# Check OS
OS=$(uname -o)

####################
# FONTS
####################

install_fonts() {
    if [ -d "./fonts" ]; then
        echo "------- Installing fonts from './fonts' directory..."
        for font in ./fonts/*; do
            if [ -f "$font" ]; then
                if [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then
                    cp "$font" 'C:/Windows/Fonts/' && \
                    echo "Successfully installed: $font" || echo "Failed to install: $font"
                elif [[ "$OS" = Darwin ]]; then
                    cp "$font" ~/Library/Fonts/ && \
                    echo "Successfully installed: $font" || echo "Failed to install: $font"
                else
                    echo "Unsupported OS detected: $OS"
                    exit 1
                fi
            fi
        done
    else
        echo "Fonts directory './fonts' not found or no fonts. Skipping font installation."
    fi
}

# install_fonts # Run before stuff

####################
# MAC
####################

if [[ "$OS" = Darwin ]]; then
    echo ""
    echo "macOS detected."

    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."

        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
        echo "Successfully installed: Homebrew" || \
        { echo "Error installing homebrew, please install manually"; exit 1; }
        echo ''
    fi

    # Check if Homebrew Bundle is installed
    if ! brew tap | grep -q "Homebrew/bundle"; then
        echo "Homebrew bundle tap not found. Installing Homebrew bundle..."
        brew tap Homebrew/bundle
        echo ''
    fi

    # Check for Brewfile
    if [ -f "./mac/Brewfile" ]; then
        echo "Found Brewfile. Installing packages..."
        cd ./mac
        brew bundle
    else
        echo "Brewfile not found in './mac/'. Please provide a Brewfile."
        exit 1
    fi

####################
# WINDOWS
####################

elif [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then
    echo ""
    echo "Windows detected."

    # Check if choco is installed
    if ! command -v choco &>/dev/null; then
        echo "Chocolatey (choco) is not installed. Installing choco is a bit more complicated so please install Chocolatey first."
        exit 1
    else
        echo "Chocolatey (choco) already installed yippie!"
    fi

    # Check if choco export file exists
    if [ -f "./windows/packages.config" ]; then
        echo "Found packages.config. Installing packages..."
        choco install ./windows/packages.config
    else
        echo "packages.config not found in './windows/'. Please provide a valid choco export file. choco export [<options/switches>]"
        echo "see choco docs for export command"
        exit 1
    fi

else
    echo "Unsupported OS detected: $OS"
    exit 1
fi
