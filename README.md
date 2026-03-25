# 🖥️ Terminal Setup v2.0

> **Next.js · Python/FastAPI · Docker · VS Code Remote**

Automatický instalační skript pro ultimátní terminálové prostředí na Ubuntu serverech.

## 📦 Co je v tomto setupu

| Nástroj | Popis |
|---------|-------|
| [zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) | Shell + framework s pluginy |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Rychlé a informativní téma |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Chytrá navigace – pamatuje si navštívené složky |
| [atuin](https://atuin.sh/) | Šifrovaná shell history, synchronizace přes servery |
| [fzf](https://github.com/junegunn/fzf) + [fzf-tab](https://github.com/Aloxaf/fzf-tab) | Fuzzy finder + fuzzy Tab completion |
| [eza](https://github.com/eza-community/eza) | Moderní `ls` s ikonami a git statusem |
| [bat](https://github.com/sharkdp/bat) | `cat` se syntax highlighting |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Rychlý `grep` |
| [fd](https://github.com/sharkdp/fd) | Rychlý `find` |
| [dust](https://github.com/bootandy/dust) | Vizuální disk usage (`du` replacement) |
| [lazygit](https://github.com/jesseduffield/lazygit) | TUI rozhraní pro git |
| [tldr](https://tldr.sh/) | Rychlé manuály s praktickými příklady |
| [NVM](https://github.com/nvm-sh/nvm) + Node.js | Node version manager + LTS |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | AI asistent v terminálu |

---

## 🚀 Instalace

```bash
chmod +x install.sh && ./install.sh
```

Skript **automaticky detekuje** typ serveru podle hostname:
- `*devel*` → development mode (plná instalace včetně VS Code extensions)
- `*prod*` / `*server*` → zobrazí varování, přeskočí VS Code extensions

Po instalaci:
1. Nainstaluj fonty **MesloLGS NF** do Windows Terminal ([stáhnout zde](https://github.com/romkatv/powerlevel10k-media))
2. Nastav font: *Profile → Appearance → Font face → `MesloLGS NF`*
3. Restartuj terminál
4. Spusť `p10k configure` pro Powerlevel10k wizard

---

## 📖 Obsah

- [Zsh – klávesové zkratky](#zsh--klávesové-zkratky)
- [zoxide – chytrá navigace](#zoxide--chytrá-navigace)
- [atuin – shell history](#atuin--shell-history)
- [fzf – fuzzy finder](#fzf--fuzzy-finder)
- [eza – moderní ls](#eza--moderní-ls)
- [bat, ripgrep, fd, dust](#bat-ripgrep-fd-dust)
- [lazygit – TUI pro git](#lazygit--tui-pro-git)
- [Docker aliasy](#docker-aliasy)
- [Development aliasy](#development-aliasy)
- [VS Code Remote tipy](#vs-code-remote-tipy)
- [Rychlá reference](#rychlá-reference)

---

## Zsh – klávesové zkratky

### Navigace v příkazové řádce

| Zkratka | Akce |
|---------|------|
| `Ctrl + A` | Přejít na začátek řádku |
| `Ctrl + E` | Přejít na konec řádku |
| `Ctrl + W` | Smazat slovo vlevo |
| `Ctrl + K` | Smazat od kurzoru do konce |
| `Ctrl + U` | Smazat celý řádek |
| `Ctrl + R` | Fuzzy hledání v historii (přes Atuin) |
| `Alt + ← / →` | Pohyb po slovech |
| `Esc Esc` | Přidat `sudo` před příkaz (plugin `sudo`) |

### Oh My Zsh pluginy

| Plugin | Co přidává |
|--------|------------|
| `extract` | `x archiv.tar.gz` – rozbalí cokoliv bez pamatování přepínačů |
| `copypath` | `copypath` – zkopíruje aktuální cestu do schránky |
| `dirhistory` | `Alt+←` / `Alt+→` – navigace v historii adresářů |
| `zsh-you-should-use` | Upozorní tě, když použiješ příkaz místo aliasu |
| `sudo` | Dvojitý `Esc` přidá `sudo` před předchozí příkaz |
| `git` | Stovky git aliasů: `gst`, `gco`, `glog`, `gd`, `gp`... |

---

## zoxide – chytrá navigace

Sleduje navštívené složky a umožňuje navigaci pomocí části jména cesty. Nahrazuje `cd`.

| Příkaz | Popis |
|--------|-------|
| `z project` | Přejde do nejčastěji navštívené složky obsahující `project` |
| `z pro api` | Lze zadat více částí cesty najednou |
| `zi` | Interaktivní výběr přes fzf ze všech zapamatovaných cest |
| `z -` | Předchozí složka (jako `cd -`) |
| `zoxide query -l` | Vypíše všechny zapamatované cesty se skóre |
| `zoxide remove /path` | Odebere cestu z databáze |

```bash
z next        # → /home/user/projects/my-next-app
z fast api    # → /home/user/projects/fastapi-backend
zi            # interaktivní výběr se živým náhledem
```

---

## atuin – shell history

Nahrazuje standardní shell history šifrovanou databází. Umí synchronizovat historii napříč servery.

| Příkaz | Popis |
|--------|-------|
| `Ctrl + R` | Fuzzy hledání v historii s náhledem |
| `atuin stats` | Statistiky – nejčastěji použité příkazy |
| `atuin search text` | Vyhledá v historii z příkazové řádky |
| `atuin register` | Registrace účtu pro sync |
| `atuin login` | Přihlásí se k Atuin sync serveru |
| `atuin sync` | Synchronizuje historii napříč servery |

> 💡 **Tip:** Po `atuin register` a `atuin login` na každém serveru se příkazy automaticky synchronizují. Výhodné při práci s dev + více prod servery.

---

## fzf – fuzzy finder

Interaktivní fuzzy vyhledávač pro soubory, historii a procesy. Integrovaný přes `fzf-tab` pro Tab completion.

| Zkratka | Akce |
|---------|------|
| `Ctrl + T` | Fuzzy výběr souboru a vložení do příkazu |
| `Ctrl + R` | Fuzzy hledání v historii |
| `Alt + C` | Fuzzy výběr adresáře a `cd` do něj |
| `Tab` | fzf-tab: fuzzy completion pro cokoliv (`cd`, `kill`, `git`...) |
| `kill <Tab>` | Interaktivní výběr procesu pro kill |
| `ssh <Tab>` | Výběr hosta ze `~/.ssh/config` |

```bash
cd <Tab>           # zobrazí náhled adresáře přes eza
cat <Tab>          # zobrazí náhled souboru přes bat
git checkout <Tab> # větve s náhledem
docker <Tab>       # kontejnery, image...
```

---

## eza – moderní ls

| Alias | Příkaz | Popis |
|-------|--------|-------|
| `ls` | `eza --icons --group-directories-first` | Výpis s ikonami |
| `ll` | `eza -l --icons --git` | Detailní výpis s git statusem |
| `la` | `eza -la --icons --git` | Včetně skrytých souborů |
| `lt` | `eza --tree --level=2` | Stromový výpis 2 úrovně |
| `lt3` | `eza --tree --level=3` | Stromový výpis 3 úrovně |

```bash
ll --sort=size      # seřadit podle velikosti
ll --sort=modified  # seřadit podle data úpravy
eza -l --git-ignore # respektuje .gitignore
```

---

## bat, ripgrep, fd, dust

### bat – cat se syntax highlighting

| Příkaz | Popis |
|--------|-------|
| `cat soubor.py` | Zobrazí soubor se syntax highlighting (alias na `batcat`) |
| `bat -n soubor` | S čísly řádků |
| `bat --diff soubor` | Zobrazí diff změn (vyžaduje git) |
| `bat -l json file.txt` | Vynutit konkrétní jazyk |

### ripgrep (rg) – rychlý grep

| Příkaz | Popis |
|--------|-------|
| `rg 'pattern'` | Hledá v aktuální složce (ignoruje `.git`, `node_modules`) |
| `rg 'text' --type py` | Hledá jen v Python souborech |
| `rg -i 'text'` | Case insensitive |
| `rg -l 'text'` | Vypíše jen názvy souborů (ne řádky) |
| `rg --no-ignore 'text'` | Hledá i v ignorovaných souborech |

### fd – find replacement

| Příkaz | Popis |
|--------|-------|
| `fd pattern` | Hledá soubory (ignoruje `.git`, `node_modules`) |
| `fd -e py pattern` | Hledá jen `.py` soubory |
| `fd -t d pattern` | Hledá jen složky |
| `fd --hidden pattern` | Včetně skrytých souborů |

### dust – disk usage

| Příkaz | Popis |
|--------|-------|
| `dust` | Vizuální strom využití disku |
| `dust -n 20` | Top 20 největších položek |
| `dust -d 2` | Jen 2 úrovně hloubky |
| `dust /var/log` | Konkrétní složka |

---

## lazygit – TUI pro git

Spustíš příkazem `lg`. Ovládáš klávesnicí, scrollovat lze i myší.

### Navigace

| Klávesa | Akce |
|---------|------|
| `lg` | Spustit lazygit (alias) |
| `← / →` nebo `h / l` | Přepínání panelů (Files, Branches, Commits...) |
| `↑ / ↓` nebo `j / k` | Navigace v seznamu |
| `Enter` | Potvrzení / rozbalení |
| `q` | Zpět / zavřít |
| `?` | Nápověda – seznam všech zkratek |

### Nejčastější akce

| Klávesa | Akce |
|---------|------|
| `Space` | Stage / unstage soubor |
| `a` | Stage / unstage všechny soubory |
| `c` | Commit (otevře editor pro zprávu) |
| `p` | Push |
| `P` | Pull |
| `b` | Nová větev |
| `d` | Smazat větev / soubor ze staged |
| `e` | Otevřít soubor v editoru |
| `ctrl + r` | Refresh |

---

## Docker aliasy

| Alias | Příkaz | Popis |
|-------|--------|-------|
| `dps` | `docker ps --format ...` | Přehled kontejnerů (název, status, porty) |
| `dcup` | `docker compose up -d` | Spustit compose stack |
| `dcdown` | `docker compose down` | Zastavit compose stack |
| `dclogs` | `docker compose logs -f` | Sledovat logy compose stacku |
| `dlog <n>` | `docker logs -f <n>` | Sledovat logy kontejneru |
| `dex <n> bash` | `docker exec -it <n> bash` | Shell do kontejneru |
| `dprune` | `docker system prune -af --volumes` | Vyčistit vše |
| `d stats` | `docker stats` | Live resource monitoring |

> 💡 **Tip:** Dozzle (web UI pro logy) a Dockge (web UI pro compose stacky) jsou přístupné přes Caddy proxy. Využij alias `dlog` pro rychlý přístup k logům z terminálu.

---

## Development aliasy

### Next.js / Node.js

| Alias | Příkaz |
|-------|--------|
| `nrd` | `npm run dev` |
| `nrb` | `npm run build` |
| `nrs` | `npm run start` |
| `ni` | `npm install` |
| `nr <script>` | `npm run <script>` |

### Python / FastAPI

| Alias | Příkaz |
|-------|--------|
| `py` | `python3` |
| `pip` | `pip3` |
| `venv` | `python3 -m venv .venv && source .venv/bin/activate` |
| `activate` | `source .venv/bin/activate` |

### Systémové utility

| Alias | Příkaz | Popis |
|-------|--------|-------|
| `ports` | `ss -tulpn` | Otevřené porty |
| `myip` | `curl -s ifconfig.me` | Veřejná IP adresa |
| `reload` | `source ~/.zshrc` | Znovu načíst konfiguraci |
| `zshconfig` | `$EDITOR ~/.zshrc` | Otevřít `.zshrc` v editoru |
| `free` | `free -h` | RAM v čitelném formátu |
| `df` | `df -h` | Disk v čitelném formátu |

---

## VS Code Remote tipy

### ~/.ssh/config – doporučená konfigurace

```
Host devel
    HostName 192.168.1.100
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

Pak stačí: `ssh devel`  
VS Code: `Ctrl+Shift+P` → *Remote-SSH: Connect to Host* → `devel`

### Užitečné zkratky

| Zkratka | Akce |
|---------|------|
| `` Ctrl+Shift+` `` | Otevřít nový terminál (na serveru) |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+P` | Rychlé otevření souboru (fuzzy) |
| `Ctrl+Shift+F` | Hledání v celém projektu |
| `F5` | Spustit debugger |
| `Ctrl+Shift+G` | Source Control (git) |

> 💡 **Tip:** Nastav `remote.SSH.defaultExtensions` v `settings.json` – rozšíření jako Ruff, Pylance a Docker se pak automaticky doinstalují na každý nový server.

---

## Rychlá reference

```
NAVIGACE & SOUBORY              GIT & DOCKER
─────────────────────────────   ─────────────────────────────
z <část cesty>  smart cd        lg              lazygit TUI
zi              fzf výběr       gs              git status
Ctrl+R          fuzzy history   gl              git log graph
Ctrl+T          fuzzy soubor    dps             docker ps
Alt+C           fuzzy cd        dcup            compose up -d
ll              eza detail+git  dlog <n>        logs -f
lt              eza strom       dex <n> bash    exec do ctr.
cat             bat highlight   dprune          vyčistit vše
rg 'text'       ripgrep         nrd             npm run dev
dust            disk visual     activate        .venv zapnout
tldr <cmd>      examples        ports           ss -tulpn
Esc Esc         přidat sudo     reload          zshrc reload
```

---

## Struktura .zshrc

Důležité pořadí v `.zshrc` (jinak hrozí chyby jako `zoxide not found`):

```zsh
# 1. PATH musí být PŘED source oh-my-zsh
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"

# 2. Pluginy BEZ zoxide (ten inicializujeme sami přes eval)
plugins=(git sudo extract zsh-autosuggestions zsh-syntax-highlighting fzf-tab)

# 3. Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# 4. eval inicializace AŽ PO source
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# 5. NVM lazy loading (nezpomaluje start shellu)
function nvm() {
    unfunction nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}
```
