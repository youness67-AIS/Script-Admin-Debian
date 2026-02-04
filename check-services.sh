#!/bin/bash

# 1. CONFIGURATION
CONF_FILE="services.conf"
JSON_FILE="services_report.json"
RESTART=false
WATCH=false

# Couleurs
VERT='\033[0;32m'
ROUGE='\033[0;31m'
JAUNE='\033[1;33m'
NC='\033[0m'

# Gestion des options
for arg in "$@"; do
    case $arg in
        -r|--restart) RESTART=true ;;
        --watch) WATCH=true ;;
    esac
done

# Fonction principale de vérification
verifier_services() {
    ACTIFS=0
    INACTIFS=0
    
    echo "--- VÉRIFICATION DES SERVICES --- $(date '+%H:%M:%S')"
    echo "------------------------------------------------"

    # Initialisation JSON (simplifiée pour le mode watch)
    echo "{ \"date\": \"$(date)\", \"services\": [" > "$JSON_FILE"

    while read -r service || [ -n "$service" ]; do
        [[ -z "$service" || "$service" =~ ^# ]] && continue

        STATUS="inactif"
        COLOR=$ROUGE
        
        if systemctl is-active --quiet "$service"; then
            STATUS="actif"
            COLOR=$VERT
            ((ACTIFS++))
        else
            ((INACTIFS++))
            if [ "$RESTART" = true ]; then
                systemctl start "$service" 2>/dev/null
                systemctl is-active --quiet "$service" && STATUS="reparé" && COLOR=$VERT
            fi
        fi

        echo -e "Service $service : ${COLOR}[$STATUS]${NC}"
        echo "    { \"nom\": \"$service\", \"status\": \"$STATUS\" }," >> "$JSON_FILE"
    done < "$CONF_FILE"

    echo -e "------------------------------------------------"
    echo -e "BILAN : ${VERT}$ACTIFS actifs${NC} / ${ROUGE}$INACTIFS inactifs${NC}"
    [ "$WATCH" = true ] && echo -e "\n(Mode monitoring actif - Appuyez sur Ctrl+C pour quitter)"
}

# 2. LOGIQUE D'EXÉCUTION
if [ "$WATCH" = true ]; then
    # Mode Monitoring en boucle
    trap "echo -e '\nArrêt du monitoring...'; exit" SIGINT
    while true; do
        clear
        verifier_services
        sleep 30
    done
else
    # Exécution simple
    verifier_services
fi
