

if [[ -e ~/.oh-my-zsh ]]
then
cd ~/.oh-my-zsh
git pull
else
sudo zypper install zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
chsh -s $(which zsh)
fi

if [[ -e ~/.fzf ]]
then
cd ~/.fzf
git pull
else
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi
~/.fzf/install

if [[ -e ~/.config/nvim ]]
then
cd ~/.config/nvim
git pull
else
sudo zypper install neovim
git clone --dipth 1 https://github.com/NvChad/NvChad.git ~/.config/nvim
fi

if [[ -e ~/.tmux/plugins/tpm ]]
then
cd ~/.tmux/plugins/tpm
git pull
else
sudo zypper install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ -e ~/.config/Code ]]
then
else
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper refresh
sudo zypper install code
fi

if [[ -e ~/.config/mc ]]
then
else
sudo zypper install mc
fi

