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

# Portail local d'accueil développeur sur http://localhost/
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Webcorp - Portail Développeur</title>
    <style>
        body { font-family: Ubuntu, Arial, sans-serif; background: #0F141C; color: #E6EDF3; margin: 0; padding: 40px 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        h1 { color: #00A3E0; border-bottom: 2px solid #1B2230; padding-bottom: 12px; margin-bottom: 6px; }
        p.subtitle { color: #8B949E; margin-bottom: 30px; font-size: 0.95rem; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-top: 20px; }
        .card { background: #1B2230; border: 1px solid #2B3545; border-radius: 8px; padding: 20px; text-decoration: none; color: inherit; transition: border-color 0.2s; }
        .card:hover { border-color: #00A3E0; }
        .card h3 { margin: 0 0 8px 0; color: #00A3E0; font-size: 1.1rem; }
        .card p { margin: 0; font-size: 0.9rem; color: #8B949E; line-height: 1.4; }
        footer { margin-top: 50px; font-size: 0.85rem; color: #6E7681; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Webcorp &mdash; Portail Développeur</h1>
        <p class="subtitle">Environnement local Webcorp-OS (Trisquel 12 LTS Ecne Mini &mdash; SAE 103)</p>
        
        <div class="grid">
            <a class="card" href="/phpmyadmin/">
                <h3>phpMyAdmin</h3>
                <p>Administration visuelle des bases de données MariaDB.</p>
            </a>
            <a class="card" href="http://localhost:3000/">
                <h3>Forgejo Git</h3>
                <p>Forge logicielle locale et gestion des dépôts Git.</p>
            </a>
            <a class="card" href="/info.php">
                <h3>Configuration PHP</h3>
                <p>Informations sur la version et les modules PHP 8.3.</p>
            </a>
        </div>
        
        <footer>Webcorp-OS &mdash; Développé par Jules, Joey et Matthieu</footer>
    </div>
</body>
</html>
EOF
chown root:www-data /var/www/html/index.html
chmod 664 /var/www/html/index.html

# Éditeur de code léger (Geany)
apt-get install -y geany geany-plugins

# phpMyAdmin (en mode non interactif pour ne pas bloquer dans Cubic)
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
apt-get install -y phpmyadmin
phpenmod mbstring || true

# ABrowser en français
apt-get install -y abrowser-locale-fr || apt-get install -y firefox-locale-fr || true

# Extension uBlock Origin par défaut via les policies Mozilla
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

# Téléchargement local du .xpi de uBlock Origin pour installation hors-ligne
XPI_URL="https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
for EXT_DIR in "/usr/lib/abrowser/distribution/extensions" "/usr/lib/firefox/distribution/extensions" "/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"; do
    mkdir -p "$EXT_DIR"
    wget -q -O "$EXT_DIR/uBlock0@raymondhill.net.xpi" "$XPI_URL" 2>/dev/null || true
done

# Forge logicielle Forgejo
echo "Installation de Forgejo..."
FORGEJO_VERSION="9.0.0"
wget -q -O /usr/local/bin/forgejo "https://codeberg.org/forgejo/forgejo/releases/download/v${FORGEJO_VERSION}/forgejo-${FORGEJO_VERSION}-linux-amd64" || true
if [ -f /usr/local/bin/forgejo ]; then
    chmod +x /usr/local/bin/forgejo

    # Utilisateur et répertoires de Forgejo
    id git &>/dev/null || adduser --system --shell /bin/bash --group --disabled-password --home /home/git git
    mkdir -p /var/lib/forgejo/{data,custom,indexers,log} /etc/forgejo

    # Configuration par défaut prête à l'emploi (évite l'écran d'installation initial)
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

    # Service systemd pour lancer Forgejo au démarrage
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
fi

# Script utilitaire de vérification de l'état des services
cat << 'EOF' > /usr/local/bin/webcorp-status
#!/bin/bash
echo "=== État des services Webcorp-OS ==="

check_service() {
    local name="$1"
    local unit="$2"
    if systemctl is-active --quiet "$unit"; then
        echo -e "[OK] $name"
    else
        echo -e "[NON ACTIF] $name"
    fi
}

check_service "Serveur Web Apache" apache2
check_service "Base de données MariaDB" mariadb
check_service "Forge logicielle Forgejo (port 3000)" forgejo
check_service "Sauvegarde automatique Restic (timer 2h)" webcorp-backup.timer

if [ -w /var/www/html ]; then
    echo "[OK] Espace /var/www/html (inscriptible par $USER)"
else
    echo "[ATTENTION] Espace /var/www/html (non inscriptible sans sudo)"
fi
echo "====================================="
EOF
chmod 755 /usr/local/bin/webcorp-status

echo "Fin de l'étape 2."
