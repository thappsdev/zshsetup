# 🚀 Ultimate Terminal & Linux Master Cheat Sheet

Tento dokument je tvůj kompletní průvodce moderním Zsh prostředím, správou Linuxu, Gitem a pokročilými nástroji jako Vim a Tmux.

---

## 🛠️ 1. Moderní Zsh Setup (Tvé nové prostředí)

Tvůj terminál nyní používá Oh My Zsh s tématem Powerlevel10k.

| Komponenta | Účel |
| :--- | :--- |
| Powerlevel10k | Rychlé téma. Ukazuje Git status, chyby, čas a verzi jazyka (Node, Python). |
| Atuin (Ctrl + R) | Magická historie příkazů v SQLite databázi. Najde vše napříč relacemi. |
| Zoxide (z) | Inteligentní navigace. Místo cd .../web napiš z web. |
| fzf | Fuzzy vyhledávač. Pomáhá ti bleskově vybírat soubory. |
| eza | Moderní náhrada za ls s barvami a ikonami. |
| bat | Moderní náhrada za cat se zvýrazněním syntaxe. |

---

## ⌨️ 2. Klávesové zkratky (Zsh & Bash)

| Zkratka | Účinek |
| :--- | :--- |
| TAB | Vyvolá interaktivní menu (fzf-tab) pro výběr. |
| Ctrl + R | Hledání v historii (Atuin). |
| Šipka Doprava | Dokončí šedý našeptaný příkaz (Auto-suggestions). |
| Ctrl + L | Vyčistí obrazovku (jako příkaz clear). |
| Ctrl + A / E | Skočí na začátek / konec řádku. |
| Alt + B / F | Skočí o celé slovo zpět / vpřed. |
| Ctrl + W | Smaže slovo před kurzorem. |
| Ctrl + U | Smaže celý aktuální řádek. |
| Ctrl + C | Zruší běžící příkaz (storno). |
| Ctrl + Z | Uspí proces na pozadí (vratíš ho příkazem fg). |
| Alt + . | Vloží poslední argument z minulého příkazu. |

---

## 🐧 3. Základy Linuxu (Soubory a Systém)

### 📁 Práce se soubory
* ls -la (v tvém setupu ll) – Vypíše vše včetně skrytých souborů.
* pwd – Ukáže aktuální cestu (Print Working Directory).
* mkdir -p a/b/c – Vytvoří celou strukturu složek najednou.
* cp -r zdroj cil – Kopíruje složku rekurzivně.
* mv starý nový – Přesune nebo přejmenuje soubor/složku.
* rm -rf složka – Smaže složku a vše v ní bez ptaní!
* du -sh . – Zobrazí celkovou velikost aktuální složky.

### 🔍 Obsah souborů
* cat soubor (v tvém setupu bat) – Vypíše obsah souboru.
* tail -f log.txt – Sleduje konec souboru v reálném čase.
* grep -r "text" . – Hledá text ve všech souborech v aktuální složce.

---

## ⚙️ 4. Pokročilý Linux (Admin & Síť)

### 🛡️ Práva (Permissions)
* chmod +x script.sh – Udělá soubor spustitelným.
* chown user:group soubor – Změní vlastníka a skupinu souboru.
* sudo !! – Spustí předchozí příkaz znovu se sudo.

### 🧠 Procesy a Systém
* htop – Grafický správce procesů (CPU, RAM).
* ps aux | grep node – Najde ID procesu (PID) konkrétního programu.
* kill -9 <PID> – Natvrdo ukončí proces podle ID.
* df -h – Ukáže volné místo na discích.
* free -m – Ukáže stav operační paměti RAM.

### 🌐 Síť
* ip a – Zobrazí IP adresy síťových rozhraní.
* ss -tulpn – Zobrazí, které porty jsou v systému otevřené.
* ssh user@ip-adresa – Připojení ke vzdálenému serveru.

---

## 🐙 5. Git & GitHub (Práce s verzemi)

### Základní workflow
* git init – Inicializace nového repozitáře.
* git status – Zobrazí stav změn (vidíš i v promptu).
* git add . – Přidá všechny změny k uložení.
* git commit -m "Zpráva" – Uloží verzi s popisem.
* git push / git pull – Odešle / stáhne změny ze serveru.

### 🔑 Uložení Auth Tokenu (HTTPS)
Pro trvalé uložení tokenu použij příkaz:
git config --global credential.helper store

---

## 📝 6. Vim / Neovim (Přežití v editoru)

Vim má dva módy: Normal (příkazy) a Insert (psaní).

1. Vstup do psaní: Zmáčkni 'i'.
2. Návrat k příkazům: Zmáčkni 'Esc'.
3. Příkazy v Normal módu (vždy po Esc):
   * :w  – Uložit.
   * :q! – Zavřít bez uložení.
   * :wq – Uložit a zavřít.
   * dd  – Smazat celý řádek.
   * u   – Zpět (Undo).

---

## 🖥️ 7. Tmux (Terminálový multiplexer)

Prefix pro všechny příkazy je Ctrl + B.

* tmux – Spustí novou relaci.
* Ctrl + B pak % – Rozdělí obrazovku svisle.
* Ctrl + B pak " – Rozdělí obrazovku vodorovně.
* Ctrl + B pak d – Odpojí tě od relace (vše běží dál na pozadí).
* tmux attach – Připojí tě zpět k rozdělané práci.

---

## 📦 8. Správa balíčků (APT)
* sudo apt update – Aktualizuje seznamy balíčků.
* sudo apt install <jmeno> – Nainstaluje nový program.
* sudo apt remove <jmeno> – Odinstaluje program.
