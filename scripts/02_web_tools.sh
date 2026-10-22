#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

export DEBIAN_FRONTEND=noninteractive

echo "--- 2. Outils de développement Web ---"

# Droits sur /var/www/html pour développer sans sudo
mkdir -p /var/www/html
chown -R root:www-data /var/www/html
chmod -R 775 /var/www/html
chmod -R g+s /var/www/html

# Les futurs utilisateurs feront partie du groupe www-data
sed -i 's/^#*ADD_EXTRA_GROUPS=.*/ADD_EXTRA_GROUPS=1/' /etc/default/useradd
grep -q "^EXTRA_GROUPS=" /etc/default/useradd && sed -i 's/^EXTRA_GROUPS=.*/EXTRA_GROUPS="www-data"/' /etc/default/useradd || echo 'EXTRA_GROUPS="www-data"' >> /etc/default/useradd

# Page de test PHP
cp "$REPO_DIR/configs/web/info.php" /var/www/html/info.php
chown root:www-data /var/www/html/info.php

# phpMyAdmin (non interactif), Geany et ABrowser en français
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install -y geany geany-plugins phpmyadmin abrowser-locale-fr
phpenmod mbstring

# Extension uBlock Origin par défaut dans ABrowser
mkdir -p /etc/abrowser/policies
cp "$REPO_DIR/configs/abrowser/policies.json" /etc/abrowser/policies/policies.json

# Forge logicielle Forgejo
echo "Installation de Forgejo..."
FORGEJO_VERSION="9.0.0"
wget -q -O /usr/local/bin/forgejo "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-amd64"
chmod +x /usr/local/bin/forgejo

# Utilisateur et répertoires Forgejo
adduser --system --shell /bin/bash --group --disabled-password --home /home/git git || true
mkdir -p /var/lib/forgejo/{data,custom,indexers,log} /etc/forgejo

# Configuration et service Forgejo
cp "$REPO_DIR/configs/forgejo/app.ini" /etc/forgejo/app.ini
chown -R git:git /var/lib/forgejo /etc/forgejo
chmod 750 /var/lib/forgejo
chmod 640 /etc/forgejo/app.ini

cp "$REPO_DIR/configs/systemd/forgejo.service" /etc/systemd/system/forgejo.service
systemctl enable forgejo.service

# Commande webcorp-status
cp "$REPO_DIR/configs/bin/webcorp-status" /usr/local/bin/webcorp-status
chmod 755 /usr/local/bin/webcorp-status

echo "Étape 2 terminée."
