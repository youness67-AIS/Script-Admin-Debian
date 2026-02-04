# 🛠️ Suite d'Outils d'Administration Système - Debian-YNS

Ce dépôt regroupe l'ensemble des scripts Bash développés lors de mon atelier d'automatisation. Ils sont organisés pour couvrir tous les aspects de la gestion d'un serveur Debian.

## 📁 Liste des outils (par ordre de création)

### 1. 💾 Sauvegarde Automatisée (`backup.sh`)
* **Fonction** : Archivage sécurisé de répertoires.
* **Technique** : Création d'archives compressées `.tar.gz` avec horodatage automatique.
* **Objectif** : Garantir la sécurité des données avant toute intervention.

### 2. 📊 Moniteur de Ressources (`monitor.sh`)
* **Fonction** : Tableau de bord de santé du serveur en temps réel.
* **Alertes** : Système de couleurs (Vert/Jaune/Rouge) pour le CPU, la RAM et le Disque.
* **Audit** : Génération de rapports de diagnostic détaillés dans `/var/log/`.

### 3. 👥 Gestionnaire d'utilisateurs (`create-users.sh`)
* **Fonction** : Création massive de comptes via un fichier CSV.
* **Sécurité** : Génération de mots de passe aléatoires et assignation automatique aux groupes.
* **Tracabilité** : Journalisation complète des opérations de création.

### 4. 🧹 Nettoyeur Système (`cleanup.sh`)
* **Fonction** : Optimisation de l'espace disque.
* **Sécurité** : Mode "Dry-Run" (simulation) par défaut pour éviter les suppressions accidentelles.
* **Cibles** : Cache APT, fichiers temporaires et anciens journaux système.

### 5. 🔍 Vérificateur de Services (`check-services.sh`)
* **Fonction** : Surveillance active des services critiques (SSH, Web, Database).
* **Mode --watch** : Monitoring dynamique avec rafraîchissement toutes les 30 secondes.
* **Réparation** : Option de redémarrage automatique en cas de panne détectée.

### 6. 🎛️ Menu Centralisé (`sysadmin-tools.sh`)
* **Fonction** : Interface interactive pilotant l'ensemble de la suite.
* **Gestion** : Vérification de la présence des scripts avant lancement et aide intégrée.
* **Journalisation** : Audit de l'utilisation de l'outil dans `sysadmin_usage.log`.

---

## 📈 Compétences Validées
* **Maîtrise du Shell** : Scripts complexes, variables, boucles et fonctions.
* **Administration Système** : Gestion des utilisateurs, services et maintenance disque.
* **Sécurité & Audit** : Mise en place de logs et de contrôles de sécurité.
* **Documentation** : Rédaction technique et versionnage avec Git.

## 🚀 Utilisation
1. Clonez le dépôt : `git clone https://github.com/youness67-AIS/Script-Admin-Debian.git`
2. Donnez les droits : `chmod +x *.sh`
3. Lancez le menu : `sudo ./sysadmin-tools.sh`

**Auteur : youness67-AIS | Février 2026**
