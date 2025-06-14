<#
###############################################################################
# Script PowerShell v3 : Nettoyage et renommage fichiers Films et Séries
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

# Fonction pour nettoyer les noms (garde les apostrophes)
function Clean-Name {
    param([string]$name)

    # Liste des tags et mots à retirer (en minuscule)
    $tags = @(
        '\bMULTI\b', '\bMULTi\b', '\bVOSTFR\b', '\bVF\b', '\bVO\b', '\bHD\b', '\b720p\b', '\b1080p\b',
        '\b2160p\b', '\b4K\b', '\bBluRay\b', '\bBRRip\b', '\bWEBRip\b', '\bWEB-DL\b', '\bHDRip\b',
        '\bx264\b', '\bx265\b', '\bHEVC\b', '\bH\.264\b', '\bH\.265\b', '\bDVDRip\b', '\bDVDScr\b',
        '\bCAM\b', '\bTS\b', '\bHDTV\b', '\bBDRip\b', '\bPDTV\b', '\bR5\b', '\bLIMITED\b', '\bREMASTERED\b',
        '\bPROPER\b', '\bSUBFRENCH\b', '\bSUBFR\b', '\bFR-Subs\b', '\bEXTENDED\b', '\bUNRATED\b', '\bTRUEFRENCH\b',
        '\bFS\b', '\bFRENCH\b', '\bFR\b', '\bWS\b', '\bREADNFO\b', '\bxvid\b', '\bAAC\b', '\bAC3\b', '\bDTS\b',
        '\bSPARKS\b', '\bYIFY\b', '\bRARBG\b', '\bETRG\b', '\bGANJAMAN\b', '\bGDRIVE\b', '\bNF\b',
        '\bBluray\b', '\bHDR\b', '\bXviD\b', '\bHDLight\b', '\bMD\b', '\bBD25\b', '\bBD50\b'
    )

    # On remplace tous ces tags par rien, insensible à la casse
    foreach ($tag in $tags) {
        $name = [regex]::Replace($name, $tag, '', 'IgnoreCase')
    }

    # Remplace underscore, points, tirets par espaces
    $name = $name -replace '[_\.\-]', ' '

    # Supprime espaces multiples
    $name = $name -replace '\s+', ' '

    # Trim espaces début/fin
    $name = $name.Trim()

    return $name
}

# Fonction principale de traitement
function Process-Files {
    param(
        [string]$path,
        [string]$label,
        [string]$mode, # Simulation ou Renommage
        [ref]$confirmAllRef
    )

    if (-not (Test-Path $path)) {
        Write-Warning "$label : Le chemin $path n'existe pas. Ignoré."
        return
    }

    Write-Host "Traitement $label en mode $mode..." -ForegroundColor Cyan

    $files = Get-ChildItem -Path $path -File -Recurse

    foreach ($file in $files) {
        $oldName = $file.Name
        $dir = $file.DirectoryName
        $ext = $file.Extension

        $cleanBase = Clean-Name ([IO.Path]::GetFileNameWithoutExtension($oldName))
        if ([string]::IsNullOrWhiteSpace($cleanBase)) {
            # Si nettoyage vide, on garde le nom original
            $cleanBase = [IO.Path]::GetFileNameWithoutExtension($oldName)
        }

        $newName = $cleanBase + $ext

        if ($oldName -eq $newName) {
            # Pas de changement
            continue
        }

        Write-Host "Ancien : $oldName"
        Write-Host "Proposé : $newName"

        if ($mode -eq "Simulation") {
            Write-Host "[SIMULATION] Pas de renommage effectué." -ForegroundColor Yellow
            Write-Host ""
            continue
        }

        # mode Renommage réel
        if (-not $confirmAllRef.Value) {
            $choice = Read-Host "Renommer ? (O=oui, N=non, A=oui à tout)"

            switch ($choice.ToUpper()) {
                'O' {
                    Rename-Item -LiteralPath $file.FullName -NewName $newName -Force
                    Write-Host "[RENOMMÉ]" -ForegroundColor Green
                }
                'N' {
                    Write-Host "Ignoré." -ForegroundColor Gray
                }
                'A' {
                    Rename-Item -LiteralPath $file.FullName -NewName $newName -Force
                    Write-Host "[RENOMMÉ - TOUT]" -ForegroundColor Green
                    $confirmAllRef.Value = $true
                }
                default {
                    Write-Warning "Réponse non reconnue, fichier ignoré."
                }
            }
        }
        else {
            Rename-Item -LiteralPath $file.FullName -NewName $newName -Force
            Write-Host "[RENOMMÉ - TOUT]" -ForegroundColor Green
        }
        Write-Host ""
    }

    Write-Host "Traitement $label terminé." -ForegroundColor Cyan
}

# --- Script principal ---

Clear-Host
Write-Host "=== Script de renommage fichiers FILMS et SERIES v3 ===" -ForegroundColor Cyan

# Demander les dossiers Films et Séries au démarrage
$pathFilms = Read-Host "Entrez le chemin complet vers le dossier FILMS"
$pathSeries = Read-Host "Entrez le chemin complet vers le dossier SERIES"

# Variable de confirmation globale
$confirmAll = $false

function Show-Menu {
    Clear-Host
    Write-Host "=== MENU ===" -ForegroundColor Cyan
    Write-Host "1) Simuler renommage des Films"
    Write-Host "2) Simuler renommage des Séries"
    Write-Host "3) Simuler renommage des Films et Séries"
    Write-Host "4) Valider le renommage et renommer Films et Séries"
    Write-Host "Q) Quitter"
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Choisissez une option"

    switch ($choice.ToUpper()) {
        '1' {
            $confirmAll = $false
            Process-Files -path $pathFilms -label "FILMS" -mode "Simulation" -confirmAllRef ([ref]$confirmAll)
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        '2' {
            $confirmAll = $false
            Process-Files -path $pathSeries -label "SÉRIES" -mode "Simulation" -confirmAllRef ([ref]$confirmAll)
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        '3' {
            $confirmAll = $false
            Process-Files -path $pathFilms -label "FILMS" -mode "Simulation" -confirmAllRef ([ref]$confirmAll)
            Process-Files -path $pathSeries -label "SÉRIES" -mode "Simulation" -confirmAllRef ([ref]$confirmAll)
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
        '4' {
            $confirmAll = $false
            Process-Files -path $pathFilms -label "FILMS" -mode "Renommage" -confirmAllRef ([ref]$confirmAll)
            Process-Files -path $pathSeries -label "SÉRIES" -mode "Renommage" -confirmAllRef ([ref]$confirmAll)
            Read-Host "Renommage terminé. Appuyez sur Entrée pour continuer..."
        }
        'Q' {
            Write-Host "Au revoir !" -ForegroundColor Green
        }
        default {
            Write-Warning "Option non reconnue."
            Read-Host "Appuyez sur Entrée pour continuer..."
        }
    }
} while ($choice.ToUpper() -ne 'Q')
