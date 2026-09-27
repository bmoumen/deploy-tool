<#
.SYNOPSIS
    Script maitre : deploie un poste de travail en une seule commande.

.DESCRIPTION
    Enchaine les deux etapes d'un deploiement de poste :
      1. Installation des logiciels standards (install-apps.ps1)
      2. Application des mises a jour Windows (apply-windows-updates.ps1)
    C'est le script a lancer sur un poste neuf pour le preparer automatiquement.

.USAGE
    powershell -ExecutionPolicy Bypass -File .\deploy-all.ps1
#>

Write-Host "=== ETAPE 1/2 : Installation des logiciels ==="
& .\install-apps.ps1

Write-Host ""
Write-Host "=== ETAPE 2/2 : Mises a jour Windows ==="
& .\apply-windows-updates.ps1

Write-Host ""
Write-Host "=== Deploiement termine. Consulte deploy.log pour le detail complet. ==="
