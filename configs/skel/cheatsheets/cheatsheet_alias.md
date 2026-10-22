# Raccourcis et Alias - Webcorp-OS

Ce guide regroupe les commandes et alias personnalisés disponibles sur votre poste de travail.

---

## 1. Développement Web et Projets

| Commande / Alias | Commande réelle | Description |
| :--- | :--- | :--- |
| `sites` | `cd /var/www/html` | Se place directement dans le dossier racine de développement web. |
| `webcorp-status` | `webcorp-status` | Diagnostic rapide de l'état des services (Apache, MariaDB, Forgejo, sauvegarde, dossier web). |
| `mariadb` | `mariadb` (via `~/.my.cnf`) | Connexion directe au serveur SQL sans ressaisir l'identifiant et le mot de passe. |
| `mysql` | `mysql` (via `~/.my.cnf`) | Équivalent à la commande mariadb ci-dessus. |

---

## 2. Sauvegarde Chiffrée (Restic)

Le système intègre une sauvegarde automatique quotidienne à 2h du matin (`webcorp-backup.timer`). Vous disposez aussi de deux commandes rapides :

| Commande | Description |
| :--- | :--- |
| `backup-now` | Déclenche immédiatement une sauvegarde chiffrée complète (export SQL des bases de données MariaDB, `/var/www/html`, configurations Apache/PHP, Forgejo et dossiers personnels). |
| `backup-list` | Affiche l'historique de tous les snapshots de sauvegarde enregistrés avec leur ID, date et taille. |

---

## 3. Terminal et Navigation

| Alias | Commande réelle | Description |
| :--- | :--- | :--- |
| `ll` | `ls -lah --color=auto` | Affichage détaillé des fichiers (avec taille lisible et fichiers cachés). |
| `la` | `ls -A --color=auto` | Liste tous les fichiers y compris les fichiers cachés (sauf `.` et `..`). |
| `l` | `ls -CF --color=auto` | Affichage compact en colonnes avec indicateurs de type. |
| `reload` | `source ~/.bashrc` | Recharge instantanément la configuration du terminal et les alias sans fermer la fenêtre. |

---

## 4. Services et Raccourcis du Bureau

Des raccourcis sont présents sur votre Bureau pour un accès direct :
- **phpMyAdmin** : `http://localhost/phpmyadmin` (gestion graphique des bases MariaDB).
- **Forgejo Git** : `http://localhost:3000` (forge logicielle git locale).
- **Projets Web** : ouverture du gestionnaire de fichiers dans `/var/www/html`.
- **Aide-mémoires** : dossier `cheatsheets/` contenant les mémos HTML/CSS et alias.
