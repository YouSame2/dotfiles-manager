# Windows:

so far this is what ive done to get this to work on windows. Im still in the process making it.

In evalated PS:

1. Clone Dotfiles Repo

2. CHOCOLATEY
> Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

3. Install DotBot
> pip install dotbot

4. Update Submodule
> git submodule update --init --recursive

5. Run Dotbot
> dotbot -c install.conf.yaml

6. Install Nerd Fonts