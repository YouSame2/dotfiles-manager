- [Prerequisites:](#prerequisites)
- [Windows:](#windows)
  - [1. Clone Dotfiles Repo](#1-clone-dotfiles-repo)
  - [2. CHOCOLATEY](#2-chocolatey)
  - [3. Install DotBot](#3-install-dotbot)
  - [4. Update Submodule](#4-update-submodule)
  - [5. Run Dotbot](#5-run-dotbot)
  - [6. Install Nerd Fonts](#6-install-nerd-fonts)
  - [7. Explainations](#7-explainations)
- [Helpful Resources:](#helpful-resources)
- [TODO:](#todo)


# Prerequisites:

- dotbot
- yq

# Windows:

so far this is what ive done to get this to work on windows. Im still in the process making it.

In evalated PS:

## 1. Clone Dotfiles Repo

## 2. CHOCOLATEY
   ```
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

## 3. Install DotBot

   ```pip install dotbot```

## 4. Update Submodule

   ```git submodule update --init --recursive```

## 5. Run Dotbot

   ```dotbot -c install.conf.yaml```

## 6. Install Nerd Fonts

## 7. Explainations

   - Shells & Aliases
   
     setting aliases across mac and windows is a bit scuffed so in the end i settled on this:

     windows i use git bash as my shell (currently, unless i find something better without WSL) and mac i use default zsh. doing this means both shells are fairly similar so i dont have to remember "oh, what was ls in windows again?"

     for aliases since windows uses bash and mac uses zsh just put os specific aliases in there corresponding dotfile. for universal aliases (that work on both platforms) put it into .config/aliases/.universal_aliases. this file is then sourced in both .zshrc and .bashrc 🤯


# Helpful Resources:

- similar concept:
  
  https://gilbertsanchez.com/posts/terminals-shells-and-prompts/
  
- getting unix commands on windows powershell (towards bottom of page)
  
  https://medium.com/@GalarnykMichael/install-git-on-windows-9acf2a1944f0
  
  https://medium.com/@thopstadredner/transforming-your-windows-terminal-into-a-mac-like-experience-1ec95d206114

- wezterm os detection:

  The most common triples are:
  x86_64-pc-windows-msvc - Windows
  x86_64-apple-darwin - macOS (Intel)
  aarch64-apple-darwin - macOS (Apple Silicon)
  x86_64-unknown-linux-gnu - Linux

  for more information see docs: https://wezfurlong.org/wezterm/config/lua/wezterm/target_triple.html?h=windows


# TODO:

still a lot to do as im learning bash and terminal.

- [ ] consolodate dotfiles-add and dotfiles-sync into the same script taking args. So instead you use it like a normal cli: i.e. dotfiles add -m file1.lua
- [ ] change format of yaml yq command so you can choose to specify if a committed dotfile should be MAC/WINDOWS/BOTH (-m -w) specific
- [ ] change dotfiles-sync name (maybe link?)
- [ ] add dotfiles pull and dotfiles push to push and pull to remote repo