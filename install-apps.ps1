<#
.SYNOPSIS
    Installe automatiquement une liste de logiciels via winget (Windows Package Manager).

.DESCRIPTION
    Lit la liste des logiciels dans config\apps.json et installe chacun d'eux
    silencieusement avec winget. Enregistre chaque resultat dans deploy.log.
    Utile pour preparer rapidement un poste de travail neuf avec les logiciels
    standards d'une entreprise, plutot que de tout installer a la main.

.PREREQUIS
    - Windows 10/11 avec winget installe (present par defaut sur les versions recentes).
    - Verifier avec : winget --version

.USAGE
    powershell -ExecutionPolicy Bypass -File .\install-apps.ps1
#>

param(
    [string]$ConfigPath = ".\config\apps.json"
)

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Host $line
    Add-Content -Path ".\deploy.log" -Value $line
}

# Verifie que winget est disponible
$wingetCheck = Get-Command winget -ErrorAction SilentlyContinue
if (-not $wingetCheck) {
    Write-Log "ERREUR : winget n'est pas installe ou introuvable dans le PATH. Installe 'App Installer' depuis le Microsoft Store puis reessaie."
    exit 1
}

if (-not (Test-Path $ConfigPath)) {
    Write-Log "ERREUR : fichier de configuration introuvable ($ConfigPath)."
    exit 1
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

Write-Log "Debut du deploiement de $($config.apps.Count) logiciel(s)."

$successCount = 0
$failCount = 0

foreach ($app in $config.apps) {
    Write-Log "Installation en cours : $($app.name) ($($app.id))"

    try {
        # --silent : pas de fenetre d'installation. --accept-*-agreements : accepte les licences automatiquement.
        $process = Start-Process -FilePath "winget" `
            -ArgumentList "install --id $($app.id) --silent --accept-package-agreements --accept-source-agreements" `
            -Wait -PassThru -NoNewWindow

        if ($process.ExitCode -eq 0) {
            Write-Log "OK : $($app.name) installe avec succes."
            $successCount++
        }
        else {
            Write-Log "ECHEC : $($app.name) (code de sortie $($process.ExitCode))."
            $failCount++
        }
    }
    catch {
        Write-Log "ECHEC : $($app.name) ($($_.Exception.Message))"
        $failCount++
    }
}

Write-Log "Deploiement termine : $successCount reussite(s), $failCount echec(s)."
