stow --adopt git
cp -r git git_bak
git restore git

stow --adopt tmux
cp -r tmux tmux_bak
git restore tmux

stow --adopt zsh
cp -r zsh zsh_bak
git restore zsh

stow --adopt vscode
cp -r vscode vscode_bak
git restore vscode

stow --adopt mc
cp -r mc mc_bak
git restore mc

stow --adopt kde
cp -r kde kde_bak
git restore kde
