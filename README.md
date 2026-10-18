# Webcorp-OS

Projet de **SAE 103** (BUT 1 Informatique) réalisé par **Jules**, **Joey** et **Matthieu**.

Ce projet permet de créer une distribution Linux sur-mesure basée sur **Trisquel 12 LTS Ecne Mini** pour équiper les ordinateurs portables des développeurs web de l'entreprise fictive **Webcorp**.

---

## Ce qui est installé et configuré

- **Pile Web LAMP** : Apache 2 (avec le module `mpm-itk`), MariaDB et PHP avec ses extensions utiles.
- **Outils de développement** :
  - **phpMyAdmin** pour gérer les bases de données via le navigateur (`http://localhost/phpmyadmin`).
  - **Geany** comme éditeur de code léger.
  - **Forgejo** comme forge logicielle Git auto-hébergée.
- **Espace de travail Web** : Le dossier `/var/www/html` a les droits configurés (groupe `www-data`) pour que l'utilisateur puisse créer et modifier des sites sans utiliser `sudo`.
- **Navigateur ABrowser** : Configuré en français avec l'extension **uBlock Origin** installée par défaut.
- **Sauvegarde chiffrée automatique** : Mise en place de **Restic** avec un script de sauvegarde (`/usr/local/bin/webcorp-backup.sh`) et un timer `systemd` qui se lance tous les jours à 2h.
- **Personnalisation & Thème** :
  - Fond d'écran Webcorp.
  - Barre des tâches LXPanel placée en haut avec la couleur ardoise du thème.
  - Polices Ubuntu 11 appliquées sur le système et Openbox.
  - Profil `/etc/skel` personnalisé avec prompt Git coloré et alias dans `.bashrc` et `.bash_profile`.

---

## Comment reconstruire l'ISO avec Cubic

1. Installer et lancer **Cubic** sur Ubuntu/WSL :
   ```bash
   cubic
   ```
2. Choisir un dossier pour le projet et sélectionner l'ISO d'origine `trisquel-mini_12.0_amd64.iso`.
3. Une fois dans le terminal chroot de Cubic, cloner le dépôt et lancer l'installation :
   ```bash
   git clone https://github.com/jules-noelaudoux/webcorp-os.git
   cd webcorp-os
   chmod +x run.sh scripts/*.sh
   ./run.sh
   ```
4. Supprimer le dossier du dépôt avant de quitter le chroot pour ne pas alourdir l'ISO :
   ```bash
   cd ..
   rm -rf webcorp-os
   ```
5. Cliquer sur **Next** dans Cubic pour terminer et générer l'image ISO finale.

---

## Configuration minimale de la VM

- **Processeur** : 1 ou 2 cœurs.
- **RAM** : 2 Go minimum (4 Go conseillés pour être à l'aise avec ABrowser et MariaDB).
- **Disque** : 20 Go (comme demandé pour le projet).
