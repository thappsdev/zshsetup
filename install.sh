#!/bin/bash

echo "🚀 Starting REPAIRED terminal installation..."

# 1. Install Zsh first (Critical)
sudo apt update
sudo apt install -y zsh git curl fzf fd-find bat

# 2. Install Zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# 3. Install Atuin
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh

# 4. Install eza (modern ls) - Adding custom repository for Ubuntu 20.04
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza || echo "eza installation failed, falling back to standard ls"

# 5. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 6. Install Plugins & Themes
GIT_CUSTOM="$HOME/.oh-my-zsh/custom"
[ ! -d "$GIT_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$GIT_CUSTOM/themes/powerlevel10k"
[ ! -d "$GIT_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$GIT_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$GIT_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$GIT_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$GIT_CUSTOM/plugins/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab "$GIT_CUSTOM/plugins/fzf-tab"

# 7. Configure .zshrc
echo "⚙️  Configuring .zshrc..."

# Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.bak

# Update Theme and Plugins
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zoxide fzf-tab)/' ~/.zshrc

# Add Custom Config (Check if already exists to avoid duplicates)
if ! grep -q "CUSTOM CONFIGURATION" ~/.zshrc; then
cat << 'EOF' >> ~/.zshrc

# --- CUSTOM CONFIGURATION ---
# Modern replacements
if command -v eza > /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
else
    alias ll='ls -alF'
fi

alias cat='batcat --style=plain'
alias fd='fdfind'

# FZF performance tweaks for WSL
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'

# Initializations
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
EOF
fi

echo -e "\n✅ REPAIR COMPLETE!"
echo -e "--------------------------------------------------------"
echo -e "1. RESTART TERMINAL or type: exec zsh"
echo -e "2. If p10k config doesn't start, type: p10k configure"
echo -e "--------------------------------------------------------"

# Set Zsh as default (WSL friendly way)
sudo chsh -s $(which zsh) $(whoami)
