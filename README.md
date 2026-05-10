# .dotfiles

Neovim is installed from the official pre-built Linux archive. JetBrainsMono Nerd Font is downloaded automatically from the Nerd Fonts v3.4.0 release archive by the installer scripts.
Yazi is included as a stow package (`yazi/.config/yazi/keymap.toml`), and the installer scripts install Yazi dependencies such as ffmpeg, 7-Zip, jq, poppler tools, fzf, zoxide, resvg, ImageMagick, clipboard tools, and btop where available.

install with:
```
./installSuse.sh
# or
./installUbuntu.sh

./doStow.sh
```

update neovim with:
```
./updateNeovim.sh
```
