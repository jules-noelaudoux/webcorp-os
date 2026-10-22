# Aide-Mémoire HTML5 & CSS3 - Webcorp

Ce document récapitule les balises HTML et les propriétés CSS indispensables pour le développement web.

---

## 1. Structure de base d'une page HTML5

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Titre de la page</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Bienvenue</h1>
    <p>Contenu principal de la page.</p>

    <script src="script.js"></script>
</body>
</html>
```

---

## 2. Balises HTML courantes

### Balises sémantiques de structure
- `<header>` : En-tête de la page ou d'une section.
- `<nav>` : Liens principaux de navigation.
- `<main>` : Contenu principal unique du document.
- `<section>` : Section thématique de contenu.
- `<article>` : Bloc autonome et réutilisable (article, fiche produit).
- `<aside>` : Contenu secondaire ou barre latérale.
- `<footer>` : Pied de page (mentions, crédits, liens).

### Texte et titres
- `<h1>` à `<h6>` : Niveaux de titres (du plus important au moins important).
- `<p>` : Paragraphe de texte.
- `<strong>` : Texte d'importance forte (affiché en gras par défaut).
- `<em>` : Texte avec emphase (affiché en italique par défaut).
- `<blockquote>` : Citation longue.
- `<br>` : Saut de ligne simple.
- `<hr>` : Séparateur horizontal / rupture thématique.

### Listes
- `<ul>` + `<li>` : Liste à puces (non ordonnée).
- `<ol>` + `<li>` : Liste numérotée (ordonnée).

### Liens et Médias
- `<a href="https://example.com" target="_blank">Lien</a>` : Lien hypertexte.
- `<img src="image.png" alt="Description obligatoire" width="300">` : Image.
- `<figure>` et `<figcaption>` : Image ou illustration avec sa légende.

### Tableaux
```html
<table>
    <thead>
        <tr>
            <th>Nom</th>
            <th>Rôle</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Alice</td>
            <td>Développeuse</td>
        </tr>
    </tbody>
</table>
```

### Formulaires
```html
<form action="/traitement.php" method="POST">
    <label for="nom">Nom :</label>
    <input type="text" id="nom" name="nom" required>

    <label for="email">Email :</label>
    <input type="email" id="email" name="email">

    <label for="mdp">Mot de passe :</label>
    <input type="password" id="mdp" name="mdp">

    <label for="message">Message :</label>
    <textarea id="message" name="message" rows="4"></textarea>

    <button type="submit">Envoyer</button>
</form>
```

---

## 3. Sélecteurs CSS de base

| Sélecteur | Syntaxe | Exemple | Cible |
| :--- | :--- | :--- | :--- |
| Élément | `balise` | `p { color: red; }` | Tous les paragraphes |
| Classe | `.classe` | `.btn { padding: 8px; }` | Éléments avec `class="btn"` |
| Identifiant | `#id` | `#header { height: 60px; }` | L'élément avec `id="header"` |
| Descendant | `A B` | `nav a { color: blue; }` | Tous les `<a>` situés dans `<nav>` |
| Enfant direct | `A > B` | `ul > li { list-style: none; }` | Les `<li>` enfants directs de `<ul>` |
| Pseudo-classe | `:hover` | `a:hover { text-decoration: underline; }` | Au survol de la souris |

---

## 4. Mise en page avec Flexbox

Pour aligner et distribuer facilement des éléments sur un axe :

```css
.conteneur {
    display: flex;
    flex-direction: row;          /* row (défaut) ou column */
    justify-content: space-between;/* alignement axe principal : flex-start, center, space-between */
    align-items: center;          /* alignement axe secondaire : stretch, center, flex-start */
    gap: 16px;                    /* espacement entre les éléments */
    flex-wrap: wrap;              /* passage à la ligne si pas assez de place */
}

.element {
    flex: 1;                      /* chaque élément occupe un espace équitable */
}
```

---

## 5. Propriétés de texte et couleurs fréquentes

```css
body {
    font-family: Arial, sans-serif;
    font-size: 16px;
    line-height: 1.5;             /* Hauteur de ligne pour la lisibilité */
    color: #333333;               /* Couleur du texte */
    background-color: #f8f9fa;    /* Couleur de fond */
}

h1 {
    font-size: 2rem;
    text-align: center;
    text-transform: uppercase;
}

a {
    text-decoration: none;
}
```
