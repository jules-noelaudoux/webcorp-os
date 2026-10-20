# Webcorp-OS

Distribution Linux sur-mesure basée sur **Trisquel 12 LTS Ecne Mini** pour le projet de **SAE 103** (BUT 1 Informatique).  
Réalisé par **Jules Noël-Audoux**, **Joey Lemaire** et **Matthieu Chauvin**.

Le système est conçu comme un poste de travail prêt à l'emploi pour les développeurs web de l'entreprise fictive **Webcorp**.

## TODO

- [ ] Installer Kodi
- [ ] Configurer Kodi
- [ ] Derniers checks

---

## 1. Ce qui est installé et configuré

- **Pile LAMP** : Apache 2 (avec module MPM-ITK), MariaDB 10.11 et PHP 8.3 (modules `curl`, `gd`, `mbstring`, `mysql`, `xml`, `zip`, `intl`).
- **Outils de développement** :
  - **phpMyAdmin** : interface web de gestion des bases de données (`http://localhost/phpmyadmin`).
  - **Geany** : éditeur de code léger avec coloration syntaxique et plugins.
  - **Forgejo** : forge logicielle Git locale auto-hébergée (`http://localhost:3000`).
- **Espace de travail `/var/www/html`** : droits configurés (groupe `www-data`, permissions `775` et setgid) permettant aux utilisateurs de créer et modifier leurs sites sans `sudo`.
- **Portail développeur local** : page d'accueil accessible sur `http://localhost/` avec accès rapides vers les projets, phpMyAdmin, Forgejo, la configuration PHP et les aide-mémoires.
- **Navigateur ABrowser** : dérivé libre de Firefox, configuré par défaut en français et équipé de l'extension **uBlock Origin**.
- **Sauvegarde chiffrée (Restic)** : sauvegarde automatique quotidienne programmée à 2h du matin (`webcorp-backup.timer`) avec chiffrement AES-256 et politique de rétention.
- **Personnalisation graphique** :
  - Fond d'écran Webcorp par défaut (bureau et écran de connexion LXDM).
  - Barre des tâches LXPanel placée en haut avec le thème sombre de l'entreprise.
  - Police Ubuntu 11 appliquée sur l'interface et le gestionnaire de fenêtres Openbox.
  - Modèle `/etc/skel` personnalisé : invite de commande colorée avec affichage dynamique de la branche Git, alias utiles et aide-mémoires.

---

## 2. Commandes et alias utiles

| Commande | Action |
| :--- | :--- |
| `sites` | Se place directement dans `/var/www/html` pour travailler sur les projets web. |
| `webcorp-status` | Affiche l'état des services (Apache, MariaDB, Forgejo, droits `/var/www/html`, timer de sauvegarde). |
| `backup-now` | Déclenche immédiatement une sauvegarde chiffrée complète (bases SQL, `/var/www/html`, configs, Forgejo). |
| `backup-list` | Affiche l'historique des snapshots Restic avec date et taille. |
| `mariadb` | Connexion directe au client SQL sans mot de passe via le fichier `~/.my.cnf`. |
| `reload` | Recharge instantanément la configuration du terminal (`~/.bashrc`). |

---

## 3. Aide-mémoires intégrés

Deux aide-mémoires au format Markdown sont fournis sur le Bureau et dans le dossier `~/cheatsheets/` :
- **`cheatsheet_html_css.md`** : structure HTML5, balises courantes, formulaires, tableaux, sélecteurs CSS, modèle de boîte et Flexbox.
- **`cheatsheet_alias.md`** : récapitulatif des raccourcis et alias configurés sur le poste.

---

## 4. Démonstration pour la soutenance

Le scénario de test pour la soutenance s'articule autour des étapes suivantes :
1. **Démarrage et environnement** : vérifier le thème graphique (barre en haut, fond d'écran), les raccourcis du Bureau et l'accueil dans le terminal.
2. **État des services** : lancer `webcorp-status` pour s'assurer qu'Apache, MariaDB et Forgejo tournent.
3. **Développement Web** : taper `sites`, créer un fichier dans `/var/www/html` sans `sudo`, et l'ouvrir sur `http://localhost/`.
4. **Base de données** : tester la connexion SQL via la commande `mariadb`, puis sur l'interface `http://localhost/phpmyadmin` avec le compte `admin_local`.
5. **Forge logicielle** : ouvrir Forgejo sur `http://localhost:3000`.
6. **Sauvegarde** : lancer `backup-now` puis `backup-list` pour valider le bon fonctionnement de Restic.

---

## 5. Comment reconstruire l'ISO avec Cubic

1. Installer et lancer **Cubic** sur Ubuntu/WSL :
   ```bash
   cubic
   ```
2. Choisir un dossier de travail et charger l'image d'origine `trisquel-mini_12.0_amd64.iso`.
3. Dans le terminal virtuel (chroot) de Cubic, cloner le dépôt et lancer le script d'installation :
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
5. Cliquer sur **Next** dans Cubic sans modifier les fichiers de preseed/bootloader, puis cliquer sur **Generate** pour obtenir l'ISO finale.

---

## 6. Configuration minimale de la VM

- **Processeur** : 1 à 2 cœurs x86_64.
- **Mémoire vive (RAM)** : 2 Go minimum (4 Go recommandés pour naviguer confortablement avec ABrowser).
- **Stockage** : Disque virtuel de 20 Go (comme prescrit par le sujet).
