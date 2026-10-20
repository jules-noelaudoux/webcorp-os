#!/bin/bash
set -e

# Dossiers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- VARIABLES ---
IMAGE="$REPO_DIR/assets/background.png"
DEST_IMAGE="/usr/share/backgrounds/webcorp/background.png"
POLICE="Ubuntu"
TAILLE_POLICE=11
HAUTEUR_BARRE=32
COULEUR_BARRE=4126322925
OPACITE=255

echo "--- 3. Personnalisation graphique ---"

# Police Ubuntu
apt-get install -y fonts-ubuntu || true

# Affichage dans le terminal
apt install toilet toilet-fonts -y

# Copie du fond d'écran
mkdir -p /usr/share/backgrounds/webcorp
if [ -f "$IMAGE" ]; then
    cp "$IMAGE" "$DEST_IMAGE"
fi

# Fond d'écran pour l'écran de connexion LXDM
if [ -f /etc/xdg/trisquel-mini/lxdm/lxdm.conf ]; then
    sed -i "s|^bg=.*|bg=$DEST_IMAGE|" /etc/xdg/trisquel-mini/lxdm/lxdm.conf
fi

# Fond d'écran par défaut PCManFM
for f in /etc/xdg/pcmanfm/LXDE/pcmanfm.conf /etc/xdg/pcmanfm/default/pcmanfm.conf; do
    if [ -f "$f" ]; then
        sed -i "s|^wallpaper=.*|wallpaper=$DEST_IMAGE|" "$f"
        sed -i "s|^wallpaper_mode=.*|wallpaper_mode=crop|" "$f"
    fi
done

# Police du système
if [ -f /etc/xdg/lxsession/Trisquel-mini/desktop.conf ]; then
    sed -i "s|^sGtk/FontName=.*|sGtk/FontName=$POLICE $TAILLE_POLICE|" /etc/xdg/lxsession/Trisquel-mini/desktop.conf
fi

# Police des titres des fenêtres Openbox
for f in /etc/xdg/openbox/LXDE/rc.xml /etc/xdg/openbox/rc.xml; do
    if [ -f "$f" ] && command -v xmlstarlet &>/dev/null; then
        xmlstarlet ed -L \
            -u "/openbox_config/theme/font[@place='ActiveWindow']/name" -v "$POLICE" \
            -u "/openbox_config/theme/font[@place='ActiveWindow']/size" -v "$TAILLE_POLICE" \
            "$f" 2>/dev/null || true
    fi
done

# Barre des tâches lxpanel (placée en haut avec la couleur du thème)
FICHIER_BARRE="/usr/share/lxpanel/profile/Trisquel-mini/panels/panel"
if [ -f "$FICHIER_BARRE" ]; then
    sed -i \
        -e 's/edge=bottom/edge=top/g' \
        -e "s/height=[0-9]*/height=$HAUTEUR_BARRE/g" \
        -e "s/usebackground=[0-9]*/usebackground=0/g" \
        -e "s/backgroundcolor=[0-9]*/backgroundcolor=$COULEUR_BARRE/g" \
        -e "s/backgroundalpha=[0-9]*/backgroundalpha=$OPACITE/g" \
        "$FICHIER_BARRE"
fi

# Modèle pour les futurs utilisateurs dans /etc/skel
mkdir -p /etc/skel/.config/lxpanel/Trisquel-mini/panels /etc/skel/.config/pcmanfm/Trisquel-mini
if [ -f "$FICHIER_BARRE" ]; then
    cp "$FICHIER_BARRE" /etc/skel/.config/lxpanel/Trisquel-mini/panels/panel
fi

cat << EOF > /etc/skel/.config/pcmanfm/Trisquel-mini/pcmanfm.conf
[desktop]
wallpaper_mode=crop
wallpaper=$DEST_IMAGE
desktop_bg=#0F141C
desktop_fg=#E6EDF3
EOF

# Script autostart pour appliquer le fond d'écran au démarrage
mkdir -p /etc/xdg/autostart
cat << 'EOF' > /usr/local/bin/set_wallpaper.sh
#!/bin/bash
if command -v pcmanfm &>/dev/null; then
    sleep 1
    pcmanfm --set-wallpaper="/usr/share/backgrounds/webcorp/background.png" --wallpaper-mode=crop || true
fi
EOF
chmod +x /usr/local/bin/set_wallpaper.sh

if [ -f "$REPO_DIR/assets/autostart" ]; then
    cp "$REPO_DIR/assets/autostart" /etc/xdg/autostart/set_wallpaper.desktop
fi

# Si le script est testé directement dans une session graphique
if [ -n "$DISPLAY" ]; then
    pcmanfm --set-wallpaper="$DEST_IMAGE" --wallpaper-mode=crop 2>/dev/null || true
    openbox --reconfigure 2>/dev/null || true
    lxpanelctl restart 2>/dev/null || true
fi

echo "Configuration branding terminée !"
