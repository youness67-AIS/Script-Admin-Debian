#!/bin/bash

# 1. CONFIGURATION PAR DÉFAUT
DAYS_TMP=7
DAYS_LOGS=30
FORCE=false
LOG_FILE="/var/log/cleanup.log"
AVANT=$(df / | awk 'NR==2 {print $4}')

# 2. GESTION DES ARGUMENTS
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--force) FORCE=true ;;
        -j|--jours) DAYS_TMP=$2; DAYS_LOGS=$2; shift ;;
        *) echo "Option inconnue : $1"; exit 1 ;;
    esac
    shift
done

echo "--- NETTOYEUR SYSTÈME PRO ---"
[ "$FORCE" = false ] && echo "--- MODE PREVIEW (Âge : $DAYS_TMP jours) ---"

# 3. FONCTION DE NETTOYAGE AVEC STATISTIQUES
effectuer_nettoyage() {
    local dossier=$1
    local motif=$2
    local jours=$3
    
    # Compter les fichiers avant
    local nb_fichiers=$(find "$dossier" -name "$motif" -type f -mtime +"$jours" | wc -l)
    
    if [ "$FORCE" = true ]; then
        find "$dossier" -name "$motif" -type f -mtime +"$jours" -delete
        echo "$nb_fichiers fichiers supprimés dans $dossier"
    else
        echo "$nb_fichiers fichiers à supprimer dans $dossier"
    fi
    return $nb_fichiers
}

# 4. EXÉCUTION
{
    echo "--- Rapport du $(date) ---"
    
    # Nettoyage /tmp
    echo -n "TMP : "
    effectuer_nettoyage "/tmp" "*" "$DAYS_TMP"
    
    # Nettoyage Logs
    echo -n "LOGS : "
    effectuer_nettoyage "/var/log" "*.gz" "$DAYS_LOGS"
    
    # Cache APT
    echo -n "APT : "
    if [ "$FORCE" = true ]; then
        apt-get clean && echo "Cache vidé"
    else
        du -sh /var/cache/apt/archives | awk '{print $1 " à libérer"}'
    fi
} | tee -a "$LOG_FILE"

# 5. BILAN FINAL
if [ "$FORCE" = true ]; then
    APRES=$(df / | awk 'NR==2 {print $4}')
    GAIN=$((APRES - AVANT))
    echo "ESPACE RÉCUPÉRÉ : $((GAIN / 1024)) Mo" | tee -a "$LOG_FILE"
fi
