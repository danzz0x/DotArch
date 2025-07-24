#!/bin/bash

set -e

# 🎨 Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[0;31m'
RESET='\033[0m'

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup"
CONFIG_DIR="$HOME/.config"
HOME_FILES=(.zshrc .p10k.zsh)
CONFIGS=(bspwm sxhkd alacritty picom polybar dunst nvim rofi ranger fastfetch)

# ✅ Verificar existencia del repositorio
verificar_repositorio() {
  if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo -e "${RED}Error: $DOTFILES_DIR no es un repositorio git válido.${RESET}"
    exit 1
  fi
}

# ✅ Verificar e instalar dependencias
instalar_dependencias() {
  local paquetes=(stow git pv)
  local por_instalar=()

  echo -e "${CYAN}🔍 Verificando dependencias necesarias...${RESET}"
  for pkg in "${paquetes[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
      por_instalar+=("$pkg")
    fi
  done

  if [ ${#por_instalar[@]} -gt 0 ]; then
    echo -e "${YELLOW}📦 Instalando dependencias: ${por_instalar[*]}${RESET}"
    sudo pacman -S --noconfirm "${por_instalar[@]}"
  else
    echo -e "${GREEN}✅ Todas las dependencias están instaladas.${RESET}"
  fi
}

# 💬 Animación con pv o echo fallback
animar() {
  if command -v pv >/dev/null 2>&1; then
    echo -n "$1" | pv -qL 20
  else
    echo "$1"
  fi
  sleep 0.3
}

# 🧠 Backup si no es symlink
# 🧠 Backup del directorio completo si no es symlink
respaldo_directorio_si_conflicto() {
  local ruta="$1"
  if [ -d "$ruta" ] && [ ! -L "$ruta" ]; then
    echo -e "${RED}⚠️  Conflicto con: $ruta${RESET}"
    mkdir -p "$BACKUP_DIR$(dirname "$ruta")"
    mv "$ruta" "$BACKUP_DIR$ruta"
    echo -e "📦 Carpeta movida a: ${YELLOW}$BACKUP_DIR$ruta${RESET}"
  fi
}

# 🖼️ Manejo especial de Wallpapers
manejar_wallpapers() {
  local wallpapers_src="$DOTFILES_DIR/wallpapers"
  local wallpapers_dest="$HOME/Wallpapers"

  if [ -d "$wallpapers_dest" ]; then
    echo -e "${CYAN}🖼️  Directorio Wallpapers existente. Copiando contenido...${RESET}"
    cp -R "$wallpapers_src/Wallpapers/"* "$wallpapers_dest/"
  else
    echo -e "${CYAN}🔗 Enlazando Wallpapers con stow...${RESET}"
    stow -d "$DOTFILES_DIR" -t "$HOME" wallpapers
  fi
}

# 🛠️ Instalación inicial
instalar_dotfiles() {
  echo -e "${CYAN}📦 Instalando dotfiles...${RESET}"
  mkdir -p "$BACKUP_DIR"

  # Backup de configs existentes
  for app in "${CONFIGS[@]}"; do

    if [ -d "$CONFIG_DIR/$app" ] && [ ! -L "$CONFIG_DIR/$app" ]; then

      echo -e "${YELLOW}→ $app${RESET}"
      mkdir -p "$BACKUP_DIR/.config"
      mv "$CONFIG_DIR/$app" "$BACKUP_DIR/.config/"
    fi
  done

  for file in "${HOME_FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
      echo -e "${YELLOW}→ $file${RESET}"
      mv "$HOME/$file" "$BACKUP_DIR/"
    fi
  done

  [ -d "$CONFIG_DIR/Scripts" ] && mv "$CONFIG_DIR/Scripts" "$BACKUP_DIR/.config/"

  # Enlazar con Stow
  echo -e "${CYAN}🔗 Enlazando dotfiles...${RESET}"
  cd "$DOTFILES_DIR"
  for dir in */; do
    [[ "$dir" == "fonts/" ]] && continue
    echo "stow ${dir%/}"
    stow --restow --ignore="README.md|LICENSE" -v "${dir%/}"
  done

  # Manejar Wallpapers especial
  if [ -d "Wallpapers" ]; then
    manejar_wallpapers
  fi

  echo -e "${GREEN}✅ Instalación completada.${RESET}"
}

# 🔄 Actualización segura
# 🔄 Actualización segura de dotfiles
# 🔄 Actualización segura de dotfiles
actualizar_dotfiles() {
  echo -e "${CYAN}🔄 Actualizando dotfiles...${RESET}"
  cd "$DOTFILES_DIR"
  git pull
  mkdir -p "$BACKUP_DIR"

  # Actualizar con Stow
  for dir in */; do
    [[ "$dir" == "fonts/" ]] && continue
    echo -e "${CYAN}→ ${dir%/}${RESET}"

    # Calcular ruta de destino (ej: ~/.config/alacritty o ~/.zshrc)
    if [[ "$dir" == .* ]]; then
      destino="$HOME/$dir"
    else
      destino="$HOME/.config/${dir%/}"
    fi

    # Eliminar la barra final
    destino="${destino%/}"

    respaldo_directorio_si_conflicto "$destino"

    stow --restow --ignore="README.md|LICENSE" -v "${dir%/}"
  done

  # Actualizar Wallpapers
  if [ -d "Wallpapers" ]; then
    manejar_wallpapers
  fi

  echo -e "${GREEN}✅ Actualización completada.${RESET}"
}

# ▶️ Menú interactivo
clear
verificar_repositorio
echo -e "${CYAN}═══════════════════════════════════════"
echo -e "     GESTOR DE DOTFILES - BSPWM      "
echo -e "═══════════════════════════════════════${RESET}"
echo ""
echo -e "${YELLOW}¿Qué deseas hacer?${RESET}"
echo "1) Instalar (primera vez)"
echo "2) Actualizar (añadir cambios nuevos)"
echo "3) Salir"
echo ""

# Verifica e instala dependencias necesarias
instalar_dependencias

read -rp "👉 Elige una opción [1-3]: " opcion

case "$opcion" in
1)
  animar "Iniciando instalación..."
  instalar_dotfiles
  ;;
2)
  animar "Iniciando actualización..."
  actualizar_dotfiles
  ;;
3)
  echo -e "${GREEN}Hasta pronto.${RESET}"
  exit 0
  ;;
*)
  echo -e "${RED}❌ Opción inválida.${RESET}"
  exit 1
  ;;
esac

echo -e "${YELLOW}📦 Respaldos en:${RESET} $BACKUP_DIR"
