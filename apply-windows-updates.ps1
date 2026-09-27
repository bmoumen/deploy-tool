<#
.SYNOPSIS
    Verifie et installe les mises a jour Windows disponibles.

.DESCRIPTION
    Utilise le module PSWindowsUpdate (installe automatiquement s'il est absent)
    pour lister puis installer les mises a jour Windows en attente. Enregistre
    le resultat dans deploy.log. A executer en PowerShell en tant qu'administrateur.

.USAGE
    powershell -ExecutionPolicy Bypass -File .\apply-windows-updates.ps1
#>

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Host $line
    Add-Content -Path ".\deploy.log" -Value $line
}

# Verifie les droits administrateur (necessaires pour installer des mises a jour)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Log "ERREUR : ce script doit etre execute en tant qu'administrateur (clic droit sur PowerShell > Executer en tant qu'administrateur)."
    exit 1
}

# Installe le module PSWindowsUpdate s'il n'est pas deja present
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Log "Module PSWindowsUpdate absent, installation en cours..."
    try {
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser -ErrorAction Stop
        Write-Log "Module PSWindowsUpdate installe."
    }
    catch {
        Write-Log "ERREUR : impossible d'installer PSWindowsUpdate ($($_.Exception.Message))."
        exit 1
    }
}

Import-Module PSWindowsUpdate

Write-Log "Recherche des mises a jour disponibles..."
$updates = Get-WindowsUpdate

if ($updates.Count -eq 0) {
    Write-Log "Aucune mise a jour disponible. Le poste est deja a jour."
    exit 0
}

Write-Log "$($updates.Count) mise(s) a jour trouvee(s) : $($updates.Title -join ', ')"
Write-Log "Installation des mises a jour en cours (cela peut prendre du temps)..."

try {
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -ErrorAction Stop | ForEach-Object {
        Write-Log "OK : $($_.Title)"
    }
    Write-Log "Mises a jour installees avec succes."
}
catch {
    Write-Log "ERREUR pendant l'installation des mises a jour : $($_.Exception.Message)"
    exit 1
}
