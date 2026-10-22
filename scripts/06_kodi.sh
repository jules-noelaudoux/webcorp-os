#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "--- 6. Installation de Kodi ---"

add-apt-repository -y ppa:team-xbmc/ppa
apt-get update
apt-get install -y kodi

echo "Étape 6 terminée."
