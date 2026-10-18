#!/bin/bash
# --- VARIABLES ---
IMAGE="background.png"
POLICE="Ubuntu"
TAILLE_POLICE=11
HAUTEUR_BARRE=32
COULEUR_BARRE=4126322925
OPACITE=255
FICHIER_OPENBOX="$HOME/.config/openbox/lxde-rc.xml"
FICHIER_BARRE="$HOME/.config/lxpanel/Trisquel-mini/panels/panel"
# --- FOND D'ECRAN ---
sleep 2
pcmanfm --set-wallpaper="$IMAGE" --wallpaper-mode=crop
# --- POLICE DU SYSTEME ---
gsettings set org.gnome.desktop.interface font-name "$POLICE $TAILLE_POLICE"
# --- POLICE DES TITRES DES FENETRES ---
xmlstarlet ed -L \
-u "/openbox_config/theme/font[@place='ActiveWindow']/name" -v "$POLICE" \
-u "/openbox_config/theme/font[@place='ActiveWindow']/size" -v "$TAILLE_POLICE" \
"$FICHIER_OPENBOX"
openbox --reconfigure
# --- BARRE DES TACHES ---
sed -i \
-e 's/edge=bottom/edge=top/g' \
-e "s/height=[0-9]*/height=$HAUTEUR_BARRE/g" \
-e "s/usebackground=[0-9]*/usebackground=0/g" \
-e "s/backgroundcolor=[0-9]*/backgroundcolor=$COULEUR_BARRE/g" \
-e "s/backgroundalpha=[0-9]*/backgroundalpha=$OPACITE/g" \
"$FICHIER_BARRE"
lxpanelctl restart
echo "Configuration terminee !"
