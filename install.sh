#!/usr/bin/env bash
set -e
DOTFILES="$HOME/.dotfiles"

echo "==> Update packages..."
sudo apt update

echo "==> Install dependencies..."
sudo apt install -y zsh curl git ripgrep fd-find nodejs npm tmux

echo "==> Zsh -> default shell..."
chsh -s $(which zsh)

echo "==> Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] &&
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] &&
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

echo "==> Neovim..."
sudo snap install nvim --classic || true

echo "==> TPM..."
[ ! -d "$HOME/.tmux/plugins/tpm" ] &&
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "==> Symlinks..."
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf
mkdir -p ~/.config
rm -rf ~/.config/nvim && ln -sf "$DOTFILES/nvim" ~/.config/nvim
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml

echo "==> Fd alias..."
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true

echo ""
echo "✓ Ready! Run zsh, open tmux and press prefix+I for plugins."
echo "  At the first launch nvim install LazyVim plugins automatically."
