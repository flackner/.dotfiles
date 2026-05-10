# .dotfiles

Neovim is installed from the official pre-built Linux archive. JetBrainsMono Nerd Font is downloaded automatically from the Nerd Fonts v3.4.0 release archive by the installer scripts.

## Tools Included

The installer includes a comprehensive set of modern CLI tools:

**File and Directory Navigation:**
- fzf - Command-line fuzzy finder
- zoxide - Smarter cd with directory tracking
- fd - Fast alternative to find
- eza - Modern ls replacement with Git status
- yazi - Async terminal file manager

**Text Search and Processing:**
- ripgrep (rg) - Fast regex search
- bat - Cat with syntax highlighting
- jq - JSON processor
- delta - Syntax highlighting pager for Git/diff

**Version Control and Development:**
- lazygit - Git terminal UI
- lazydocker - Docker terminal UI
- gh - GitHub CLI

**System Monitoring:**
- btop - Resource monitor
- htop - Process viewer
- duf - Disk usage/free utility
- dust - Disk usage visualization

**Terminal Multiplexing and Environment:**
- tmux - Terminal multiplexer
- zellij - Modern tmux alternative
- starship - Customizable shell prompt

Install with:
```
./installSuse.sh
# or
./installUbuntu.sh

./doStow.sh
```

Update neovim with:
```
./updateNeovim.sh
```
