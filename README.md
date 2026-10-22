# Webcorp-OS

Projet de **SAE 103** (BUT 1 Informatique) : création d'une distribution Linux personnalisée basée sur **Trisquel 12 Mini** pour les développeurs web de l'entreprise Webcorp.

**Équipe :** Jules Noël-Audoux, Joey Lemaire, Matthieu Chauvin.

## TODO

- [x] Installer Kodi
- [ ] Configurer Kodi
- [ ] Page d'accueil locale du portail développeur (index.html)
- [x] Script de diagnostic des services (webcorp-status)
- [ ] Derniers checks

---

## Fonctionnalités

- **Serveur web & BDD** : Apache 2, MariaDB et PHP (avec phpMyAdmin sur `http://localhost/phpmyadmin`).
- **Forge Git locale** : Forgejo auto-hébergé sur `http://localhost:3000`.
- **Logiciels** : Geany, Kodi, navigateur ABrowser avec uBlock Origin.
- **Sauvegarde** : Restic configuré avec une tâche automatique quotidienne à 2h du matin.
- **Apparence** : fond d'écran Webcorp, barre des tâches placée en haut, thème sombre et invite de commande avec la branche Git.
- **Aide-mémoires** : fiches mémos sur le Bureau et dans `~/cheatsheets/` (HTML/CSS et alias).

---

## Post-installation (droits développeur)

Le dossier `/var/www/html` est configuré avec les droits du groupe `www-data`. Pour qu'un employé puisse modifier et créer des sites sans `sudo`, il faut simplement l'ajouter au groupe :

```bash
sudo adduser $USER www-data
```

Il suffit ensuite de se déconnecter et se reconnecter (ou d'exécuter `newgrp www-data`) pour appliquer le changement.

---

## Commandes utiles

| Commande | Description |
| :--- | :--- |
| `webcorp-status` | Affiche l'état des services (Apache, MariaDB, Forgejo, timer Restic, droits sur `/var/www/html`). |
| `sites` | Se place directement dans `/var/www/html`. |
| `backup-now` | Déclenche une sauvegarde complète immédiatement. |
| `backup-list` | Affiche les sauvegardes existantes. |
| `mariadb` | Ouvre le client MySQL sans demander de mot de passe (via `~/.my.cnf`). |
| `reload` | Recharge la configuration du terminal (`~/.bashrc`). |

---

## Démonstration pour la soutenance

1. **Environnement** : fond d'écran Webcorp, barre en haut, raccourcis sur le Bureau.
2. **État des services** : lancer `webcorp-status` pour vérifier qu'Apache, MariaDB, Forgejo et la sauvegarde tournent.
3. **Droits** : montrer que l'utilisateur peut créer des fichiers dans `/var/www/html` sans `sudo` (via `sites`).
4. **Base de données** : tester la commande `mariadb` dans le terminal et l'interface `http://localhost/phpmyadmin`.
5. **Forge Git** : ouvrir Forgejo sur `http://localhost:3000`.
6. **Sauvegarde** : lancer `backup-now` puis `backup-list`.

---

## Génération de l'ISO avec Cubic

1. Lancer Cubic avec l'ISO d'origine `trisquel-mini_12.0_amd64.iso`.
2. Dans le terminal virtuel (chroot) de Cubic :
   ```bash
   git clone https://github.com/jules-noelaudoux/webcorp-os.git
   cd webcorp-os
   ./run.sh
   ```
3. Suivre les étapes dans Cubic et cliquer sur **Generate**.
