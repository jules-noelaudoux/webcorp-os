#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "--- 4. Configuration de /etc/skel ---"

mkdir -p /etc/skel/bin /etc/skel/.local/bin

# Copie des dotfiles du dépôt vers /etc/skel
cp "$REPO_DIR/configs/skel/.bashrc" /etc/skel/.bashrc
cp "$REPO_DIR/configs/skel/.bash_profile" /etc/skel/.bash_profile
chmod 644 /etc/skel/.bashrc /etc/skel/.bash_profile

# Copie aussi pour root
cp /etc/skel/.bashrc /root/.bashrc 2>/dev/null || true
cp /etc/skel/.bash_profile /root/.bash_profile 2>/dev/null || true

echo "Configuration de /etc/skel terminée !"
