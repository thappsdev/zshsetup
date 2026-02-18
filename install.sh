#!/bin/bash

# Ensure we are running on Ubuntu
echo "🚀 Starting Idempotent Terminal Setup..."

# 1. Install core packages separately for stability
sudo apt update
sudo apt install -y zsh git curl fzf fd-find bat

# 2. Install eza (Modern ls) for Ubuntu 20.04
if ! command -v eza &> /dev/null; then
    echo "📦 Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update && sudo apt install -y eza
fi

# 3. Install Zoxide
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# 4. Install Atuin
if [ ! -d "$HOME/.atuin" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
fi

# 5. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 6. Install Plugins & Themes
GIT_CUSTOM="$HOME/.oh-my-zsh/custom"
install_plugin() {
    if [ ! -d "$GIT_CUSTOM/$1/$2" ]; then
        echo "📥 Installing $2..."
        git clone --depth=1 "$3" "$GIT_CUSTOM/$1/$2"
    fi
}

install_plugin "themes" "powerlevel10k" "https://github.com/romkatv/powerlevel10k.git"
install_plugin "plugins" "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "plugins" "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
install_plugin "plugins" "fzf-tab" "https://github.com/Aloxaf/fzf-tab"

# 7. Reconstruct .zshrc from scratch to fix errors
echo "⚙️  Reconstructing .zshrc..."
cat << 'EOF' > ~/.zshrc
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zoxide fzf-tab)

source $ZSH/oh-my-zsh.sh

# --- CUSTOM CONFIGURATION ---
# Modern replacements
if command -v eza > /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
fi
alias cat='batcat --style=plain'
alias fd='fdfind'

# FZF settings
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'

# Path and Init
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# Load Powerlevel10k instant prompt if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo -e "\n✅ DONE! To start using it, type: exec zsh"
