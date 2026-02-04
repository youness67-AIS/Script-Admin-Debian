#!/bin/bash

# 1. CONFIGURATION ET VARIABLES
LOG_FILE="/var/log/user-creation.log"
RECAP_FILE="users_created.txt"
MODE_DELETE=false

# 2. GESTION DES OPTIONS (Le flag -d)
while getopts "d" opt; do
  case $opt in
    d) MODE_DELETE=true ;;
    *) echo "Usage: $0 [-d] <fichier.csv>"; exit 1 ;;
  esac
done
shift $((OPTIND -1))

FICHIER=$1

# 3. VÉRIFICATION DES ARGUMENTS ET PERMISSIONS
if [ -z "$FICHIER" ]; then
    echo "Usage : $0 [-d] <fichier.csv>"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "Erreur : Ce script doit être lancé en root."
    exit 1
fi

# 4. MODE SUPPRESSION
if [ "$MODE_DELETE" = true ]; then
    echo "--- MODE SUPPRESSION ACTIVE ---"
    tail -n +2 "$FICHIER" | while IFS=',' read -r prenom nom departement fonction
    do
        PRENOM_MIN=$(echo "$prenom" | tr '[:upper:]' '[:lower:]')
        NOM_MIN=$(echo "$nom" | tr '[:upper:]' '[:lower:]')
        LOGIN="${PRENOM_MIN:0:1}${NOM_MIN}"

        if id "$LOGIN" &>/dev/null; then
            # On force la lecture sur le terminal pour la confirmation
            read -p "Voulez-vous vraiment supprimer $LOGIN ($prenom $nom) ? (y/n) : " confirm < /dev/tty
            if [ "$confirm" = "y" ]; then
                userdel -r "$LOGIN"
                echo "$(date '+%Y-%m-%d %H:%M:%S') - SUPPRESSION : $LOGIN" >> "$LOG_FILE"
                echo "Utilisateur $LOGIN supprimé."
            else
                echo "Suppression annulée pour $LOGIN."
            fi
        fi
    done
    echo "--- FIN DE LA SUPPRESSION ---"
    exit 0
fi

# 5. MODE CRÉATION (Si pas d'option -d)
echo "--- DÉBUT DE LA CRÉATION DES COMPTES ---"
echo "--- RECAPITULATIF DES COMPTES ---" > "$RECAP_FILE"

tail -n +2 "$FICHIER" | while IFS=',' read -r prenom nom departement fonction
do
    PRENOM_MIN=$(echo "$prenom" | tr '[:upper:]' '[:lower:]')
    NOM_MIN=$(echo "$nom" | tr '[:upper:]' '[:lower:]')
    LOGIN="${PRENOM_MIN:0:1}${NOM_MIN}"

    if id "$LOGIN" &>/dev/null; then
        echo "L'utilisateur $LOGIN existe déjà."
        continue
    fi

    if ! getent group "$departement" >/dev/null; then
        groupadd "$departement"
    fi

    PASSWORD=$(openssl rand -base64 12)
    
    if useradd -m -g "$departement" -c "$prenom $nom" "$LOGIN"; then
        echo "$LOGIN:$PASSWORD" | chpasswd
        echo "LOGIN: $LOGIN | PASS: $PASSWORD" >> "$RECAP_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - CRÉATION : $LOGIN" >> "$LOG_FILE"
        echo "Utilisateur $LOGIN créé."
    fi
done
echo "--- OPÉRATION TERMINÉE ---"
