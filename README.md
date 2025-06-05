# 🎬 PowerShell Renamer

Un script PowerShell ⚡️ pour renommer proprement vos fichiers de **films** et de **séries**.  
Il supprime automatiquement les balises inutiles comme `[OxTorrent.com]`, `FRENCH`, `WEBRip`, `1080p`, `x264`, etc.  
Et il remet les noms au bon format 👌

---

## 📂 Organisation des dossiers

Le script s'attend à trouver les vidéos dans deux dossiers distincts :
EXEMPLE :
D:\Users\TON_NOM\Videos\FILMS
D:\Users\TON_NOM\Videos\SERIES\

Si vous utilisez d'autres chemins, **pensez à modifier ces deux lignes dans le script** :

# Chemins par défaut (à modifier si besoin)
$pathFilms = "CHEMIN VERS VOS FILMS"
$pathSeries = "CHEMIN VERS VOS SERIES"

🛠️ Format de renommage
Films : Nom du Film (AAAA).ext
➜ Exemple : Inception (2010).mp4

Séries : Nom de la Série S01E01.ext
➜ Exemple : Breaking Bad S02E03.mkv

Tout ce qui est entre crochets [ ] ou après un tiret - inutile est supprimé 🧹

✏️ Dernières modifications du script
✨ Nettoyage des noms de fichiers encore plus précis

🧠 Exclusion automatique des balises comme KISSMAN, MULTi, XviD, HDTV, etc.

🛠️ Ajout de chemins configurables $pathFilms et $pathSeries