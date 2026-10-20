# Raccourcis et Alias - Webcorp-OS

Ce guide regroupe les commandes et alias personnalisés préconfigurés sur votre poste de travail.

---

## 1. Développement Web et Projets

| Commande / Alias | Commande réelle | Description |
| :--- | :--- | :--- |
| `sites` | `cd /var/www/html` | Se place directement dans le dossier racine de développement web. |
| `mariadb` | `mariadb` (via `~/.my.cnf`) | Connexion directe au serveur SQL sans ressaisir identifiant et mot de passe. |
| `mysql` | `mysql` (via `~/.my.cnf`) | Équivalent à la commande mariadb ci-dessus. |

---

## 2. Sauvegarde Chiffrée (Restic)

Le système intègre une sauvegarde automatique quotidienne à 2h du matin. Vous disposez aussi de commandes manuelles :

| Commande | Description |
| :--- | :--- |
| `backup-now` | Déclenche immédiatement une sauvegarde chiffrée complète (export SQL des bases de données MariaDB, `/var/www/html`, configurations Apache/PHP, Forgejo et dossiers personnels). |
| `backup-list` | Affiche l'historique de tous les snapshots de sauvegarde enregistrés avec leur ID, date et taille. |

> **Note :** Ces commandes s'exécutent avec les privilèges administrateur (`sudo`) pour accéder aux dossiers système et au dépôt chiffré situé dans `/var/backups/webcorp-restic`.

---

## 3. Gestionnaires de Paquets et Conteneurs

### Node.js / NPM
| Alias | Commande réelle | Utilité |
| :--- | :--- | :--- |
| `ni` | `npm install` | Installe les dépendances listées dans le fichier `package.json`. |
| `nr` | `npm run` | Exécute un script défini dans `package.json` (ex: `nr dev`, `nr build`). |
| `ns` | `npm start` | Démarre l'application Node.js. |

### Docker
| Alias | Commande réelle | Utilité |
| :--- | :--- | :--- |
| `dps` | `docker ps` | Affiche la liste des conteneurs en cours d'exécution. |
| `dc` | `docker compose` | Raccourci pour piloter les stacks Docker Compose. |

---

## 4. Outils Système et Terminal

| Alias | Commande réelle | Description |
| :--- | :--- | :--- |
| `reload` | `source ~/.bash_profile` | Recharge instantanément la configuration du terminal et les alias sans fermer la fenêtre. |

---

## 5. Services et Raccourcis du Poste

Des raccourcis sont également présents sur votre Bureau pour un accès rapide en un clic :
- **phpMyAdmin** : `http://localhost/phpmyadmin` (gestion des bases MariaDB).
- **Forgejo Git** : `http://localhost:3000` (forge logicielle git locale).
- **Projets Web** : ouverture directe du gestionnaire de fichiers dans `/var/www/html`.
