#!/bin/bash

echo "--- MONITORING SYSTEME ---"
# Nom du serveur
echo "Serveur : $(hostname)"

# Date et heure
echo "Date : $(date '+%d/%m/%Y %H:%M:%S')"

# Uptime (depuis combien de temps le serveur tourne)
echo "Uptime : $(uptime -p)"

# Nombre de processus
NB_PROC=$(ps aux | wc -l)
echo "Processus en cours : $NB_PROC"

# Variables de couleurs
VERT='\e[32m'
JAUNE='\e[33m'
ROUGE='\e[31m'
RESET='\e[0m'

# Definition du fichier de rapport
LOG_FILE="/var/log/monitor_$(date +%Y%m%d).txt"

# Calcul Memoire (déjà fait)
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_USED=$(free -m | awk '/^Mem:/{print $3}')
MEM_PERC=$(( 100 * MEM_USED / MEM_TOTAL ))

# Système d'alerte colorée
if [ $MEM_PERC -lt 70 ]; then
    COULEUR=$VERT
elif [ $MEM_PERC -lt 85 ]; then
    COULEUR=$JAUNE
else
    COULEUR=$ROUGE
fi

echo -e "Memoire : ${COULEUR}${MEM_USED}Mo / ${MEM_TOTAL}Mo ($MEM_PERC%)${RESET}"


# Nouvelle methode pour le CPU
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)

# Si la variable est vide, on met 0 par defaut
if [ -z "$CPU_LOAD" ]; then CPU_LOAD=0; fi

if [ "$CPU_LOAD" -lt 70 ]; then
    COL_CPU=$VERT
elif [ "$CPU_LOAD" -lt 85 ]; then
    COL_CPU=$JAUNE
else
    COL_CPU=$ROUGE
fi

echo -e "Utilisation CPU : ${COL_CPU}${CPU_LOAD}%${RESET}"

# Logique de couleur pour le Disque
DISK_PERC=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_PERC" -lt 70 ]; then
    COL_DISK=$VERT
elif [ "$DISK_PERC" -lt 85 ]; then
    COL_DISK=$JAUNE
else
    COL_DISK=$ROUGE
fi

echo -e "Espace Disque (/) : ${COL_DISK}${DISK_PERC}%${RESET}"


# Generation du rapport texte (sans couleurs)
{
    echo "--- RAPPORT DE MONITORING ---"
    echo "Serveur : $(hostname)"
    echo "Date    : $(date '+%d/%m/%Y %H:%M:%S')"
    echo "Uptime  : $(uptime -p)"
    echo "Proc.   : $NB_PROC"
    echo "Memoire : ${MEM_USED}Mo / ${MEM_TOTAL}Mo ($MEM_PERC%)"
    echo "CPU     : ${CPU_LOAD}%"
    echo "Disque  : ${DISK_PERC}%"
    echo "----------------------------"

    echo -e "\nTOP 5 CPU :"
    ps -eo pid,cmd,%cpu --sort=-%cpu | head -n 6

    echo -e "\nTOP 5 MEM :"
    ps -eo pid,cmd,%mem --sort=-%mem | head -n 6
    echo "----------------------------"
} >> "$LOG_FILE"

echo -e "\n${VERT}Rapport genere dans : $LOG_FILE${RESET}"
