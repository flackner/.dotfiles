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

zypper_install_if_available() {
  local package_name="$1"

  if sudo zypper -n info "$package_name" >/dev/null 2>&1; then
    sudo zypper -n install "$package_name"
  else
    echo "$package_name package not found in enabled zypper repos."
  fi
}

zypper_install_any_available() {
  local package_name

  for package_name in "$@"; do
    if sudo zypper -n info "$package_name" >/dev/null 2>&1; then
      sudo zypper -n install "$package_name"
      return 0
    fi
  done

  echo "None of these packages were found in enabled zypper repos: $*"
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



sudo zypper -n install \
  git curl stow zsh eza ripgrep fd bat fontconfig unzip \
  tmux mc

zypper_install_if_available yazi
zypper_install_if_available ffmpeg
zypper_install_any_available 7zip p7zip
zypper_install_if_available jq
zypper_install_any_available poppler-tools poppler-utils poppler
zypper_install_if_available fzf
zypper_install_if_available resvg
zypper_install_any_available ImageMagick imagemagick
zypper_install_if_available wl-clipboard
zypper_install_if_available xclip
zypper_install_if_available xsel
zypper_install_if_available btop
zypper_install_if_available lazygit
zypper_install_if_available lazydocker
zypper_install_if_available htop
zypper_install_if_available duf
zypper_install_if_available dust
zypper_install_if_available zellij
zypper_install_if_available starship
zypper_install_if_available zoxide
zypper_install_if_available gh

install_neovim_archive
ensure_nvim_path_in_file "$HOME/.zshrc"
ensure_nvim_path_in_file "$HOME/.bashrc"
install_jetbrainsmono_nerd_font

zypper_install_if_available ghostty
zypper_install_if_available flameshot
zypper_install_if_available httpie

sync_repo "$HOME/.oh-my-zsh" "https://github.com/ohmyzsh/ohmyzsh.git"

zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$zsh_custom/plugins"

sync_repo "$zsh_custom/plugins/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
sync_repo "$zsh_custom/plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
sync_repo "$zsh_custom/plugins/zsh-completions" "https://github.com/zsh-users/zsh-completions"
sync_repo "$zsh_custom/plugins/fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"

if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  chsh -s "$(command -v zsh)"
fi

sync_repo "$HOME/.fzf" "https://github.com/junegunn/fzf.git" --depth 1
"$HOME/.fzf/install" --all --no-bash --no-fish

sync_repo "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm"

if ! command -v code >/dev/null 2>&1; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

  if [[ ! -f /etc/zypp/repos.d/vscode.repo ]]; then
    sudo zypper -n addrepo https://packages.microsoft.com/yumrepos/vscode vscode
  fi

  sudo zypper -n refresh
  sudo zypper -n install code
fi
