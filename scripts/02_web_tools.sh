#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "--- 2. Outils de développement Web ---"

# Droits sur /var/www/html pour que les développeurs puissent coder sans sudo
mkdir -p /var/www/html
chown -R root:www-data /var/www/html
chmod -R 775 /var/www/html
chmod -R g+s /var/www/html

# Les futurs utilisateurs feront partie du groupe www-data
if [ -f /etc/default/useradd ]; then
    grep -q "^EXTRA_GROUPS=" /etc/default/useradd && sed -i 's/^EXTRA_GROUPS=.*/EXTRA_GROUPS="www-data"/' /etc/default/useradd || echo 'EXTRA_GROUPS="www-data"' >> /etc/default/useradd
    sed -i 's/^#*ADD_EXTRA_GROUPS=.*/ADD_EXTRA_GROUPS=1/' /etc/default/useradd
fi

# Page de test PHP
cat << 'EOF' > /var/www/html/info.php
<?php
phpinfo();
?>
EOF
chown root:www-data /var/www/html/info.php

# Éditeur de code léger (Geany)
apt-get install -y geany geany-plugins

# phpMyAdmin (en mode non interactif pour ne pas bloquer dans Cubic)
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install -y phpmyadmin
phpenmod mbstring || true

# ABrowser en français
apt-get install -y abrowser-locale-fr || apt-get install -y firefox-locale-fr || true

# Extension uBlock Origin par défaut via les policies de Mozilla
mkdir -p /etc/abrowser/policies /etc/firefox/policies
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
cp /etc/abrowser/policies/policies.json /etc/firefox/policies/policies.json 2>/dev/null || true

# Forge logicielle Forgejo
echo "Installation de Forgejo..."
FORGEJO_VERSION="9.0.0"
wget -q -O /usr/local/bin/forgejo "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-amd64" || true
if [ -f /usr/local/bin/forgejo ]; then
    chmod +x /usr/local/bin/forgejo

    # Utilisateur et répertoires de Forgejo
    id git &>/dev/null || adduser --system --shell /bin/bash --group --disabled-password --home /home/git git
    mkdir -p /var/lib/forgejo/{data,custom,indexers,log} /etc/forgejo
    chown -R git:git /var/lib/forgejo /etc/forgejo
    chmod 750 /var/lib/forgejo

    # Service systemd pour lancer Forgejo au démarrage
    cat << 'EOF' > /etc/systemd/system/forgejo.service
[Unit]
Description=Forgejo
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
fi

echo "Fin de l'étape 2."
