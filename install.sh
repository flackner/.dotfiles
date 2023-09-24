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

if [[ -e  ~/.tmux]]
then
cd ~/.tmux
git pull
else
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
fi

if [[ -e  ~/.faybmak ]]
then
cd ~/.faybmak
git pull
else
git clone https://github.com/flackner/faybmak.git ~/.faybmak
fi
sudo ~/.faybmak/install.sh

if [[ -e  ~/.faybextensions ]]
then
cd ~/.faybextensions
git pull
else
git clone https://github.com/flackner/faybextensions.git ~/.faybextensions
fi
~/.faybextensions/install.sh
