#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

DEST_IMAGE="/usr/share/backgrounds/webcorp/background.png"

echo "--- 3. Personnalisation graphique ---"

# Police Ubuntu et affichage du terminal
apt-get install -y fonts-ubuntu toilet toilet-fonts

# Fond d'écran Webcorp
mkdir -p /usr/share/backgrounds/webcorp
cp "$REPO_DIR/assets/background.png" "$DEST_IMAGE"

# Écran de connexion (LXDM)
sed -i "s|^bg=.*|bg=$DEST_IMAGE|" /etc/xdg/trisquel-mini/lxdm/lxdm.conf 2>/dev/null || true

# Bureau par défaut (PCManFM)
for f in /etc/xdg/pcmanfm/LXDE/pcmanfm.conf /etc/xdg/pcmanfm/default/pcmanfm.conf; do
    [ -f "$f" ] && sed -i -e "s|^wallpaper=.*|wallpaper=$DEST_IMAGE|" -e "s|^wallpaper_mode=.*|wallpaper_mode=crop|" "$f"
done

# Police de l'interface (LXSession et Openbox)
sed -i "s|^sGtk/FontName=.*|sGtk/FontName=Ubuntu 11|" /etc/xdg/lxsession/Trisquel-mini/desktop.conf 2>/dev/null || true
for f in /etc/xdg/openbox/LXDE/rc.xml /etc/xdg/openbox/rc.xml; do
    [ -f "$f" ] && xmlstarlet ed -L \
        -u "/openbox_config/theme/font[@place='ActiveWindow']/name" -v "Ubuntu" \
        -u "/openbox_config/theme/font[@place='ActiveWindow']/size" -v "11" "$f" 2>/dev/null || true
done

# Barre des tâches LXPanel (en haut, hauteur 32, couleur thème sombre)
FICHIER_BARRE="/usr/share/lxpanel/profile/Trisquel-mini/panels/panel"
if [ -f "$FICHIER_BARRE" ]; then
    sed -i \
        -e 's/edge=bottom/edge=top/' \
        -e 's/height=[0-9]*/height=32/' \
        -e 's/usebackground=[0-9]*/usebackground=0/' \
        -e 's/backgroundcolor=[0-9]*/backgroundcolor=4126322925/' \
        -e 's/backgroundalpha=[0-9]*/backgroundalpha=255/' \
        "$FICHIER_BARRE"

    mkdir -p /etc/skel/.config/lxpanel/Trisquel-mini/panels
    cp "$FICHIER_BARRE" /etc/skel/.config/lxpanel/Trisquel-mini/panels/panel
fi

# Configuration PCManFM pour les utilisateurs (/etc/skel)
mkdir -p /etc/skel/.config/pcmanfm/Trisquel-mini
cp "$REPO_DIR/configs/skel/.config/pcmanfm/Trisquel-mini/pcmanfm.conf" /etc/skel/.config/pcmanfm/Trisquel-mini/pcmanfm.conf

# Script autostart pour appliquer le fond d'écran à l'ouverture de session
mkdir -p /etc/xdg/autostart
cp "$REPO_DIR/configs/bin/set_wallpaper.sh" /usr/local/bin/set_wallpaper.sh
chmod 755 /usr/local/bin/set_wallpaper.sh

cp "$REPO_DIR/assets/autostart" /etc/xdg/autostart/set_wallpaper.desktop

echo "Étape 3 terminée."
