#!/bin/bash

# --- CONFIGURATION ---
VERSION="1.0.0"
AUTEUR="root@Debian-YNS"
LOG_FILE="/var/log/sysadmin_usage.log"
SCRIPTS=("create-users.sh" "cleanup.sh" "check-services.sh")

# Couleurs
BLEU='\033[0;34m'
VERT='\033[0;32m'
ROUGE='\033[0;31m'
NC='\033[0m'

# 1. VÉRIFICATION DES DÉPENDANCES
check_requirements() {
    for s in "${SCRIPTS[@]}"; do
        if [ ! -x "./$s" ]; then
            echo -e "${ROUGE}[ERREUR]${NC} Le script '$s' est manquant ou non exécutable."
            exit 1
        fi
    done
}

# 2. FONCTION DE LOGGING
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Utilisateur: $(whoami) - Action: $1" >> "$LOG_FILE" 2>/dev/null
}

# 3. SYSTÈME D'AIDE
afficher_aide() {
    clear
    echo -e "${BLEU}=== DOCUMENTATION DES OUTILS ===${NC}"
    echo -e "${VERT}1. Sauvegarde :${NC} Archive un dossier au format .tar.gz."
    echo -e "${VERT}2. Monitoring :${NC} Affiche la charge CPU et l'état du disque."
    echo -e "${VERT}3. Utilisateurs :${NC} Crée des comptes en masse via un CSV (Nom,Groupe)."
    echo -e "${VERT}4. Nettoyage :${NC} Supprime les logs >30j et les fichiers /tmp >7j."
    echo -e "${VERT}5. Services :${NC} Vérifie si les services critiques tournent."
    echo -e "\nAppuyez sur une touche pour revenir..."
    read -n 1
}

# --- DÉMARRAGE ---
check_requirements

while true; do
    clear
    echo -e "${BLEU}=======================================${NC}"
    echo -e "  SYSADMIN TOOLS v$VERSION | Par: $AUTEUR"
    echo -e "${BLEU}=======================================${NC}"
    echo "1. Sauvegarde de répertoire"
    echo "2. Monitoring système"
    echo "3. Créer des utilisateurs"
    echo "4. Nettoyage système"
    echo "5. Vérifier les services"
    echo "6. Aide (Documentation)"
    echo "7. Quitter"
    echo -e "${BLEU}=======================================${NC}"
    echo -n "Votre choix : "
    read choix

    case $choix in
        1) log_action "Sauvegarde"; read -p "Dossier : " d; [ -d "$d" ] && tar -czf "backup_$(date +%F).tar.gz" "$d" ;;
        2) log_action "Monitoring"; uptime; df -h / ;;
        3) log_action "Create-Users"; read -p "Fichier CSV : " f; ./create-users.sh "$f" ;;
        4) log_action "Cleanup"; ./cleanup.sh ;;
        5) log_action "Check-Services"; ./check-services.sh ;;
        6) afficher_aide ;;
        7) log_action "Sortie"; echo "Fermeture..."; exit 0 ;;
        *) echo -e "${ROUGE}Invalide.${NC}" ;;
    esac

    echo -e "\n${BLEU}[Appuyez sur Entrée]${NC}"
    read
done
