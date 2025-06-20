# 📦 SAE S1.03 – Installation de Debian & Scripts Bash

## 👥 Membres du groupe
- Betton Yaël  
- Sacristan Thurian  
- Bastide Rémi  

---

## 🧩 Objectifs du projet

Ce projet a pour but de **créer un environnement de développement complet** sous Debian via VirtualBox, puis de développer **plusieurs scripts Bash** automatisant la gestion d'une bibliothèque (emprunts, utilisateurs, groupes, etc.).

Nous avons ainsi :
- Installé une **machine virtuelle Debian 12.2.0** (via VirtualBox)
- Configuré Debian avec l'environnement XFCE
- Installé Visual Studio Code dans la VM
- Développé des **scripts Bash** robustes et interactifs
- Manipulé des fichiers textes, géré les utilisateurs/groupes Unix, et appliqué des vérifications de dates et d'états

---

## 🖥️ Installation de la machine virtuelle Debian

### 📥 1. Télécharger et installer Oracle VirtualBox  
➡️ [https://www.virtualbox.org/](https://www.virtualbox.org/)

### 🧱 2. Configuration de la VM
- **Nom** : `Debian`
- **Type** : Linux
- **Version** : Debian (64-bit)
- **Mémoire RAM** : 8 Go
- **Processeurs** : 8 Cœurs
- **Disque dur** : 16 Go

### 🔧 3. Installation de Debian (version netinst)
- Interface : `Graphical Install`
- Langue/clavier : Français
- Interface graphique : `XFCE`
- Partitionnement manuel :
  - `ext4` pour `/`
  - `swap` de 2 Go

### 🛠️ 4. Post-installation
- Ajout utilisateur au groupe sudo
- Passage en plein écran via :
  ```bash
  sudo apt install make gcc dkms linux-source linux-headers-$(uname -r)

## 📜 Scripts Bash – Explications détaillées

### `comptemps.bash`  
Ce script permet de :
- **Lire une date en argument** (ex: `08 01 2025 15:30:00`)
- **Construire cette date** au format `YYYY-MM-DD HH:MM:SS`
- **Valider la date** en vérifiant qu’elle existe réellement
- **Comparer cette date à la date actuelle**
  - Affiche si la date est passée ou à venir

🔧 **Utilisations :**
- Planification d’événements
- Vérification d’échéances

---

### `demande.bash`  
Ce script gère les **demandes d’emprunts de livres**.  
Fonctionnalités :
- Vérifie la **correspondance entre les IDs** des livres et exemplaires
- Vérifie si l’exemplaire est disponible (`oui`)
- Récupère la date du jour et la découpe (heure, jour, mois, année)
- Enregistre dans `emprunts.txt` :
  - ID du livre
  - ID du membre
  - ID de l’exemplaire
  - Date d’emprunt
- Met à jour la disponibilité à `non` (via `sed`)

🔧 **Utilisations :**
- Système de gestion de bibliothèque
- Suivi des prêts

---

### `groupe.bash`  
Ce script automatise la **création de groupes et d’utilisateurs**, ainsi que les permissions.

Fonctionnalités :
- Crée des **groupes UNIX** (`groupadd`)
- Crée un utilisateur par groupe :
  - Avec répertoire personnel (`-m`)
  - Affecté au bon groupe (`-G`)
- Crée des répertoires propres à chaque groupe
- Applique les permissions `740` :
  - Utilisateur : lecture, écriture, exécution
  - Groupe : lecture, exécution
  - Autres : aucun droit

🔧 **Utilisations :**
- Organisation des utilisateurs dans un système
- Sécurisation des accès aux répertoires

---

### 🔄 Présence commune à tous les scripts
Tous les scripts vérifient si le fichier texte a un **retour à la ligne final**, indispensable pour une bonne lecture.
```bash
if [ "$(tail -c 1 fichier.txt)" != "" ]; then
  echo >> fichier.txt
fi

