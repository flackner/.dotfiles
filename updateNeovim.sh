#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this script as your normal user (not root)."
  echo "It uses sudo only to update /opt/nvim-linux-x86_64."
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not installed."
  exit 1
fi

archive_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
archive_path="$(mktemp /tmp/nvim-linux-x86_64.XXXXXX.tar.gz)"

cleanup() {
  rm -f "$archive_path"
}
trap cleanup EXIT

curl -fL "$archive_url" -o "$archive_path"
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf "$archive_path"

echo "Neovim updated: $(/opt/nvim-linux-x86_64/bin/nvim --version | head -n 1)"
