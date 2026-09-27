# 💻 Deploy Tool — Déploiement automatisé de postes de travail

Ensemble de scripts **PowerShell** qui automatisent la préparation d'un poste de travail Windows : installation silencieuse des logiciels standards et application des mises à jour Windows.

Projet réalisé pour mettre en pratique des compétences de **support informatique / déploiement de postes**, en lien direct avec mon expérience d'installation et de mise à jour de systèmes Windows.

## ✨ Fonctionnalités

- Installation silencieuse d'une liste de logiciels via **winget** (Windows Package Manager)
- Liste des logiciels définie dans un simple fichier de configuration (`config/apps.json`), modifiable sans toucher au code
- Vérification et installation automatique des mises à jour Windows via le module **PSWindowsUpdate**
- Journalisation complète de chaque action (`deploy.log`)
- Script maître (`deploy-all.ps1`) qui enchaîne les deux étapes en une seule commande

## 📁 Structure du projet

```
deploy-tool/
├── config/
│   └── apps.json               # Liste des logiciels a installer (nom + identifiant winget)
├── install-apps.ps1             # Installe les logiciels de la liste
├── apply-windows-updates.ps1    # Verifie et installe les mises a jour Windows
├── deploy-all.ps1               # Lance les deux etapes a la suite
├── .gitignore
└── README.md
```

## 🚀 Utilisation

1. Vérifier que `winget` est installé :
   ```powershell
   winget --version
   ```
   (Présent par défaut sur Windows 10/11 récents. Sinon, installer "App Installer" depuis le Microsoft Store.)

2. Adapter la liste des logiciels dans `config\apps.json` selon les besoins.

3. Lancer le déploiement complet **en PowerShell en tant qu'administrateur** (clic droit sur PowerShell > Exécuter en tant qu'administrateur) :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\deploy-all.ps1
   ```

   Ou lancer chaque étape séparément :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install-apps.ps1
   powershell -ExecutionPolicy Bypass -File .\apply-windows-updates.ps1
   ```

4. Consulter `deploy.log` pour le détail de chaque action (succès/échec, logiciel par logiciel).

## 🔧 Ce que ce projet démontre

- Automatisation de tâches répétitives de support informatique (installation, mises à jour)
- Utilisation d'un gestionnaire de paquets (winget) plutôt que des installations manuelles
- Gestion des droits administrateur nécessaires à certaines opérations système
- Configuration externalisée (JSON) pour rendre le script réutilisable sans le modifier
- Journalisation pour assurer la traçabilité d'un déploiement, essentielle en environnement professionnel

## 📌 Pistes d'amélioration

- Déploiement à distance sur plusieurs postes via PowerShell Remoting (`Invoke-Command`)
- Rapport HTML récapitulatif envoyé par email après chaque déploiement
- Détection automatique des logiciels déjà installés pour éviter les doublons
