#!/usr/bin/env bash
set -e
DOTFILES="$HOME/.dotfiles"

echo "==> Обновляем пакеты..."
sudo apt update

echo "==> Устанавливаем зависимости..."
sudo apt install -y zsh curl git ripgrep fd-find nodejs npm tmux

echo "==> Zsh -> шелл по умолчанию..."
chsh -s $(which zsh)

echo "==> Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "==> Zsh плагины..."
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

echo "==> Симлинки..."
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf
mkdir -p ~/.config
rm -rf ~/.config/nvim && ln -sf "$DOTFILES/nvim" ~/.config/nvim
ln -sf "$DOTFILES/starship/starship.toml" ~/.config/starship.toml

echo "==> Fd алиас..."
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true

echo ""
echo "✓ Готово! Запусти zsh, затем открой tmux и нажми prefix+I для плагинов."
echo "  Первый запуск nvim установит LazyVim-плагины автоматически."
