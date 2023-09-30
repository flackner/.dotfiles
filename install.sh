

if [[ -e ~/.oh-my-zsh ]]
then
cd ~/.oh-my-zsh
git pull
else
sudo zypper -n install zsh
sudo zypper -n install eza
sudo zypper -n install ripgrep
sudo zypper -n install fd
sudo zypper -n install bat
sudo zypper -n install the_silver_searcher  
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
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
sudo zypper -n install neovim
git clone --dipth 1 https://github.com/NvChad/NvChad.git ~/.config/nvim
fi

if [[ -e ~/.tmux/plugins/tpm ]]
then
cd ~/.tmux/plugins/tpm
git pull
else
sudo zypper -n install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ -e ~/.config/Code ]]
then
:
else
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper -n addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper -n refresh
sudo zypper -n install code
fi

if [[ -e ~/.config/mc ]]
then
:
else
sudo zypper -n install mc
fi

