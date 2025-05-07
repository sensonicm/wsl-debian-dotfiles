# dotfiles for Windows WSL development

The repository contains my dotfiles and instructions for basic setup of the developer environment in the [Windows for Linux (WSL)][1] system.

[1]: https://learn.microsoft.com/en-us/windows/wsl/

## Table of content

- [dotfiles for Windows WSL development](#dotfiles-for-windows-wsl-development)
  - [Table of content](#table-of-content)
  - [Initial setup](#initial-setup)
    - [Install WSL command](#install-wsl-command)
    - [Setting up Git](#setting-up-git)
    - [Setting up ZSH](#setting-up-zsh)
    - [Setting up the Alacritty terminal](#setting-up-the-alacritty-terminal)
  - [Installing programming languages](#installing-programming-languages)
    - [Python](#python)
    - [Node.js](#nodejs)
    - [Typescript](#typescript)
    - [Go](#go)
    - [Rust](#rust)
  - [Setting up additional programs](#setting-up-additional-programs)
    - [Tmux](#tmux)
    - [Lazygit](#lazygit)
    - [Nvim](#nvim)
    - [Eza](#eza)
    - [Yazi](#yazi)
  - [Backup WSL configuration](#backup-wsl-configuration)
    - [Create WSL Backup](#create-wsl-backup)
    - [Restore WSL Backup](#restore-wsl-backup)
  - [Installing additional Windows software](#installing-additional-windows-software)
    - [Git for Windows](#git-for-windows)
    - [Google chrome](#google-chrome)
    - [Obsidian](#obsidian)
    - [Visual Studio Code](#visual-studio-code)
    - [Birman layout](#birman-layout)

## Initial setup

In this configuration I use _Debian Linux_ distribution in _WSL subsystem_. To control _WSL subsystem_ I use _Alakritty terminal_, which integrates well with _WSL subsystem_ and has flexible settings.

- [Install WSL command](#install-wsl-command)
- [Setting up Git](#setting-up-git)
- [Setting up ZSH](#setting-up-zsh)
- [Setting up the Alacritty terminal](#setting-up-the-alacritty-terminal)

### Install WSL command

---

In my work I use _Debian Linux_ as a _WSL subsystem_ and all the specified commands are applicable to this system.

> Detailed information on activating _WSL_ in _Windows_ and additional parameters can be found on the page: [How to install Linux on Windows with WSL][2]

[2]: https://learn.microsoft.com/en-us/windows/wsl/install

Open _PowerShell_ or _Windows Command Prompt_ in administrator mode by right-clicking and selecting "Run as administrator", enter the command, then restart your machine.

```powershell
wsl --install -d Debian
```

You can check that the _Debian Linux_ distribution has been successfully installed using the command:

```powershell
wsl -l -v
```

The `wsl` command in the _PowerShell terminal_ launches the _Debian Linux_ subsystem. During the initial boot, you will be prompted to create a _Linux user_. Specify the username and password (with confirmation), after which the _Debian Linux_ operating system will boot.

After _Debian Linux_ has loaded, you need to update the package manager:

```bash
sudo apt update
```

And install the necessary packages:

```bash
sudo apt install -y git tree zsh gpg pass zip unzip curl wget tmux gcc bsdmainutils htop fzf bat ripgrep build-essential net-tools
```

### Setting up Git

---

In the console of the _WSL subsystem_, you need to set the basic parameters for the `Git`.

```bash
git config --global user.name "Your Name"
```

```bash
git config --global user.email "Your email adress"
```

```bash
git config --global core.quotepath false
```

The global parameter `core.quotepath false` is used to eliminate the conflict with _Cyrillic characters_ in Windows.

For correct operation of `Git`, you need to install _ssh keys_ in the _WSL subsystem_. To do this, create a `.ssh` folder and copy your keys there (if they exist), and if they do not exist, then [create new ones][3].

[3]: https://docs.github.com/ru/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

```bash
mkdir -p ~/.ssh
```

You need to check the access rights to the key files and the owner (should be the same as our _Debian user_).

```bash
sudo chmod 600 ~/.ssh/SSHKeyFileName
```

```bash
sudo chmod 644 ~/.ssh/SSHPubKeyFileName.pub
```

```bash
sudo chown USER:GROUP ~/.ssh/SSHKeyFileName
```

```bash
sudo chown USER:GROUP ~/.ssh/SSHPubKeyFileName.pub
```

Checking the connection with `Git` via `ssh`:

```bash
ssh -T git@github.com
```

The response you receive should contain your nickname, example:

> Hi sensonicm! You've successfully authenticated, but GitHub does not provide shell access.

### Setting up ZSH

---

Clone the _Git repository_ with dotfiles into the `.config` folder:

```bash
git clone git@github.com:sensonicm/wsl-debian-dotfiles.git ~/.config
```

_Oh My Zsh_ is installed by running one of the [commands](https://ohmyz.sh/#install) in your terminal:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Connect configuration files:

```bash
echo "source \$HOME/.config/zsh/env.zsh" >> ~/.zshrc
```

```bash
echo "source \$HOME/.config/zsh/aliases.zsh" >> ~/.zshrc
```

> You need to open the files: `~/.config/zsh/aliases.zsh` and change the user name in all paths to the one you use.

Download the `Powerlevel 10k theme`:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Open the `.zshrc` file in the editor unkomment the $PATH:

```bash
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
```

And change the design theme:

```bash
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Reboot the Shell and the next time you start it, run the theme change, set it up the way you like:

```bash
exec zsh
```

Download and install additional _ZSH plugins_:

zsh-autosuggestions:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

and zsh-syntax-highlighting:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Open the `.zshrc` file in the editor and add `Plugins`:

```bash
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
z
docker
fzf
history
zsh-autosuggestions
zsh-syntax-highlighting
)
```

Reboot the shell:

```bash
exec zsh
```

### Setting up the Alacritty terminal

---

Download the _Alacritty_ installation file from the [official website](https://alacritty.org/) and install the application in Windows.

On the [font download page](https://www.nerdfonts.com/font-downloads), find the **_MesloLG Nerd Font Mono_** font and download the archive. Unpack and install the font in Windows.

In the _WSL subsystem_, download the repository with the design theme for the _Alacrity_ terminal.

```bash
cd ~
```

```bash
git clone https://github.com/alacritty/alacritty-theme.git
```

In _WSL_, some _Windows_ folders are mounted in the subsystem for convenient interaction. In the _WSL console_, we will create a folder for the configuration files of the _Alacritty_ terminal.

```bash
mkdir -p /mnt/c/Users/WinUserName/AppData/Roaming/alacritty
```

Here `c` is the letter assigned to the Windows partition, and `WinUserName` is the your _Windows_ user name.

Let's copy the configuration for _Alacritty_ there:

```bash
cp .config/alacritty/alacritty.toml /mnt/c/Users/WinUserName/AppData/Roaming/alacritty/
```

And move the folder with the _Alacritty_ theme files there too:

```bash
mv alacritty-theme/ /mnt/c/Users/WinUserName/AppData/Roaming/alacritty/
```

Open the _Alacritty_ configuration file `/mnt/c/Users/WinUserName/AppData/Roaming/alacritty/alacritty.toml` and change the `WinUserName` to your _Windows username_. You can also change the theme name `catppuccin_macchiato.toml`. You can see the names of the design themes and how they look visually [here](https://github.com/alacritty/alacritty-theme).

Now we launch the _Alacritty_ terminal, it is launched immediately in the `~` home directory of the _Debian Linux_ user in the _WSL subsystem_, since the directive is specified in the _Alacritty_ configuration file `alacritty.toml`:

```bash
[terminal]
shell = { program = "wsl", args = ["-d", "Debian", "--cd", "~" ] }
```

## Installing programming languages

- [Python](#python)
- [Node.js](#node.js)
- [Typescript](#typescript)
- [Go](#go)
- [Rust](#rust)

### Python

---

Let's add packages with source codes to the list of sources `sources.list`. To do this, let's add the line `deb-src http://deb.debian.org/debian/ bookworm main` to the `/etc/apt/sources.list`, where `bookworm` is the name of our _Linux distribution_.

Let's update the list and install the packages needed to install _Python_ from sources:

```bash
sudo apt update && sudo apt upgrade -y
```

Installing the main dependencies:

```bash
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

Then you need to download the archive with the [source code](https://www.python.org/downloads/source/) of the required version from the official website.

```bash
wget https://www.python.org/ftp/python/3.13.3/Python-3.13.3.tgz
```

Unpack the archive and go to the folder with the source codes:

```bash
tar -xzvf Python-3.13.3.tgz
```

```bash
cd Python-3.13.3
```

Start the configuration process:

```bash
./configure --prefix=/opt/python-3.13.3/ --enable-optimizations
```

Using the `htop` command, we see how many cores the processor has and launch the compiler (**XX** means the number of cores in the system):

```bash
make -jXX
```

Install _Python_:

```bash
sudo make altinstall
```

Let's make `Python3.13.3` the default version:

```bash
sudo update-alternatives --install /usr/bin/python3 python3 /opt/python-3.13.3/bin/python3.13 1
```

Let's update the `pip` package manager:

```bash
python3 -m pip install -U pip
```

Let's log out and log back in: `Python3` and `Pip` commands should work.

### Node.js

---

On the [official website](https://nodejs.org/en/download), select the required configuration and install _Node.js_. I choose the **_LTS_** version on the **_Linux_** platform with **_NVM_** and **_NPM_**.

Download and install _nvm_:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

In lieu of restarting the shell:

```bash
\. "$HOME/.nvm/nvm.sh"
```

Download and install _Node.js_:

```bash
nvm install 22
```

Verify the _Node.js_ version:

```bash
node -v # Should print "v22.15.0".
```

```bash
nvm current # Should print "v22.15.0".
```

Verify _npm_ version:

```bash
npm -v # Should print "10.9.2".
```

### Typescript

---

Let's update the _npm package manager_:

```bash
npm i -g npm
```

Install _typescript_:

```bash
npm install -g typescript
```

### Go

---

On the [GO download page](https://go.dev/dl/), look for the archive for _Linux_ (in my example it is: **go1.24.2.linux-amd64.tar.gz**) and download it to the _Windows download folder_.

In the _WSL_ terminal, move the file to the _Debian Linux_ home directory:

```bash
mv /mnt/c/Users/WinUserName/Downloads/go1.24.2.linux-amd64.tar.gz .
```

Unpack it:

```bash
tar -xzvf go1.24.2.linux-amd64.tar.gz
```

Move it to the local folder:

```bash
sudo mv ./go /usr/local/
```

Add the alias to the environment:

```bash
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.zshrc
```

And reboot the shell:

```bash
exec zsh
```

### Rust

---

On the [official Rust website](https://www.rust-lang.org/learn/get-started) we find a section with the code for installation in _Windows WSL_, copy the code and after the installation starts we continue with the standard mode, **select - 1**:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Reboot the shell:

```bash
exec zsh
```

Check the functionality:

```bash
cargo
rustc
```

## Setting up additional programs

- [Tmux](#tmux)
- [Lazygit](#lazygit)
- [Nvim](#nvim)
- [Eza](#eza)
- [Yazzi](#yazzi)

### Tmux

---

In the `Tmux` application the prefix has been changed from `Ctrl+b` to `Ctrl+a`.

You can see the full list of overrides in the configuration file: `~/.config/tmux/tmux.conf`.

Launch `Tmux`:

```bash
tmux
```

Install Tmux plugin manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

After this, we will reboot the `Tmux` configuration using `Ctrl+a r`.

And install plugins: `Ctrl+a Shift+i`

After all modules are installed, click `Enter` and see that the `Tmux` design has changed.

### Lazygit

---

For _Debian Linux_ version less than 13:

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
```

Then we download the archive with `Lazygit`:

```bash
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
```

Unpack the archive and install the program:

```bash
tar xf lazygit.tar.gz lazygit
```

```bash
sudo install lazygit -D -t /usr/local/bin/
```

```bash
rm -rf lazygit*
```

Checking the functionality:

```bash
lazygit --version
```

### Nvim

---

On the page with [Nvim releases](https://github.com/neovim/neovim/releases), find the required version, go to it and copy the link to the archive and download it:

```bash
wget https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-x86_64.tar.gz
```

Unpack the archive:

```bash
tar -xzvf nvim-linux-x86_64.tar.gz
```

I create a folder `.soft` in my user home directory and move the program folder.

```bash
mkdir -p ~/.soft
```

```bash
mv nvim-linux-x86_64 ~/.soft/nvim
```

Then I create symbolic links:

```bash
sudo ln -s $HOME/.soft/nvim/bin/nvim /usr/local/bin/nvim
```

After the first launch, `Nvim` should synchronize and install all necessary modules and dependencies. You can view and manage modules using command: `:Lazy`, and additional utilities: `:Mason`.

### Eza

---

This utility produces a nice and clear listing of directories.

Install `Eza`:

```bash
cargo install eza
```

In the configuration file `~/.config/zsh/aliases.zsh`, the alias `ll` is configured for this utility.

### Yazi

---

Install the optional dependencies with:

```bash
apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
```

Go to _Debian Linux_ user home directory: `cd ~` and install `Yazi`:

```bash
git clone https://github.com/sxyazi/yazi.git
```

```bash
cd yazi
```

```bash
cargo build --release --locked
```

Add `Yazi` to PATH and restart terminal:

```bash
sudo mv target/release/yazi target/release/ya /usr/local/bin/
```

In the configuration file `~/.config/zsh/aliases.zsh`, the alias `yy` is configured for this utility.

Full documentation for the file manager `Yazi` can be found [here](https://yazi-rs.github.io/docs/installation).

The assigned _key combinations_ for control can be found in the `Yazi` configuration file: `.config/yazi/keymap.yoml`

## Backup WSL configuration

- [Create WSL Backup](#create-wsl-backup)
- [Restore WSL Backup](#restore-wsl-backup)

### Create WSL Backup

---

Using the List command, you can view a list of installed distributions; we need the name of the distribution that we want to backup.

```bash
wsl --list
```

If `Docker` is configured in the system, turn off all containers and `Docker` itself. Stop the `WSL system`:

```bash
wsl --shutdown
```

Create a `WSL backup` using the command:

```bash
wsl --export DistroName BackupName.tar
```

_DistroName_ - the name of the distribution for which the backup is being created.

_BackupName.tar_ - backup file name or path to file, e.g.: `D:\wsl-backup\debian.tar` or `D:\wsl-backup\debian.vhdx`.

The `.vhdx` files are supported by `WSL version 2` only and can be used to overwrite the current version when importing.

### Restore WSL Backup

---

To restore `WSL` from a backup copy, specify the command:

```bash
wsl --imoirt NewDistroName PathToImage PathToBackup
```

_NewDistroName_ - name of the new distribution under which the VSL copy will be restored, e.g.: `Debian-dev`.

_PathToImage_ - place where the image of the new distribution will be written, e.g.: `C:\Users\sensonic\Debian`.

_PathToBackup_ - path to the file with the backup copy, e.g.: `D:\Backup\Debian-dev.tar`.

You can also overwrite the current distribution version (тo do this, when exporting, you need to specify the file extension `.vhdx`):

```bash
wsl --import-in-place DistroName PathToBackup
```

_DistroName_ - the name of the distribution you want to overwrite.

You can set the restored distribution as the default version:

```bash
wsl --setdefault NewDistroName
```

You can also set the default user name for the restored distribution:

```bash
wsl --manage NewDistroName --set-default-user YourUserName
```

You can see the full list of commands and capabilities on the [WSL help site](https://learn.microsoft.com/ru-ru/windows/wsl/basic-commands).

## Installing additional Windows software

- [Git for Windows](#git-for-windows)
- [Google chrome](#google-chrome)
- [Obsidian](#obsidian)
- [Visual Studio Code](#visual-studio-code)
- [Biraman layout](#biraman-layout)

### Git for Windows

---

Download the installation file from the official [Git website](https://git-scm.com/downloads).

In the `Git Bash` terminal from _Windows_, you need to make the same settings as in the [Git section](#setting-up-git).

### Google chrome

---

Download the installation file from the [official website](https://www.google.com/intl/ru_ru/chrome/) and install it.

### Obsidian

---

Download the installation file from the [Obsidian website](https://obsidian.md/download) and install it.

After installation, you can add any Windows directory in `Obsidian` as _Vault_ and conveniently create notes.

I have prepared a personal repository, which I use as notes. Download the repository to any convenient place:

```bash
git clone https://github.com/sensonicm/knowledge-base.git
```

Also in the `Obsidian`, I add in the settings for saving and pushing notes directly to git:

> Hotkeys ->
>
> Git: Commit-and-Sync ->
>
> set to: "Ctrl + P"

### Visual Studio Code

---

Download the installation file from the [VS Code download page](https://code.visualstudio.com/Download) and install it.

After installation, the `VS Code` will detect the installed `WSL system` and offer to install additional _plugins_, agree.

**_Note_**: if during installation of the `VS Code` you select the option to open documents from the console using the `$ code ...` command, then most likely your document preview in the [Yazi](#yazi) program will be damaged, since it uses `$ code ...` command to open and preview files.

### Birman layout

---

Ilya Birman's program replaces typographic symbols on the keyboard layout. The program description and installation file can be found on the [official website](https://ilyabirman.ru/typography-layout/).
