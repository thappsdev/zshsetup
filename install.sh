#!/bin/bash

echo "🚀 Starting ULTIMATE terminal installation..."

# 1. Update system and install core tools + eza & bat
sudo apt update
sudo apt install -y zsh git curl fzf fd-find bat eza

# 2. Install Zoxide (smart cd replacement)
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# 3. Install Atuin (shell history sync)
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh

# 4. Install Oh My Zsh (unattended mode to avoid manual input)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Define paths for custom plugins and themes
GIT_CUSTOM="$HOME/.oh-my-zsh/custom"

# 6. Install Powerlevel10k theme
[ ! -d "$GIT_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$GIT_CUSTOM/themes/powerlevel10k"

# 7. Install Plugins (Autosuggestions, Highlighting + Fzf-tab)
[ ! -d "$GIT_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$GIT_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$GIT_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$GIT_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$GIT_CUSTOM/plugins/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab "$GIT_CUSTOM/plugins/fzf-tab"

# 8. Configure .zshrc
echo "⚙️  Configuring .zshrc..."

# Set theme to Powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Add plugins to the configuration
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zoxide fzf-tab)/' ~/.zshrc

# Append Aliases and extra configuration to the end of .zshrc
cat << 'EOF' >> ~/.zshrc

# --- CUSTOM CONFIGURATION ---
# Modern replacements for classic commands
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias cat='batcat --style=plain'

# Fix for fdfind (package is named fdfind in Ubuntu/WSL)
alias fd='fdfind'

# FZF settings: Ignore node_modules, .git, and Windows mount points (performance)
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'

# Initialize modern shell tools
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
EOF

echo -e "\n✅ INSTALLATION COMPLETE!"
echo -e "--------------------------------------------------------"
echo -e "🔗 1. INSTALL FONTS: https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"
echo -e "🔗 2. SET FONT IN WINDOWS TERMINAL (MesloLGS NF)"
echo -e "🔗 3. RESTART TERMINAL (or type: exec zsh)"
echo -e "--------------------------------------------------------"

# Change default shell to zsh
sudo chsh -s $(which zsh) $USER