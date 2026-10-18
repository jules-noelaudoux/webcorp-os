#!/bin/bash
set -e

echo "--- 5. Configuration de la sauvegarde chiffrée (Restic) ---"

mkdir -p /var/backups/webcorp-restic /etc/webcorp

# Configuration du mot de passe de chiffrement Restic
cat << 'EOF' > /etc/webcorp/backup.env
RESTIC_REPOSITORY="/var/backups/webcorp-restic"
RESTIC_PASSWORD="webcorp-backup-password"
EOF
chmod 600 /etc/webcorp/backup.env

# Script de sauvegarde
cat << 'EOF' > /usr/local/bin/webcorp-backup.sh
#!/bin/bash
set -e

source /etc/webcorp/backup.env
export RESTIC_REPOSITORY RESTIC_PASSWORD

# Dump des bases MariaDB si le serveur tourne
if command -v mariadb-dump &>/dev/null; then
    mariadb-dump --all-databases > /var/backups/dump_mariadb.sql 2>/dev/null || true
fi

# Initialisation du dépôt chiffré si premier lancement
if ! restic snapshots &>/dev/null; then
    restic init
fi

# Sauvegarde des fichiers importants
restic backup /var/www/html /etc/apache2 /etc/php /var/lib/forgejo /home /var/backups/dump_mariadb.sql 2>/dev/null || \
restic backup /var/www/html /etc/apache2 /home

# Garder les sauvegardes des 7 derniers jours et 4 dernières semaines
restic forget --keep-daily 7 --keep-weekly 4 --prune || true

rm -f /var/backups/dump_mariadb.sql
echo "Sauvegarde terminée le $(date)"
EOF
chmod 750 /usr/local/bin/webcorp-backup.sh

# Script utilitaire pour lister les sauvegardes facilement
cat << 'EOF' > /usr/local/bin/webcorp-backup-list.sh
#!/bin/bash
source /etc/webcorp/backup.env
export RESTIC_REPOSITORY RESTIC_PASSWORD
restic snapshots
EOF
chmod 750 /usr/local/bin/webcorp-backup-list.sh

# Service systemd
cat << 'EOF' > /etc/systemd/system/webcorp-backup.service
[Unit]
Description=Sauvegarde automatique Webcorp

[Service]
Type=oneshot
ExecStart=/usr/local/bin/webcorp-backup.sh
EOF

# Timer systemd (tous les jours à 2h du matin)
cat << 'EOF' > /etc/systemd/system/webcorp-backup.timer
[Unit]
Description=Sauvegarde quotidienne Webcorp

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload 2>/dev/null || true
systemctl enable webcorp-backup.timer 2>/dev/null || true

echo "Sauvegarde automatique configurée !"
