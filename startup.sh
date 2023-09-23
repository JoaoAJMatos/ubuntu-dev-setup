# !/bin/bash
#
# Author:      JoaoAJMatos (https://github.com/JoaoAJMatos)
# Date:        09/23/2023
# 
# Description: This shell script sets up a new Ubuntu system for my development workflow,
#              installing everything I need to start working on my projects.

cd ~ && sudo apt-get update

# Installing basic packages
sudo apt-get install curl -y        # Curl
sudo apt-get install neofetch -y    # Neofetch bc yeah...
sudo apt-get install xclip -y       # Tool to handle clipboard through the terminal
sudo apt-get install htop -y        # Htop to monitor system resources
sudo apt-get install tree -y        # Tree to display directory structure
sudo apt-get install wget -y        # Wget to download files from the web
sudo apt-get install net-tools -y   # Net-tools to use ifconfig
sudo apt-get install cmake -y
sudo apt-get install build-essential -y
sudo apt-get install python3-dev -y
sudo apt-get install python3-setuptools -y
sudo apt-get install python3-wheel -y
sudo apt-get install python3-venv -y
sudo apt-get install python3-pip -y

# Install latest version of neovim
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get update && sudo apt-get install neovim -y

# Install latest version of tmux
sudo add-apt-repository ppa:pi-rho/dev -y
sudo apt-get update && sudo apt-get install tmux -y

# Install latest Git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update && sudo apt-get install git -y

# Configure Git username and email
echo "[+] Git config username: "
read git_config_username

echo "[+] Git config email: "
read git_config_email

echo "[+] GitHub username: "
read github_username

# Download GetGist to download my dot files from GitHub
sudo pip3 install getgist
export GETGIST_USER=$github_username

# Setup Git global username and email
git config --global user.name "$git_config_username"
git config --global user.email "$git_config_email"

# Clone .gitconfig from gist
getmy .gitconfig

# Generate a new SSH key for the machine
echo "[+] Creating new SSH key for this machine"
ssh-keygen -t rsa -b 4096 -C $git_config_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

# Install Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt-get install -f -y && rm discord.deb

# Install Spotify
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

# Update and cleanup
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
clear

# Bump up the max file watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# Generate GPG key
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG

echo "[+] Please paste here the GPG key ID displayed here."
read gpg_key_id
git config --global user.signingkey $gpg_key_id
gpg --armor --export $gpg_key_id

# Setup ZSH and Oh My ZSH
sudo apt-get install zsh -y
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)
getmy .zshrc

echo "[!] Done"
