# install fonts from https://www.nerdfonts.com/font-downloads (JetBrainsMono Nerd Font regular)

if [[ -e ~/.oh-my-zsh ]]
then
cd ~/.oh-my-zsh
git pull
else
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
chsh -s $(which zsh)
fi

if [[ -e  ~/.fzf ]]
then
cd ~/.fzf
git pull
else
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi
~/.fzf/install

if [[ -e  ~/.config/nvim ]]
then
cd ~/.config/nvim
git pull
else
git clone --dipth 1 https://github.com/NvChad/NvChad.git ~/.config/nvim
fi
