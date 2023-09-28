sudo zypper install zsh

if [[ -e ~/.oh-my-zsh ]]
then
cd ~/.oh-my-zsh
git pull
else
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

sudo zypper install neovim

if [[ -e ~/.config/nvim ]]
then
cd ~/.config/nvim
git pull
else
git clone --dipth 1 https://github.com/NvChad/NvChad.git ~/.config/nvim
fi

sudo zypper install tmux

if [[ -e ~/.tmux/plugins/tpm ]]
then
cd ~/.tmux/plugins/tpm
git pull
else
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

sudo zypper install code

stow git
stow tmux
stow zsh
stow vscode
