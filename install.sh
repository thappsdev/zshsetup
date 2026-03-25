#!/bin/bash

# =============================================================================
# ULTIMATE TERMINAL SETUP - v2.0
# Stack: Next.js / Python / FastAPI / Docker / VS Code Remote
# =============================================================================

set -e  # Exit on error

# --- Colors ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

log()     { echo -e "${GREEN}✅ $1${NC}"; }
info()    { echo -e "${CYAN}ℹ️  $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $1${NC}"; }
section() { echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; \
            echo -e "${BLUE}  $1${NC}"; \
            echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# --- Detect environment ---
IS_PRODUCTION=false
IS_DEVEL=false
HOSTNAME=$(hostname)

if [[ "$HOSTNAME" == *"devel"* ]]; then
    IS_DEVEL=true
    info "Detected DEVELOPMENT server: $HOSTNAME"
elif [[ "$HOSTNAME" == *"prod"* ]] || [[ "$HOSTNAME" == *"server"* ]]; then
    IS_PRODUCTION=true
    warn "Detected PRODUCTION server: $HOSTNAME"
    read -p "⚠️  Installing on production server. Continue? [y/N] " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi

# =============================================================================
# 1. CORE PACKAGES
# =============================================================================
section "1/10 Core packages"

sudo apt update -q
sudo apt install -y \
    zsh git curl wget unzip \
    fzf fd-find bat \
    ripgrep \
    tldr \
    htop \
    jq \
    tree \
    tmux \
    make \
    build-essential

log "Core packages installed"

# =============================================================================
# 2. EZA (modern ls)
# =============================================================================
section "2/10 eza (modern ls)"

if ! command -v eza &> /dev/null; then
    info "Adding eza repository..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
    sudo apt update -q && sudo apt install -y eza
    log "eza installed"
else
    info "eza already installed: $(eza --version | head -1)"
fi

# =============================================================================
# 3. ZOXIDE (smart cd)
# =============================================================================
section "3/10 zoxide (smart cd)"

if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    log "zoxide installed"
else
    info "zoxide already installed: $(zoxide --version)"
fi

# =============================================================================
# 4. ATUIN (shell history)
# =============================================================================
section "4/10 Atuin (shell history)"

if [ ! -d "$HOME/.atuin" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
    log "atuin installed"
else
    info "atuin already installed"
fi

# =============================================================================
# 5. DUST (disk usage)
# =============================================================================
section "5/10 dust (disk usage)"

if ! command -v dust &> /dev/null; then
    DUST_VERSION=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest \
        | grep '"tag_name"' | cut -d'"' -f4)
    ARCH=$(dpkg --print-architecture)
    if [[ "$ARCH" == "amd64" ]]; then
        DUST_ARCH="x86_64-unknown-linux-gnu"
    else
        DUST_ARCH="aarch64-unknown-linux-gnu"
    fi
    wget -qO /tmp/dust.tar.gz \
        "https://github.com/bootandy/dust/releases/download/${DUST_VERSION}/dust-${DUST_VERSION}-${DUST_ARCH}.tar.gz"
    tar -xzf /tmp/dust.tar.gz -C /tmp
    sudo mv /tmp/dust-${DUST_VERSION}-${DUST_ARCH}/dust /usr/local/bin/
    rm -rf /tmp/dust*
    log "dust installed"
else
    info "dust already installed"
fi

# =============================================================================
# 6. LAZYGIT
# =============================================================================
section "6/10 lazygit (TUI for git)"

if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
    curl -sLo /tmp/lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
    sudo mv /tmp/lazygit /usr/local/bin/
    rm /tmp/lazygit.tar.gz
    log "lazygit installed"
else
    info "lazygit already installed"
fi

# =============================================================================
# 7. OH MY ZSH + PLUGINS + THEME
# =============================================================================
section "7/10 Oh My Zsh + plugins + theme"

if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    info "Installing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log "Oh My Zsh installed"
else
    info "Oh My Zsh already installed"
fi

GIT_CUSTOM="$HOME/.oh-my-zsh/custom"

# Theme: Powerlevel10k
[ ! -d "$GIT_CUSTOM/themes/powerlevel10k" ] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$GIT_CUSTOM/themes/powerlevel10k" && log "powerlevel10k installed"

# Plugins
declare -A PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
    ["zsh-you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
)

for plugin in "${!PLUGINS[@]}"; do
    if [ ! -d "$GIT_CUSTOM/plugins/$plugin" ]; then
        git clone --depth=1 "${PLUGINS[$plugin]}" "$GIT_CUSTOM/plugins/$plugin"
        log "Plugin $plugin installed"
    else
        info "Plugin $plugin already exists"
    fi
done

# =============================================================================
# 8. NVM + NODE + GEMINI CLI
# =============================================================================
section "8/10 NVM + Node.js + Gemini CLI"

if [ ! -d "$HOME/.nvm" ]; then
    info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    info "Installing Node.js LTS..."
    nvm install --lts

    info "Installing Gemini CLI..."
    npm install -g @google/gemini-cli

    log "NVM + Node.js + Gemini CLI installed"
else
    info "NVM already installed"
fi

# =============================================================================
# 9. .ZSHRC
# =============================================================================
section "9/10 Configuring .zshrc"

# Backup existing .zshrc
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
info "Old .zshrc backed up"

cat << 'EOF' > ~/.zshrc
# =============================================================================
# .ZSHRC - Ultimate Terminal Setup v2.0
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# PATH must be set BEFORE oh-my-zsh loads (fixes zoxide not found)
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"

plugins=(
    git
    sudo
    extract
    copypath
    dirhistory
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-you-should-use
    fzf-tab
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# ALIASES - Navigation
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'

# =============================================================================
# ALIASES - Modern tools
# =============================================================================
if command -v eza > /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
    alias lt3='eza --tree --icons --level=3'
fi

if command -v batcat > /dev/null; then
    alias cat='batcat --style=plain'
    alias bat='batcat'
fi

alias fd='fdfind'
alias grep='rg'
alias df='df -h'
alias free='free -h'
alias du='dust'

# =============================================================================
# ALIASES - Git
# =============================================================================
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias lg='lazygit'

# =============================================================================
# ALIASES - Docker
# =============================================================================
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlog='docker logs -f'
alias dex='docker exec -it'
alias dprune='docker system prune -af --volumes'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'

# =============================================================================
# ALIASES - Development (Next.js / Python / FastAPI)
# =============================================================================
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrs='npm run start'
alias ni='npm install'

alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'

# =============================================================================
# ALIASES - Servers & System
# =============================================================================
alias ports='ss -tulpn'
alias myip='curl -s ifconfig.me'
alias reload='source ~/.zshrc'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'

# =============================================================================
# FZF configuration
# =============================================================================
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .venv --exclude mnt'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .venv --exclude mnt'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# fzf-tab: preview with eza/bat
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --icons --level=2 --color=always $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'batcat --color=always --style=plain $realpath'
zstyle ':fzf-tab:complete:*' fzf-min-height 15

# =============================================================================
# ATUIN + ZOXIDE
# =============================================================================
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# =============================================================================
# NVM - Lazy loading (speeds up shell start significantly)
# =============================================================================
export NVM_DIR="$HOME/.nvm"
function nvm() {
    unfunction nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
# Auto-use .nvmrc if present
autoload -U add-zsh-hook
load-nvmrc() {
    if [ -f ".nvmrc" ] && command -v nvm &> /dev/null; then
        nvm use > /dev/null 2>&1
    fi
}
add-zsh-hook chpwd load-nvmrc

# =============================================================================
# POWERLEVEL10K
# =============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

log ".zshrc configured"

# =============================================================================
# 10. VS CODE EXTENSIONS (dev server only)
# =============================================================================
section "10/10 VS Code extensions"

if $IS_PRODUCTION; then
    warn "Skipping VS Code extensions on production server"
elif command -v code &> /dev/null; then
    extensions=(
        # Python / FastAPI
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-python.debugpy"
        "charliermarsh.ruff"
        "ms-python.black-formatter"

        # Next.js / React / TypeScript
        "esbenp.prettier-vscode"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
        "dsznajder.es7-react-js-snippets"
        "formulahendry.auto-rename-tag"
        "yoavbls.pretty-ts-errors"
        "streetsidesoftware.code-spell-checker"

        # Docker
        "ms-azuretools.vscode-docker"
        "ms-vscode-remote.remote-containers"

        # Databases
        "mtxr.sqltools"
        "mtxr.sqltools-driver-pg"
        "mtxr.sqltools-driver-mysql"
        "mtxr.sqltools-driver-sqlite"
        "mongodb.mongodb-vscode"
        "cweijan.vscode-redis-client"

        # Git
        "mhutchie.git-graph"
        "eamodio.gitlens"

        # Remote
        "ms-vscode-remote.remote-ssh"
        "ms-vscode-remote.remote-ssh-edit"

        # AI
        "RooVeterinaryInc.roo-cline"
        "Continue.continue"
        "GoogleCloudTools.gemini-codeassist"

        # Utilities
        "ms-vscode.live-server"
        "redhat.vscode-yaml"
        "tamasfe.even-better-toml"
        "ms-vscode.hexeditor"
        "christian-kohler.path-intellisense"
    )

    INSTALLED=0; FAILED=0
    for ext in "${extensions[@]}"; do
        if code --install-extension "$ext" --force &> /dev/null; then
            ((INSTALLED++))
        else
            warn "Failed to install: $ext"
            ((FAILED++))
        fi
    done
    log "VS Code extensions: $INSTALLED installed, $FAILED failed"
else
    warn "VS Code 'code' command not found – run this script inside VS Code integrated terminal to install extensions"
fi

# =============================================================================
# SET ZSH AS DEFAULT SHELL
# =============================================================================
section "Setting Zsh as default shell"

if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo chsh -s $(which zsh) $USER
    log "Default shell set to zsh"
else
    info "Zsh already set as default shell"
fi

# =============================================================================
# DONE
# =============================================================================
echo -e "\n${GREEN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║           ✅  SETUP FINISHED SUCCESSFULLY            ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║                                                      ║"
echo "║  📌 NEXT STEPS:                                      ║"
echo "║                                                      ║"
echo "║  1. Install MesloLGS NF fonts in Windows Terminal:  ║"
echo "║     https://github.com/romkatv/powerlevel10k-media   ║"
echo "║     (Regular / Bold / Italic / Bold Italic)          ║"
echo "║                                                      ║"
echo "║  2. Set font in Windows Terminal:                    ║"
echo "║     Profile → Appearance → Font → 'MesloLGS NF'     ║"
echo "║                                                      ║"
echo "║  3. Restart your terminal                            ║"
echo "║                                                      ║"
echo "║  4. Run: p10k configure                              ║"
echo "║     (for Powerlevel10k wizard)                       ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

exec zsh
