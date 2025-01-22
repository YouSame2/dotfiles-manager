
# Table of Contents <!-- omit from toc -->
- [🛫 Overview: What the Skibidi is it?](#-overview-what-the-skibidi-is-it)
- [🌟 Highlights](#-highlights)
- [💭 Why Use it](#-why-use-it)
- [🚀 Getting Started](#-getting-started)
    - [Dependencies](#dependencies)
    - [Installation:](#installation)
    - [Recommended Setup](#recommended-setup)
- [🧠 Usage](#-usage)
- [💥 What to Put Where](#-what-to-put-where)
- [🙋🏽‍♂️ FAQ](#️-faq)
- [📖 Resources](#-resources)
- [✏ Contributing](#-contributing)


# 🛫 Overview: What the Skibidi is it?
Simple cross-platform (Mac and Windows) dotfiles manager CLI built on top of dotbot. Lets you have a consistent dev environment by bootstrapping and automatically adding dotfile symlinks to your computers from within the terminal, think GNU Stow (kinda?) but works on windows too!

Soooo... use cases kinda like this:

> *working on windows* "I want my .config folder symlinked to my dotfiles on both Mac and Windows!"
- in terminal run `dotfiles add .config` to symlink your .config folder
  
  ```yaml
  # this will be added to dotbot's install.conf.yaml
  - link:
    ~/.config: .config
  ```
> "I *only* want my ~/AppData/Roaming/fd folder to be symlinked on windows"
- in terminal run `dotfiles add -w ~/AppData/Roaming/fd` to symlink your .config folder
  ```yaml
  # this will be added to dotbot's install.conf.yaml
  - link:
    ~/AppData/Roaming/fd:
    path: AppData/Roaming/fd
    if: "[ `uname` != Darwin ]"
  ```
> *working from pc:* "hey, this is a really cool package/alias! let me add it to my aliases for both Mac and PC."
- add to your .global_rc/.global_aliases file: `alias ls='eza --color=always --icons=always'`
- run `dotfiles yeet` in terminal to ✈ YEET your dotfiles repo to remote (basically git push)
- goto coffee shop (required ;P) and whip out your ***shiny*** mac
- run `dotfiles yank` in mac terminal to *"GET OVAH-HERE"* your dotfiles (basically git pull). Then `dotfiles bootstrap` to add any new packages/fonts/plugins and link any new symlinks you may have added to your dotfiles!
> [!NOTE]
> You can also just run `dotfiles link` to skip bootstrapping and just link symlinks. The decision to keep them separate commands instead of pulling on bootstrap is in case the user (🖐🏽 that's you) had some changes they didn't want to overwrite just yet.

# 🌟 Highlights
Ok, i'll admit, this part sounds way to formal and *may* have been gpt-ed...

- Simple File Management: Easily add files and directories to your dotfiles repository with a single terminal command.

- OS-Specific Symlinks: Define macOS or Windows-specific symlinks for platform-dependent configurations.

- Integrated Bootstrapping: Automatically install fonts, package managers, packages, and tools tailored to macOS or Windows environments.

- Backup current homebrew/choco packages directly to your dotfiles.

- Cross-Platform Support: Aimed at users who frequently switch between macOS and Windows without relying on WSL2.

- Customizable Bootstrapping: Extend the bootstrapping process to install additional plugins or packages.

> [!IMPORTANT]
> For windows you must be using git bash. Cygwin and other emulators might work, but I didn't test them. Probably will require 1 or 2 changes in some if statements.

# 💭 Why Use it
Simply put i *really* I wanted GNU stow or something similar on my windows pc, just some way to make my experience on windows similar to mac. [Chezmoi](https://github.com/twpayne/chezmoi) for some reason didn't work for me so i made this, but feel free to first try CHEZZZZ-moooooiii 🎶 Fuis-moi, le pire, c'est toi et moi 🎶 (kudos if you get the ref)

This leads me to the tinnie tiny elephant in the room... git bash. Yaaa I know, weird. But fr couldn't really find a better solution. I didn't want to go the WSL2 route and well... powershell... "*sheesh, I ain't that crazy*" (kudos x2)

# 🚀 Getting Started
### Dependencies

Make sure the following are installed on your systems
<details>
  <summary>Choco</summary>
  
  https://chocolatey.org/install
  
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'
  ```

</details>

<details>
  <summary>Git (obviously) and git bash</summary>
  
  you should already have this installed. For more info see [📖 Resources](#-resources) "Getting unix commands"

</details>

<details>
  <summary>Dotbot</summary>
  
  https://github.com/anishathalye/dotbot

  Dotbot handles all the backend symlinking and runs off of python. If you dont already have it as a submodule in your dotfiles ill cover that in the Installation section.

</details>

<details>
  <summary>Python</summary>
  hsssss 🐍

</details>

<details>
  <summary>Others</summary>
  The following are needed but get installed during the bootstrap process so you don't need to install them separately.

  - Homebrew
  - Homebrew/bundle
  - YQ

</details>
 
### Installation:

I'm assuming you already have a dotfiles repo setup.

1. add to the top of both .bashrc & .zshrc
   ```shell
   # sourcing universal aliases add to both .bashrc & .zshrc
   source ~/.config/global-rc/.global-rc
   source ~/.config/global-rc/.global-aliases
   ```

2. Add dotbot submodule to your dotfiles repo (if not already added)
   
   In your dotfiles dir run:

   ```shell
   git submodule add https://github.com/anishathalye/dotbot
   git config -f .gitmodules submodule.dotbot.ignore dirty # ignore dirty commits in the submodule
   cp dotbot/tools/git-submodule/install .
   ```

3. Add dotfiles-manager submodule to your dotfiles repo
   
   In your dotfiles dir run:

   ```shell
   git submodule add https://github.com/YouSame2/dotfiles-manager.git
   ```

4. Copy template files
   
   In your dotfiles dir run:

   ```shell
   # does not overright folders/files only adds non existing
   # if you want to use your own install.conf.yaml omit last file from cp
   cp -r dotfiles-manager/.config dotfiles-manager/bootstrap dotfiles-manager/install.conf.yaml .
   ```

5. Add $DOTFILES env to .global-rc

   In the newly copied file `./.config/global-rc/.global-rc` adjust the dotfiles export to point to where your dotfiles dir is located in both pcs. Mine for example looks like this:
   ```shell
   export DOTFILES=~/Repos/Personal/dotfiles
   ```

   If they are different on each pc, delete the entry from .global-rc and set the export in each .bashrc & .zshrc respectively. Ignore this if you already have the env var setup. Then follow one of the below 

6. Add additional packages/commands to bootstrap (optional)

   Add any homebrew recipes and any choco packages you would like to install in the bootstrap process to `$DOTFILES/bootstrap/mac/brewfile` & `$DOTFILES/bootstrap/windows/packages.config` respectively. **Do not** remove any.

   Add any additional commands/plugins you would like to install with the bootstrap process to the bottom of `$DOTFILES/bootstrap/bootstrap.sh` under 'echo "------- Bootstrapping plugins..."'

  > [!NOTE]
  > Check out my personal [dotfiles](https://github.com/YouSame2/dotfiles) for ideas/references.

7. Run bootstrap

   Restart your preferred terminal (not powershell you freak!), and run `dotfiles bootstrap` to begin installing packages, running bootstrap commands, and finally running through your dotbot playbook (install.conf.yaml).

   Running this initially is necessary to install required packages for dotfiles add to work properly.

One final note: if you don’t want to keep copies of the templates in the submodule to avoid confusion, you could achieve this without adding the submodule. However, at that point, you likely already know what you’re doing.
    
### Recommended Setup

Ofcourse dotfiles manager will work for just managing your dotfiles and bootstrapping even if you don't want cross platform support. But to truly synchronize your dev environment across mac and windows here is the recommended setup a.k.a. how i use it.

Obviously you're going to want to use cross platform packages as much as possible so starting top down:
- **Terminal Emulator:** Wezterm
- **Shell:** Git Bash on Windows, Zsh or Bash on Mac (I prefer Zsh but if you truly want the same env go with bash)
- **Prompt:** Not needed but i prefer Starship
- **Package Managers:** Use brew and choco as much as possible. The caveat is (currently) I have no way of syncing packages across brew and choco. So anytime im going to add a new package i just copy both brew and choco installs and add it to the respective backup file in bootstrap/
- **Fonts:** Add any fonts you want into bootstrap/fonts
- **Editor:** Duh...

# 🧠 Usage

**Usage:**

`dotfiles <command> [options] <target>`


| Command         | Description                                                                                          |
|-----------------|------------------------------------------------------------------------------------------------------|
| `add`           | Add a file or directory to the dotfiles repository and configure it for symlinking. Available options:<br>`-m`: Set the target symlink to apply only on macOS.<br>`-w`: Set the target symlink to apply only on Windows.|
| `link`          | Rerun the dotbot configuration to ensure all symlinks are created or updated.| 
| `yeet`          | Add all changes, commit, and push to the remote repository. Any [options] that come after yeet get passed straight to `git commit` as args. Note -m option for `add` does not apply to `yeet` and instead gets interpreted by git as a commit message. If no args are passed, the commit message defaults to 'YEET dotfiles'.|
| `yank`          | Pull the latest changes from the remote dotfiles repository.|
| `-h`<br>`--help`  | Display the help message. Basically what you're reading rn.|
| `bootstrap`          | *WORK IN PROGRESS* |
| `backup`          | *WORK IN PROGRESS* |

**Examples**

```bash
# Add config.lua and configure it for all platforms
dotfiles add config.lua 

# Add config.lua and configure it for macOS only
dotfiles add -m config.lua

# Add config.lua and configure it for Windows only
dotfiles add -w config.lua

# Ensure all symlinks are created or updated
dotfiles link

# Commit all changes with the default message and push
dotfiles yeet

# Commit all changes with a custom git commit args and push
dotfiles yeet -m 'Fix issue'

# Pull the latest changes from the remote repository
dotfiles yank
```

# 💥 What to Put Where
Ight i'll make this quick cuz I'm tired of writing, but I get that this can be a bit confusing at first. Let me break it down John.

1. Make sure to set DOTFILES env somewhere in your rc's (recommend .global-rc)
2. Make sure to source `.global-rc` and `.global-aliases` in .bashrc & .zshrc
3. Now anything (aliases/functions/exports/etc) you want to get sourced in both Windows and Mac you add to its respective ./.config/global/ file
4. Mac only sourcing add directly to .zshrc
5. Windows only sourcing add to .bashrc
6. Think of the root of your dotfiles folder as `~` whatever you `dotfiles add` will get placed in there with the respective relative path from `~` (*unless* you manually add it to install.conf.yaml for more complex symlinks)
   - custom dotbot symlinking/playbooking add in ➡ ./install.conf.yaml
7. Bootstrap/ folder is important. This contains all the brew/choco recipes, fonts, and other commands you want to get executed/bootstrapped when you run `dotfiles bootstrap` or backed up in `dotfiles backup`
   - fonts go in ➡ ./bootstrap/fonts
   - homebrew recipes go in ➡ ./bootstrap/mac/brewfile
   - choco installs go in ➡ ./bootstrap/windows/package.config
   - custom commands/plugins go in ➡ ./bootstrap/customs.sh
   > [!TIP]
   > Currently no method of matching brew recipes with choco installs. Next time you're installing a package just copy both, paste in bootstrap, then run dotfiles bootstrap. 👍🏽

# 🙋🏽‍♂️ FAQ
- **How do I update dotfiles-manager submodule?**

  from dotfiles run `git submodule update --remote`

- **Dotbot cannot link symlinks?**

  I had this happen to me too, its annoying but you need to run terminal as admin

# 📖 Resources

- similar concept:
  
  https://gilbertsanchez.com/posts/terminals-shells-and-prompts/
  
- getting unix commands on windows powershell (towards bottom of page)
  
  https://medium.com/@GalarnykMichael/install-git-on-windows-9acf2a1944f0
  
  https://medium.com/@thopstadredner/transforming-your-windows-terminal-into-a-mac-like-experience-1ec95d206114

- wezterm os detection. The most common triples are:

  for more information see docs: https://wezfurlong.org/wezterm/config/lua/wezterm/target_triple.html?h=windows
  - x86_64-pc-windows-msvc - Windows
  - x86_64-apple-darwin - macOS (Intel)
  - aarch64-apple-darwin - macOS (Apple Silicon)
  - x86_64-unknown-linux-gnu - Linux

# ✏ Contributing

If it's not obvious enough, this was my first bash script/project so still a lot to learn. If you want to contribute I'd love the help! You can start by checking out the TODOs listed below or the sections marked with *CONTRIBUTE* in the scripts where I had questions/uncertainties. Or if you're a G and have a cool idea to add, I’d love to hear it!

Clone ➡ New Branch ➡ PR

**TODOS:**
- [x] consolidate dotfiles-add and dotfiles-sync into the same script taking args. So instead you use it like a normal cli: i.e. dotfiles add -m file1.lua
- [x] change format of yaml yq command so you can choose to specify if a committed dotfile should be MAC/WINDOWS/BOTH (-m -w) specific
- [x] change dotfiles-sync name (maybe link?)
- [x] change dotfiles-link function in script and aliases
- [x] fix git functionality and test it
- [x] add if statements for os specific symlinks
- [x] separate personal dotfiles
- [x] refactor project to be a submodule for easy integration
- [x] dotfiles bootstrap option
- [x] dotfiles backup option
- [ ] match brew installs with corresponding choco install
- [ ] when adding a file/folder with no OS_FLAG (i.e. 'dotfiles add .config') in 'install.conf.yaml', if that file/folder already had an if statement the if statement won't get removed. This can lead to some unexpected behavior in rare situations. I'm probably not going to deal with it since it's niche, but feel free for a simple contribution if you want.
