# 🚀 Ultimate Terminal & Linux Master Cheat Sheet

Tento dokument je tvůj kompletní průvodce moderním Zsh prostředím a základními operacemi v systému Linux (Ubuntu/WSL).

---

## 🛠️ 1. Moderní Zsh Setup (Tvé nové prostředí)

Váš terminál nyní používá **Oh My Zsh** s tématem **Powerlevel10k** a inteligentními pluginy.

### Hlavní nástroje v tvém setupu:
| Komponenta | Účel |
| :--- | :--- |
| **Powerlevel10k** | Extrémně rychlé téma (vzhled). Ukazuje Git status, chyby a čas. |
| **Atuin (`Ctrl + R`)** | Magická historie příkazů v SQLite databázi. Najde vše, co jsi kdy napsal. |
| **Zoxide (`z`)** | Inteligentní `cd`. Pamatuje si složky a umí tam "skočit" (např. `z web`). |
| **fzf** | Fuzzy vyhledávač. Pomáhá ti bleskově vybírat soubory nebo příkazy. |
| **fzf-tab** | Nahrazuje nudné `TAB` doplňování interaktivním menu, kde můžeš vybírat. |

### Moderní náhrady klasických příkazů (Aliasy):
* **`ls` ⮕ `eza`**: Barevný výpis s ikonkami (`ll` pro detailní výpis).
* **`cat` ⮕ `bat`**: Výpis souborů se zvýrazněním syntaxe jako v IDE.
* **`find` ⮕ `fd`**: 10x rychlejší hledání souborů (automaticky ignoruje `node_modules`).
* **`take <name>`**: Vytvoří složku a rovnou do ní vstoupí.
* **`..`, `...`, `....`**: Rychlé skoky o úrovně výše bez psaní `cd`.

---

## ⌨️ 2. Klávesové zkratky pro efektivní psaní

| Zkratka | Účinek |
| :--- | :--- |
| **`TAB`** | Vyvolá interaktivní doplňování (vybírej šipkami nebo piš pro filtr). |
| **`Ctrl + R`** | Spustí **Atuin** (hledání v historii příkazů). |
| **`Šipka Doprava`** | Přijme šedý našeptaný text (Auto-suggestions). |
| **`Ctrl + L`** | Vyčistí obrazovku (stejné jako `clear`). |
| **`Ctrl + A` / `Ctrl + E`** | Skočí kurzorem na **začátek** / **konec** řádku. |
| **`Alt + B` / `Alt + F`** | Skočí o celé **slovo zpět** / **vpřed**. |
| **`Ctrl + W`** | Smaže jedno **slovo před** kurzorem. |
| **`Ctrl + U`** | Smaže **celý aktuální řádek**. |
| **`Ctrl + T`** | Vyhledá soubor (`fzf`) a vloží jeho cestu k příkazu. |
| **`Alt + C`** | Rychlé skočení do vybrané podsložky přes vyhledávání. |
| **`Ctrl + C`** | Zruší aktuálně běžící nebo rozepsaný příkaz. |

---

## 🐧 3. Základy práce v Linuxu (Cheat Sheet)

### 📁 Práce se soubory a složkami
* **`pwd`** – Ukáže, kde se právě nacházíš (Print Working Directory).
* **`ls -la`** – Vypíše vše včetně skrytých souborů (v tvém setupu alias na `eza`).
* **`cd <cesta>`** – Změní adresář. `cd ~` je domů, `cd -` do předchozí složky.
* **`mkdir -p <cesta>`** – Vytvoří složku (včetně podadresářů, pokud neexistují).
* **`cp -r <zdroj> <cil>`** – Zkopíruje soubor nebo celou složku.
* **`mv <zdroj> <cil>`** – Přesune nebo přejmenuje soubor/složku.
* **`rm -rf <slozka>`** – **Smaže složku a vše v ní!** (Používej opatrně).

### 🔍 Vyhledávání a čtení
* **`grep -r "text" .`** – Najde text ve všech souborech v aktuální složce.
* **`tail -f <file>`** – Sleduje konec souboru v reálném čase (ideální pro logy).
* **`less <file>`** – Otevře soubor pro čtení (ukončíš klávesou `q`).
* **`head -n 20 <file>`** – Zobrazí prvních 20 řádků souboru.

### ⚙️ Systém a správa procesů
* **`sudo <prikaz>`** – Spustí příkaz s právy administrátora (root).
* **`chmod +x <file>`** – Udělá soubor (skript) spustitelným.
* **`htop`** – Interaktivní přehled vytížení systému (CPU, RAM, procesy).
* **`ps aux | grep <jmeno>`** – Najde ID procesu (PID) konkrétního programu.
* **`kill -9 <PID>`** – Natvrdo ukončí proces.
* **`df -h`** – Ukáže volné místo na discích.

### 📦 Správa balíčků (Ubuntu APT)
* **`sudo apt update`** – Aktualizuje seznamy balíčků.
* **`sudo apt upgrade`** – Nainstaluje aktualizace systému.
* **`sudo apt install <balicek>`** – Nainstaluje nový program (např. `node`, `docker`).

---

## 🔗 4. Roury a přesměrování
* **`|` (Pipe)** – Výstup jednoho příkazu pošle jako vstup do druhého (např. `ls | grep "test"`).
* **`>`** – Uloží výstup do souboru (přepíše ho).
* **`>>`** – Přidá výstup na konec souboru.

---

## 🎨 Konfigurace tvého setupu
* **`nano ~/.zshrc`** – Tady můžeš měnit pluginy, aliasy a nastavení.
* **`p10k configure`** – Znovu spustí nastavení vzhledu Powerlevel10k.
* **`source ~/.zshrc`** – Načte změny v konfiguraci bez nutnosti restartu terminálu.
