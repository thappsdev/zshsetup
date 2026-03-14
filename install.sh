#!/bin/bash

echo "🚀 Starting ULTIMATE terminal setup (English comments)..."

# 1. Install core packages
sudo apt update
sudo apt install -y zsh git curl fzf fd-find bat

# 2. Install eza (Modern ls) for Ubuntu 20.04
if ! command -v eza &> /dev/null; then
    echo "📦 Adding eza repository..."
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

# 5. Install Oh My Zsh (Force re-install if broken)
if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "📥 Installing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh" # Clean up potentially broken install
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 6. Install Plugins & Themes
GIT_CUSTOM="$HOME/.oh-my-zsh/custom"
[ ! -d "$GIT_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$GIT_CUSTOM/themes/powerlevel10k"
[ ! -d "$GIT_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$GIT_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$GIT_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$GIT_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$GIT_CUSTOM/plugins/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab "$GIT_CUSTOM/plugins/fzf-tab"

# 7. Reconstruct .zshrc
echo "⚙️  Configuring .zshrc..."
cat << 'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zoxide fzf-tab)

source $ZSH/oh-my-zsh.sh

# --- CUSTOM CONFIGURATION ---
if command -v eza > /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
fi
alias cat='batcat --style=plain'
alias fd='fdfind'

export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --exclude .git --exclude node_modules --exclude mnt'

export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# 8. Set Zsh as default shell
echo "🐚 Setting Zsh as default shell..."
sudo chsh -s $(which zsh) $USER

echo -e "\n✅ SETUP FINISHED!"
echo -e "--------------------------------------------------------"
echo -e "🔗 DOWNLOAD THESE 4 FONTS AND INSTALL THEM IN WINDOWS:"
echo -e "1. https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
echo -e "2. https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
echo -e "3. https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
echo -e "4. https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
echo -e "--------------------------------------------------------"
echo -e "🚀 AFTER INSTALLING FONTS, RESTART WINDOWS TERMINAL"
echo -e "   And set 'MesloLGS NF' in Profile -> Appearance -> Font face"
echo -e "--------------------------------------------------------"

# 9. Install VS Code Extensions
echo -e "\n📦 Installing VS Code extensions..."
if command -v code &> /dev/null; then
    extensions=(
        # Python / FastAPI
        "ms-python.python"
        "ms-python.vscode-pylance"
        "charliermarsh.ruff"
        
        # Next.js / React / TypeScript / Tailwind
        "esbenp.prettier-vscode"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
        "dsznajder.es7-react-js-snippets" # React snippets (rfce, tsrfc)
        "formulahendry.auto-rename-tag"  # Auto rename HTML/JSX tags
        "yoavbls.pretty-ts-errors"       # Better readable TS errors
        
        # Databases (Postgres, MySQL, SQLite, MongoDB, Redis)
        "mtxr.sqltools"
        "mtxr.sqltools-driver-pg"
        "mtxr.sqltools-driver-mysql"
        "mtxr.sqltools-driver-sqlite"
        "mongodb.mongodb-vscode"
        "cweijan.vscode-redis-client"
        
        # Docker
        "ms-azuretools.vscode-docker"
        
        # AI Assistants
        "RooVeterinaryInc.roo-cline" # Roo Code
        "Continue.continue"          # Continue
        "GoogleCloudTools.gemini-codeassist" # Gemini Code Assist
        # "Codeium.codeium"          # Alternativa k AI, pokud byl Kilo Code překlep pro Codeium/Cody
    )

    for ext in "${extensions[@]}"; do
        code --install-extension "$ext" --force
    done
    echo "✅ VS Code extensions installed."
else
    echo "⚠️ Command 'code' not found. VS Code extensions were skipped."
    echo "   To install them automatically, run this script inside VS Code's integrated terminal."
fi

# Launch Zsh
exec zsh
