
![Description de l'image](image.png)

# 🚀 PowerShell Renamer

Bienvenue dans **PowerShell-Renamer**, un script PowerShell intelligent 🧠 conçu pour nettoyer et renommer vos fichiers vidéo téléchargés via torrent. Organisez vos fichiers comme un chef ! 🍿📁

---

## 🛠️ À quoi ça sert ?

Ce script vous permet de renommer automatiquement les fichiers de séries et de films en supprimant les balises inutiles comme `MULTi`, `1080p`, `x264`, etc. Il vous propose un aperçu des modifications avant de les appliquer, vous laissant le contrôle total sur chaque changement.

---

## 🧾 Configuration initiale

Avant de commencer, vous devez configurer les chemins vers vos dossiers de films et de séries dans le script. Voici comment faire :

1. Ouvrez le script dans un éditeur de texte.
2. Modifiez les lignes suivantes pour refléter les chemins de vos dossiers :

```powershell
# Chemins par défaut (à modifier selon vos besoins)
$pathFilms = "CHEMIN_VERS_VOS_FILMS"
$pathSeries = "CHEMIN_VERS_VOS_SERIES"
```

🚨 **Assurez-vous de remplacer ces chemins** par ceux de vos dossiers `FILMS` et `SERIES`. Attention à respecter les noms ou adapte-les dans le script sinon... ça marche pas 🤷‍♂️.

---

## 🎮 Comment l’utiliser ?

1. **Ouvrez PowerShell** : Assurez-vous d'avoir les droits nécessaires pour exécuter des scripts.
2. **Exécutez le script** : Faites un clic droit sur le fichier du script et sélectionnez "Exécuter avec PowerShell", ou exécutez-le via la console PowerShell.
3. **Choisissez le mode** :
   - `S` pour **simuler** et voir ce que le script ferait sans appliquer les changements.
   - `T` pour **renommer** réellement les fichiers.
4. **Validez ou non les changement** : Vous pouvez choisir de valider automatiquement.

Si vous avez choisi la **simulation**, vous verrez une liste des changements proposés sans qu'aucun fichier ne soit réellement modifié.

---

## 📦 Fonctionnalités à venir

## 📦 À venir (ou pas 😅)

- Interface graphique avec des licornes.
- Fusion auto avec Jellyfin.
- Téléportation de fichiers (on y travaille).

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Si vous avez des suggestions ou des améliorations, n'hésitez pas

---

## ⭐ Soutien

Fais-toi plaisir, et si tu kiffes le script, laisse une ⭐ sur le dépôt. Ou pas. Mais c’est cool quand même 😉

---

N'hésitez pas à explorer et à adapter ce script à vos besoins. Bonne organisation de vos fichiers vidéo ! 🎬🌟