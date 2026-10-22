#!/bin/bash
set -e

echo "--- 5. Configuration de la sauvegarde chiffrée (Restic) ---"

mkdir -p /var/backups/webcorp-restic /etc/webcorp

# Configuration Restic
cat << 'EOF' > /etc/webcorp/backup.env
RESTIC_REPOSITORY="/var/backups/webcorp-restic"
RESTIC_PASSWORD="webcorp-backup-password"
EOF
chmod 600 /etc/webcorp/backup.env

# Script principal de sauvegarde
cat << 'EOF' > /usr/local/bin/webcorp-backup.sh
#!/bin/bash
set -e

[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"

source /etc/webcorp/backup.env
export RESTIC_REPOSITORY RESTIC_PASSWORD

echo "--- Sauvegarde Webcorp (Restic) ---"

# Export SQL
mariadb-dump --all-databases > /var/backups/dump_mariadb.sql 2>/dev/null || true

# Initialisation du dépôt si premier lancement
restic snapshots &>/dev/null || restic init

# Sauvegarde des projets, configurations et bases de données
restic backup /var/www/html /etc/apache2 /etc/php /var/lib/forgejo /home /var/backups/dump_mariadb.sql 2>/dev/null || \
restic backup /var/www/html /etc/apache2 /home

# Rétention : 7 jours et 4 semaines
restic forget --keep-daily 7 --keep-weekly 4 --prune || true

rm -f /var/backups/dump_mariadb.sql
echo "Sauvegarde terminée le $(date)"
EOF
chmod 755 /usr/local/bin/webcorp-backup.sh

# Script utilitaire pour lister les sauvegardes
cat << 'EOF' > /usr/local/bin/webcorp-backup-list.sh
#!/bin/bash
[ "$EUID" -ne 0 ] && exec sudo "$0" "$@"

source /etc/webcorp/backup.env
export RESTIC_REPOSITORY RESTIC_PASSWORD
restic snapshots
EOF
chmod 755 /usr/local/bin/webcorp-backup-list.sh

# Raccourcis dans le PATH
ln -sf /usr/local/bin/webcorp-backup.sh /usr/local/bin/backup-now
ln -sf /usr/local/bin/webcorp-backup-list.sh /usr/local/bin/backup-list

# Service et Timer systemd (tous les jours à 2h)
cat << 'EOF' > /etc/systemd/system/webcorp-backup.service
[Unit]
Description=Sauvegarde automatique Webcorp

[Service]
Type=oneshot
ExecStart=/usr/local/bin/webcorp-backup.sh
EOF

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

echo "Étape 5 terminée."
