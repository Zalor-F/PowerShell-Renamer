<#
###############################################################################
# Script PowerShell de nettoyage de noms de fichiers vidéo (films et séries)
# - Supprime tout ce qui est entre crochets [ ... ]
# - Nettoie les tags inutiles (MULTi, 1080p, x264, etc.)
# - Conserve uniquement le nom du film suivi de l'année et de l'extension
# - Conserve uniquement le nom de la série suivi du numéro de saison
# - Propose un mode simulation (par défaut) ou renommage réel
# - Confirmation avant chaque renommage avec possibilité "tout valider"
# - Après simulation, propose de passer en renommage automatique
#
# ⚠️ Utilisation à vos risques. Toujours faire une sauvegarde avant.
###############################################################################
#>

# Chemins par défaut (à modifier si besoin)
$pathFilms = "C:\Users\Zalor\Videos\FILMS"
$pathSeries = "C:\Users\Zalor\Videos\SERIES"

# Liste des patterns à supprimer (insensible à la casse)
$patternsToRemove = @(
    'FRENCH', 'TRUEFRENCH', 'VFF', 'VF2', 'VFQ', 'VF', 'MULTi', 'TRUE', 'EN', 'Fr',
    'BluRay', 'BRRip', 'BDRip', 'HDRip', 'HDLight', 'WEB-DL', 'WEBRip', 'TSMD',
    'x264', 'XviD', 'AC3', 'DTS', 'AAC', 'H264', 'MDXViD', 'SUBFORCED', 'UNRATED', 'DTSHD-MA', 'BDHD',
    'iNTERNAL', 'PROPER', 'REPACK', 'READNFO', 'EXTENDED', 'DIRECTORS.CUT', 'UNCUT',
    'PopHD', 'GHT', 'VENUE', 'EXTREME', 'LiHDL', 'FW', 'ShowFr', 'mHDgz', 'T911',
    'LOST', 'SKRiN', 'Slay3R', 'FUNKKY', 'ZT', 'ACH', 'CaFaRDaX', 'LEGiON', 'FuN',
    'CARPEDIEM', 'AUTOPSiE', 'STVFRV', 'AViTECH', 'GHZ', 'BONBON', 'LUCKY', 'GZR',
    'HD', 'Light', 'WEB', 'DL', 'RiP', 'xvid', 'WEBH264',
    '720p', '1080p', '4K', '2160p'
)

# Fonction qui nettoie proprement un nom de fichier
function Clean-Name {
    param([string]$name)

    # 1) Supprime TOUT ce qui est entre crochets inclus [ ... ]
    $name = [regex]::Replace($name, '\[.*?\]', '')

    # 2) Supprime les patterns inutiles dans le reste du nom
    foreach ($pattern in $patternsToRemove) {
        $name = $name -replace "(?i)\b$([regex]::Escape($pattern))\b", ''
    }

    # 3) Nettoie ponctuation et espaces multiples
    $name = $name -replace '[_\.]+', ' '
    $name = $name -replace '\s{2,}', ' '

    return $name.Trim()
}

# Fonction pour nettoyer les noms de fichiers de films
function Clean-MovieName {
    param([string]$name)

    # Nettoyer le nom de base
    $cleanName = Clean-Name $name

    # Conserver uniquement le nom du film suivi de l'année et de l'extension
    $cleanName = [regex]::Replace($cleanName, '(?i)(.*)(\s\d{4})', '$1$2')

    return $cleanName.Trim()
}

# Fonction pour nettoyer les noms de fichiers de séries
function Clean-SeriesFileName {
    param([string]$name)

    # Nettoyer le nom de base
    $cleanName = Clean-Name $name

    # Trouver le motif SXXEXX et conserver uniquement le nom de la série suivi du motif SXXEXX
    $seasonEpisodePattern = '(?i)(.*?)(S\d{2}E\d{2})'
    if ($cleanName -match $seasonEpisodePattern) {
        $cleanName = $matches[1].Trim() + ' ' + $matches[2]
    }

    return $cleanName.Trim()
}

# Fonction pour nettoyer les noms de dossiers de séries
function Clean-SeriesDirectoryName {
    param([string]$name)

    # Nettoyer le nom de base
    $cleanName = Clean-Name $name

    # Trouver le motif SXX et conserver uniquement le nom de la série suivi du motif SXX
    $seasonPattern = '(?i)(.*?)(S\d{2})'
    if ($cleanName -match $seasonPattern) {
        $cleanName = $matches[1].Trim() + ' ' + $matches[2]
    }

    return $cleanName.Trim()
}

# Fonction pour demander mode et valider
function Get-Mode {
    while ($true) {
        $m = Read-Host "Choisissez le mode : [S]imulation (par défaut) / [T]rue (renommage réel)"
        if ([string]::IsNullOrWhiteSpace($m) -or $m.ToUpper() -eq 'S') { return 'Simulation' }
        elseif ($m.ToUpper() -eq 'T') { return 'Renommage' }
        else { Write-Host "Choix invalide, merci de taper S ou T." -ForegroundColor Yellow }
    }
}

# Fonction principale pour traiter les fichiers
function Process-Files {
    param(
        [string]$path,
        [string]$label,
        [string]$mode,
        [ref]$confirmAllRef
    )

    Write-Host "`n=== Traitement des fichiers $label ===" -ForegroundColor Cyan

    if (-not (Test-Path $path)) {
        Write-Host "Dossier introuvable : $path" -ForegroundColor Yellow
        return
    }

    $files = Get-ChildItem -Path $path -File -Recurse

    if ($files.Count -eq 0) {
        Write-Host "Aucun fichier trouvé dans $label." -ForegroundColor Green
        return
    }

    foreach ($file in $files) {
        $cleanBaseName = if ($label -eq "SÉRIES") { Clean-SeriesFileName $file.BaseName } else { Clean-MovieName $file.BaseName }
        $extension = $file.Extension
        $newName = "$cleanBaseName$extension"

        # Supprimer tout ce qui est entre la date et l'extension pour les films
        if ($label -eq "FILMS") {
            $newName = [regex]::Replace($newName, '(?i)(.+\d{4}).*(?=\.\w+$)', '$1')
        }

        Write-Host "[ORIGINAL] $($file.Name)"
        Write-Host "[PROPOSÉ ] $newName"

        if ($mode -eq 'Simulation') {
            Write-Host "[SIMULATION] Pas de renommage effectué." -ForegroundColor DarkGray
        }
        else {
            if (-not $confirmAllRef.Value) {
                $answer = Read-Host "Renommer ce fichier ? [O]ui / [N]on / [A] tout renommer"
                switch ($answer.ToUpper()) {
                    'O' {
                        Rename-Item -LiteralPath $file.FullName -NewName $newName -Force
                        Write-Host "[RENOMMÉ] $($file.Name) -> $newName" -ForegroundColor Green
                    }
                    'N' {
                        Write-Host "[SAUTÉ] $($file.Name)" -ForegroundColor Yellow
                    }
                    'A' {
                        Rename-Item -LiteralPath $file.FullName -NewName $newName -Force
                        Write-Host "[RENOMMÉ] $($file.Name) -> $newName" -ForegroundColor Green
                        $confirmAllRef.Value = $true
                    }
                    default {
                        Write-Host "Réponse non reconnue, fichier ignoré." -ForegroundColor Yellow
                    }
                }
            }
            else {
                Rename-Item -LiteralPath $file.FullName -NewName $newName -Force
                Write-Host "[RENOMMÉ] $($file.Name) -> $newName" -ForegroundColor Green
            }
        }
        Write-Host ""
    }
}

# Fonction principale pour traiter les dossiers
function Process-Directories {
    param(
        [string]$path,
        [string]$label,
        [string]$mode,
        [ref]$confirmAllRef
    )

    Write-Host "`n=== Traitement des dossiers $label ===" -ForegroundColor Cyan

    if (-not (Test-Path $path)) {
        Write-Host "Dossier introuvable : $path" -ForegroundColor Yellow
        return
    }

    $directories = Get-ChildItem -Path $path -Directory -Recurse

    if ($directories.Count -eq 0) {
        Write-Host "Aucun dossier trouvé dans $label." -ForegroundColor Green
        return
    }

    foreach ($directory in $directories) {
        $cleanBaseName = if ($label -eq "SÉRIES") { Clean-SeriesDirectoryName $directory.Name } else { Clean-MovieName $directory.Name }
        $newName = $cleanBaseName

        Write-Host "[ORIGINAL] $($directory.Name)"
        Write-Host "[PROPOSÉ ] $newName"

        if ($mode -eq 'Simulation') {
            Write-Host "[SIMULATION] Pas de renommage effectué." -ForegroundColor DarkGray
        }
        else {
            if (-not $confirmAllRef.Value) {
                $answer = Read-Host "Renommer ce dossier ? [O]ui / [N]on / [A] tout renommer"
                switch ($answer.ToUpper()) {
                    'O' {
                        Rename-Item -LiteralPath $directory.FullName -NewName $newName -Force
                        Write-Host "[RENOMMÉ] $($directory.Name) -> $newName" -ForegroundColor Green
                    }
                    'N' {
                        Write-Host "[SAUTÉ] $($directory.Name)" -ForegroundColor Yellow
                    }
                    'A' {
                        Rename-Item -LiteralPath $directory.FullName -NewName $newName -Force
                        Write-Host "[RENOMMÉ] $($directory.Name) -> $newName" -ForegroundColor Green
                        $confirmAllRef.Value = $true
                    }
                    default {
                        Write-Host "Réponse non reconnue, dossier ignoré." -ForegroundColor Yellow
                    }
                }
            }
            else {
                Rename-Item -LiteralPath $directory.FullName -NewName $newName -Force
                Write-Host "[RENOMMÉ] $($directory.Name) -> $newName" -ForegroundColor Green
            }
        }
        Write-Host ""
    }
}

# --------- SCRIPT PRINCIPAL ---------

$mode = Get-Mode
Write-Host "Mode sélectionné : $mode`n"

# Variable pour suivi "tout valider"
$confirmAll = $false

# Traitement des fichiers puis des dossiers
Process-Files -path $pathFilms -label "FILMS" -mode $mode -confirmAllRef ([ref]$confirmAll)
Process-Files -path $pathSeries -label "SÉRIES" -mode $mode -confirmAllRef ([ref]$confirmAll)

Process-Directories -path $pathFilms -label "FILMS" -mode $mode -confirmAllRef ([ref]$confirmAll)
Process-Directories -path $pathSeries -label "SÉRIES" -mode $mode -confirmAllRef ([ref]$confirmAll)

# Si mode simulation, proposer renommage automatique
if ($mode -eq 'Simulation') {
    $rep = Read-Host "Voulez-vous appliquer automatiquement tous les renommages proposés ? [O]ui / [N]on"
    if ($rep.ToUpper() -eq 'O') {
        Write-Host "`n--- Application automatique des renommages en mode réel ---" -ForegroundColor Cyan
        $confirmAll = $true
        Process-Files -path $pathFilms -label "FILMS" -mode 'Renommage' -confirmAllRef ([ref]$confirmAll)
        Process-Files -path $pathSeries -label "SÉRIES" -mode 'Renommage' -confirmAllRef ([ref]$confirmAll)
        Process-Directories -path $pathFilms -label "FILMS" -mode 'Renommage' -confirmAllRef ([ref]$confirmAll)
        Process-Directories -path $pathSeries -label "SÉRIES" -mode 'Renommage' -confirmAllRef ([ref]$confirmAll)
    }
}

Write-Host "`nTraitement terminé." -ForegroundColor Cyan
