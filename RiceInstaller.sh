#!/bin/bash

set -e

# Rutas
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Lista de configuraciones en ~/.config
CONFIGS=(bspwm sxhkd alacritty picom polybar dunst nvim rofi ranger obsidian fastfetch)

# Archivos fuera de .config
HOME_FILES=(.zshrc .p10k.zsh)
SCRIPTS_DIR="$CONFIG_DIR/Scripts"
WALLPAPERS_DIR="$HOME/Wallpapers"

echo "🛡️  Creando carpeta de respaldo en: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cd "$DOTFILES_DIR"

# Función para respaldar ~/.config/<app> ➜ $BACKUP_DIR/.config/<app>
respaldar_config() {
  for app in "${CONFIGS[@]}"; do
    src="$CONFIG_DIR/$app"
    dest="$BACKUP_DIR/.config/$app"
    if [ -d "$src" ]; then
      echo "📁 Respaldando configuración: $src"
      mkdir -p "$(dirname "$dest")"
      mv "$src" "$dest"
    fi
  done
}

# Función para respaldar archivos como ~/.zshrc ➜ $BACKUP_DIR/.zshrc
respaldar_archivos_home() {
  for file in "${HOME_FILES[@]}"; do
    src="$HOME/$file"
    dest="$BACKUP_DIR/$file"
    if [ -f "$src" ]; then
      echo "📄 Respaldando archivo: $src"
      mv "$src" "$dest"
    fi
  done
}

# Respaldar scripts ➜ $BACKUP_DIR/.config/Scripts
respaldar_scripts() {
  if [ -d "$SCRIPTS_DIR" ]; then
    echo "🚀 Respaldando scripts personales"
    mkdir -p "$BACKUP_DIR/.config"
    mv "$SCRIPTS_DIR" "$BACKUP_DIR/.config/"
  fi
}

# Respaldar Wallpapers ➜ $BACKUP_DIR/Wallpapers
respaldar_wallpapers() {
  if [ -d "$WALLPAPERS_DIR" ]; then
    echo "🖼️  Respaldando wallpapers"
    mv "$WALLPAPERS_DIR" "$BACKUP_DIR/"
  fi
}

# Aplicar symlinks con stow desde dotfiles
enlazar_con_stow() {
  echo "🔗 Enlazando configuraciones con stow"
  for dir in */; do
    [[ "$dir" == "fonts/" ]] && continue
    stow "${dir%/}"
  done
}

# Ejecutar pasos
respaldar_config
respaldar_archivos_home
respaldar_scripts
#respaldar_wallpapers
enlazar_con_stow

echo "✅ Dotfiles enlazados correctamente."
echo "📦 Respaldo guardado en: $BACKUP_DIR"
