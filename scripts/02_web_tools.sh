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
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
chown root:www-data /var/www/html/info.php

# phpMyAdmin (non interactif), Geany et ABrowser en français
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install -y geany geany-plugins phpmyadmin abrowser-locale-fr
phpenmod mbstring

# Extension uBlock Origin par défaut dans ABrowser
mkdir -p /etc/abrowser/policies
cat << 'EOF' > /etc/abrowser/policies/policies.json
{
  "policies": {
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      }
    }
  }
}
EOF

# Forge logicielle Forgejo
echo "Installation de Forgejo..."
FORGEJO_VERSION="9.0.0"
wget -q -O /usr/local/bin/forgejo "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-amd64"
chmod +x /usr/local/bin/forgejo

# Utilisateur et répertoires Forgejo
adduser --system --shell /bin/bash --group --disabled-password --home /home/git git || true
mkdir -p /var/lib/forgejo/{data,custom,indexers,log} /etc/forgejo

# Configuration par défaut de Forgejo
cat << 'EOF' > /etc/forgejo/app.ini
APP_NAME = Webcorp Forge
RUN_USER = git
WORK_PATH = /var/lib/forgejo
RUN_MODE = prod

[database]
DB_TYPE = sqlite3
PATH = /var/lib/forgejo/data/forgejo.db

[repository]
ROOT = /var/lib/forgejo/data/repositories

[server]
SSH_DOMAIN = localhost
DOMAIN = localhost
HTTP_PORT = 3000
ROOT_URL = http://localhost:3000/
DISABLE_SSH = false
SSH_PORT = 22

[service]
DISABLE_REGISTRATION = false
REQUIRE_SIGNIN_VIEW = false

[security]
INSTALL_LOCK = true
SECRET_KEY = webcorp-secret-key-sae103
INTERNAL_TOKEN = webcorp-internal-token-sae103
EOF

chown -R git:git /var/lib/forgejo /etc/forgejo
chmod 750 /var/lib/forgejo
chmod 640 /etc/forgejo/app.ini

# Service systemd Forgejo
cat << 'EOF' > /etc/systemd/system/forgejo.service
[Unit]
Description=Forgejo Git Service
After=network.target mariadb.service

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/forgejo/
ExecStart=/usr/local/bin/forgejo web --config /etc/forgejo/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/forgejo

[Install]
WantedBy=multi-user.target
EOF
systemctl enable forgejo.service 2>/dev/null || true

# Commande webcorp-status
cp "$REPO_DIR/configs/bin/webcorp-status" /usr/local/bin/webcorp-status
chmod 755 /usr/local/bin/webcorp-status

echo "Étape 2 terminée."
