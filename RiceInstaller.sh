#!/bin/bash

set -e

echo "🔧 Iniciando bootstrap de dotfiles..."

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📦 Los archivos anteriores serán respaldados en: $BACKUP_DIR"

# Función para respaldar y eliminar si no es symlink
backup_and_remove() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "⚠️  Archivo real detectado: $target"
    mkdir -p "$BACKUP_DIR$(dirname "$target")"
    mv "$target" "$BACKUP_DIR$target"
    echo "📁 Backup movido a: $BACKUP_DIR$target"
  fi
}

# 1. Archivos en $HOME
HOME_DOTFILES=(
  ".zshrc"
  ".p10k.zsh"
)

for file in "${HOME_DOTFILES[@]}"; do
  backup_and_remove "$HOME/$file"
done

# 2. Directorios en ~/.config/
CONFIG_PACKAGES=$(find . -mindepth 2 -type d -path "./*/.config/*" -printf "%P\n" | cut -d/ -f2 | sort -u)

for pkg in $CONFIG_PACKAGES; do
  if [ -d "$HOME/.config/$pkg" ] && [ ! -L "$HOME/.config/$pkg" ]; then
    echo "⚠️  Configuración existente en conflicto: ~/.config/$pkg"
    mkdir -p "$BACKUP_DIR/.config"
    mv "$HOME/.config/$pkg" "$BACKUP_DIR/.config/"
    echo "📁 Backup movido a: $BACKUP_DIR/.config/$pkg"
  fi
done

# 3. Ejecutar stow para dotfiles normales
echo "🔗 Enlazando dotfiles con stow..."
for dir in */; do
  [ -f "$dir/.stow-local-ignore" ] && continue
  echo "📂 stow ${dir%/}"
  stow "${dir%/}"
done

echo "✅ Bootstrap completado correctamente."
echo "🔒 Backups almacenados en: $BACKUP_DIR"
