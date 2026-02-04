# 🛠️ Suite d'Outils d'Administration Système - Debian-YNS

Ce dépôt regroupe l'ensemble des scripts Bash développés lors de mon atelier d'automatisation. Ils sont organisés pour couvrir tous les aspects de la gestion d'un serveur Debian.

## 📁 Liste des outils (par ordre de création)

### 1. 💾 Sauvegarde Automatisée (`backup.sh`)
* **Fonction** : Archivage sécurisé de répertoires.
* **Technique** : Création d'archives compressées `.tar.gz` avec horodatage automatique.
* **Objectif** : Garantir la sécurité des données avant toute intervention.
<img width="571" height="256" alt="backup1" src="https://github.com/user-attachments/assets/0516f8c0-ca3b-4796-ac45-b871bc655465" />

<img width="617" height="788" alt="backup2" src="https://github.com/user-attachments/assets/91678eab-a0ea-4c1e-88a9-8e39604e0416" />


### 2. 📊 Moniteur de Ressources (`monitor.sh`)
* **Fonction** : Tableau de bord de santé du serveur en temps réel.
* **Alertes** : Système de couleurs (Vert/Jaune/Rouge) pour le CPU, la RAM et le Disque.
* **Audit** : Génération de rapports de diagnostic détaillés dans `/var/log/`.
<img width="398" height="196" alt="monitoring1" src="https://github.com/user-attachments/assets/05b04aa7-c509-4508-82b3-c4c723fc4f39" />

<img width="404" height="221" alt="monitoring2" src="https://github.com/user-attachments/assets/70188e39-1b6f-4aa9-bb72-ddb80f88f322" />

<img width="570" height="241" alt="monitoring3" src="https://github.com/user-attachments/assets/3ac104c8-73b9-4d1a-ad3b-c690de864a73" />

<img width="663" height="634" alt="monitoring4" src="https://github.com/user-attachments/assets/ace7f1e2-40b1-4126-9e08-cd991f95e3f0" />


### 3. 👥 Gestionnaire d'utilisateurs (`create-users.sh`)
* **Fonction** : Création massive de comptes via un fichier CSV.
* **Sécurité** : Génération de mots de passe aléatoires et assignation automatique aux groupes.
* **Tracabilité** : Journalisation complète des opérations de création.
<img width="465" height="218" alt="users1" src="https://github.com/user-attachments/assets/fa4ccad8-c42b-4f82-b9a5-73bd0a68a9b6" />

<img width="637" height="276" alt="users2" src="https://github.com/user-attachments/assets/035c3b63-3a1d-412d-a971-3db5b3601efa" />

<img width="626" height="694" alt="users3" src="https://github.com/user-attachments/assets/7096900b-d135-4397-b3f6-916a45476cfc" />


### 4. 🧹 Nettoyeur Système (`cleanup.sh`)
* **Fonction** : Optimisation de l'espace disque.
* **Sécurité** : Mode "Dry-Run" (simulation) par défaut pour éviter les suppressions accidentelles.
* **Cibles** : Cache APT, fichiers temporaires et anciens journaux système.
<img width="413" height="213" alt="cleanup1" src="https://github.com/user-attachments/assets/a30d6f04-7df4-458b-9442-ceaeb1339dea" />

<img width="600" height="198" alt="cleanup2" src="https://github.com/user-attachments/assets/c2fc0fb4-1aad-4893-be75-65e72aabb0ee" />

<img width="510" height="241" alt="cleanup3" src="https://github.com/user-attachments/assets/62293b58-04b2-4ed7-a835-6d106ea0acd4" />


### 5. 🔍 Vérificateur de Services (`check-services.sh`)
* **Fonction** : Surveillance active des services critiques (SSH, Web, Database).
* **Mode --watch** : Monitoring dynamique avec rafraîchissement toutes les 30 secondes.
* **Réparation** : Option de redémarrage automatique en cas de panne détectée.
<img width="459" height="194" alt="check-services1" src="https://github.com/user-attachments/assets/4ef527a9-1316-40b8-bd2b-1e1227e2e3db" />

<img width="659" height="739" alt="check-services2" src="https://github.com/user-attachments/assets/3c4049db-2d3c-40a9-b396-51dfa9b68bbc" />

<img width="583" height="235" alt="check-services3" src="https://github.com/user-attachments/assets/cf703eea-d92d-4a94-bed0-5416914fd831" />


### 6. 🎛️ Menu Centralisé (`sysadmin-tools.sh`)
* **Fonction** : Interface interactive pilotant l'ensemble de la suite.
* **Gestion** : Vérification de la présence des scripts avant lancement et aide intégrée.
* **Journalisation** : Audit de l'utilisation de l'outil dans `sysadmin_usage.log`.
<img width="507" height="365" alt="sysadmin-tools1" src="https://github.com/user-attachments/assets/93b25cb1-6dd3-4075-9e1a-81f8c37b52ad" />

<img width="514" height="256" alt="sysadmin-tools2" src="https://github.com/user-attachments/assets/b13d6f56-4e55-4d10-b996-7dd33f57c2bb" />


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
