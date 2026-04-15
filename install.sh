#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# ── Homebrew ────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  warn "Homebrew not found – installing…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  info "Homebrew already installed"
fi

# ── System packages ─────────────────────────────────────────────────────────
BREW_PACKAGES=(
  neovim   # editor
  ranger   # rnvimr file picker
  python3  # required by rnvimr (pynvim)
  node     # copilot.vim, CopilotChat, ts_ls, js-debug-adapter
  go       # gopls + go.nvim tools
  ripgrep  # telescope live_grep
  fd       # telescope find_files (faster than find)
  git      # neogit, diffview
  make     # telescope-fzf-native build + CopilotChat tiktoken
)

info "Installing brew packages…"
for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    info "  $pkg already installed"
  else
    brew install "$pkg"
    info "  $pkg installed"
  fi
done

# ── pynvim (required by rnvimr) ─────────────────────────────────────────────
if python3 -c "import pynvim" &>/dev/null; then
  info "pynvim already installed"
else
  info "Installing pynvim…"
  pip3 install --break-system-packages pynvim
fi

# ── Nerd Font ────────────────────────────────────────────────────────────────
if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
  info "Nerd Font already installed"
else
  warn "Installing JetBrainsMono Nerd Font (required for icons)…"
  brew install --cask font-jetbrains-mono-nerd-font
  warn "Set your terminal font to 'JetBrainsMono Nerd Font' after install."
fi

# ── Final notes ──────────────────────────────────────────────────────────────
echo ""
info "All system dependencies installed."
echo ""
echo "  Next steps inside Neovim:"
echo "    :Lazy sync           – install / update all plugins"
echo "    :Mason               – verify LSP servers (ts_ls, gopls, lua_ls)"
echo "    :TSUpdate            – install Treesitter parsers"
echo ""
warn "Make sure your terminal uses a Nerd Font to render icons correctly."
