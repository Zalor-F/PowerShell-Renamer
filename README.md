# 🚀 PowerShell Renamer

Bienvenue dans **PowerShell-Renamer.ps1**, un petit script 🧠 malin qui nettoie et renomme tes fichiers vidéos pour les organiser comme un chef ! 🍿📁

---

## 🛠️ À quoi ça sert ?

Ce script permet de renommer automatiquement les fichiers de séries et de films en supprimant les balises inutiles comme `MULTi`, `1080p`, `x264`, etc. Il te propose un aperçu de ce qu’il va faire, et c’est toi le boss : tu valides ou pas chaque fichier !

---

## 🧾 À modifier avant de commencer

Dans le script, tu trouveras ces lignes :

```powershell
# Chemins par défaut (à modifier si besoin)
$pathFilms = "CHEMIN VERS VOS FILMS"
$pathSeries = "CHEMIN VERS VOS SERIES"
```

🚨 **Remplace ces chemins** par ceux de tes dossiers `FILMS` et `SERIES`. Attention à respecter les noms ou adapte-les dans le script sinon... ça marche pas 🤷‍♂️.

---

## 🎮 Comment l’utiliser ?

1. Ouvre PowerShell.
2. Lance le script avec un bon vieux clic droit > "Exécuter avec PowerShell" (ou via la console).
3. Laisse-le faire sa magie 🪄.
4. Fait ton choix :
   - `S` pour simuler et lister 
   - `O` pour Oui (on valide et on renomme)
   - `N` pour Non (on laisse comme c’est)

Et si tu as choisi la **simulation** au départ, rien n’est modifié, tu vois juste ce qu’il aurait fait.

---

## 📦 À venir (ou pas 😅)

- Interface graphique avec des licornes.
- Fusion auto avec Jellyfin.
- Téléportation de fichiers (on y travaille).

---

Fais-toi plaisir, et si tu kiffes le script, laisse une ⭐ sur le dépôt. Ou pas. Mais c’est cool quand même 😉
