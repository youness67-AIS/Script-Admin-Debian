#!/bin/bash

# 1. Définition des variables
SOURCE=$1
DATE=$(date +%Y%m%d_%H%M%S)

# Verification si l'argument est vide
if [ -z "$SOURCE" ]; then
    echo "Erreur : Vous devez preciser un dossier a sauvegarder."
    echo "Usage : ./backup.sh /chemin/du/dossier"
    exit 1
fi

# Verification : le dossier existe-t-il vraiment ?
if [ ! -d "$SOURCE" ]; then
    echo "Erreur : Le dossier $SOURCE n'existe pas."
    # On ecrit l'erreur dans le log
    echo "$(date "+%Y-%m-%d %H:%M:%S") : ERREUR - Le dossier $SOURCE n'existe pas" >> /var/log/backup.log
    exit 1
fi

# Si on arrive ici, c'est que tout est bon, on log le debut
echo "$(date "+%Y-%m-%d %H:%M:%S") : DEBUT - Sauvegarde de $SOURCE" >> /var/log/backup.log

# Verification de l'espace libre (methode simple)
LIBRE=$(df / --output=avail -m | tail -1)

if [ "$LIBRE" -lt 100 ]; then
    echo "Erreur : Pas assez de place sur le disque."
    echo "$(date) : ERREUR - Espace insuffisant" >> /var/log/backup.log
    exit 1
fi

DEST="/backup"

# 2. Création du dossier de destination s'il n'existe pas
mkdir -p $DEST

# 3. Création de l'archive
tar -czf $DEST/backup_$DATE.tar.gz $SOURCE

# 4. Message de confirmation
echo "Sauvegarde terminee !"
echo "Archive cree : $DEST/backup_$DATE.tar.gz"
echo "Taille de l'archive :"
du -h $DEST/backup_$DATE.tar.gz

if [ $? -eq 0 ]; then
    echo "$(date) : SUCCES" >> /var/log/backup.log
else
    echo "$(date) : ERREUR" >> /var/log/backup.log
fi

# 5. Rotation des sauvegardes (Garder les 7 dernieres)
echo "Verification de la rotation des sauvegardes..."

# On compte combien on va en supprimer
NB_A_SUPPR=$(ls -1tr $DEST/backup_*.tar.gz | head -n -7 | wc -l)

# On effectue la suppression
ls -1tr $DEST/backup_*.tar.gz | head -n -7 | xargs rm -f

if [ "$NB_A_SUPPR" -gt 0 ]; then
    echo "$NB_A_SUPPR ancienne(s) sauvegarde(s) supprimee(s)."
    echo "$(date) : ROTATION - $NB_A_SUPPR fichiers supprimes" >> /var/log/backup.log
else
    echo "Aucune sauvegarde a supprimer."
fi
