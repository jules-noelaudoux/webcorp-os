#!/bin/bash
# Ajoute automatiquement les utilisateurs normaux (UID >= 1000) au groupe www-data
while IFS=: read -r username _ uid _ _ _ _; do
    if [ "$uid" -ge 1000 ] 2>/dev/null && [ "$uid" -lt 60000 ] 2>/dev/null; then
        adduser "$username" www-data 2>/dev/null || true
    fi
done < /etc/passwd
