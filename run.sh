#!/bin/bash
set -e

echo "=== Installation de Webcorp-OS ==="

# Rendre les scripts exécutables
chmod +x scripts/*.sh

# Exécution des étapes dans l'ordre
./scripts/01_system.sh
./scripts/02_web_tools.sh
./scripts/03_branding.sh
./scripts/04_skel.sh
./scripts/05_backup.sh

echo "=== Installation terminée avec succès ! ==="
