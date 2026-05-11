#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this script as your normal user (not root)."
  echo "It uses sudo only for system package installation."
  exit 1
fi

sync_repo() {
  local target_dir="$1"
  local repo_url="$2"
  shift 2

  if [[ -d "${target_dir}/.git" ]]; then
    git -C "$target_dir" pull --ff-only
    return
  fi

  if [[ -e "$target_dir" ]]; then
    echo "Skipping $target_dir (exists but is not a git repo)."
    return
  fi

  git clone "$@" "$repo_url" "$target_dir"
}

apt_install_if_available() {
  local package_name="$1"

  if apt-cache show "$package_name" >/dev/null 2>&1; then
    sudo apt-get install -y "$package_name"
  else
    echo "$package_name package not found in enabled apt sources."
  fi
}

apt_install_any_available() {
  local package_name

  for package_name in "$@"; do
    if apt-cache show "$package_name" >/dev/null 2>&1; then
      sudo apt-get install -y "$package_name"
      return 0
    fi
  done

  echo "None of these packages were found in enabled apt sources: $*"
}

ensure_nvim_path_in_file() {
  local file_path="$1"
  local nvim_bin_path="/opt/nvim-linux-x86_64/bin"

  touch "$file_path"
  if ! grep -Fq "$nvim_bin_path" "$file_path"; then
    printf '\nexport PATH="$PATH:%s"\n' "$nvim_bin_path" >> "$file_path"
  fi
}

install_neovim_archive() {
  local archive_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  local archive_path
  archive_path="$(mktemp /tmp/nvim-linux-x86_64.XXXXXX.tar.gz)"

  curl -fL "$archive_url" -o "$archive_path"
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf "$archive_path"
  rm -f "$archive_path"
}

install_jetbrainsmono_nerd_font() {
  local fonts_archive_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
  local fonts_target_dir="$HOME/.local/share/fonts"
  local temp_dir
  local archive_path
  local font_files=()

  temp_dir="$(mktemp -d /tmp/jetbrainsmono-nerd-font.XXXXXX)"
  archive_path="$temp_dir/JetBrainsMono.zip"

  curl -fL "$fonts_archive_url" -o "$archive_path"
  unzip -q -o "$archive_path" -d "$temp_dir"

  mapfile -t font_files < <(find "$temp_dir" -type f -name '*.ttf' | sort)
  if [[ "${#font_files[@]}" -eq 0 ]]; then
    echo "No JetBrainsMono .ttf files found in downloaded archive."
    rm -rf "$temp_dir"
    return 1
  fi

  mkdir -p "$fonts_target_dir"
  cp "${font_files[@]}" "$fonts_target_dir/"
  fc-cache -fv "$fonts_target_dir"
  rm -rf "$temp_dir"
}

install_zoxide() {
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_gh() {
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages focal main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y gh
}

install_starship() {
  curl -sS https://starship.rs/install.sh | sh
}

sudo apt-get update
sudo apt-get install -y \
  git curl gnupg ca-certificates \
  stow zsh ripgrep fd-find bat fontconfig unzip \
  tmux mc

apt_install_if_available yazi
apt_install_if_available ffmpeg
apt_install_any_available 7zip p7zip-full p7zip
apt_install_if_available jq
apt_install_any_available poppler-utils poppler
apt_install_if_available resvg
apt_install_any_available imagemagick imagemagick-7
apt_install_if_available wl-clipboard
apt_install_if_available xclip
apt_install_if_available xsel
apt_install_if_available btop
apt_install_if_available eza
apt_install_if_available ghostty
apt_install_if_available flameshot
apt_install_if_available httpie
apt_install_if_available lazygit
apt_install_if_available lazydocker
apt_install_if_available htop
apt_install_if_available duf
apt_install_if_available dust
apt_install_if_available zellij
apt_install_if_available starship
apt_install_if_available gh
apt_install_if_available meld
apt_install_if_available kdiff3

install_gh || true
install_starship || true

install_neovim_archive
ensure_nvim_path_in_file "$HOME/.zshrc"
ensure_nvim_path_in_file "$HOME/.bashrc"
install_jetbrainsmono_nerd_font

sync_repo "$HOME/.oh-my-zsh" "https://github.com/ohmyzsh/ohmyzsh.git"

zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$zsh_custom/plugins"

sync_repo "$zsh_custom/plugins/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
sync_repo "$zsh_custom/plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
sync_repo "$zsh_custom/plugins/zsh-completions" "https://github.com/zsh-users/zsh-completions"
sync_repo "$zsh_custom/plugins/fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"

sync_repo "$HOME/.fzf" "https://github.com/junegunn/fzf.git" --depth 1
"$HOME/.fzf/install" --all --no-bash --no-fish

install_zoxide

sync_repo "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm"

mkdir -p "$HOME/.local/bin"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

if ! command -v code >/dev/null 2>&1; then
  if [[ ! -f /etc/apt/sources.list.d/vscode.list ]]; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
      | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  fi

  sudo apt-get update
  sudo apt-get install -y code
fi
