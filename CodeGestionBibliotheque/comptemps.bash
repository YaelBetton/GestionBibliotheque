#!/bin/bash


# Vérifie s'il y a que 4 arguments
if [ "$#" -ne 4 ];
then
    echo "Usage: $0 jour mois année heure:min:sec"
    exit 10
fi

# Arguments
jour=$1
mois=$2
annee=$3
heure=$4

# Conversion de la date en timestamp
date_arg=$(date -d "$annee-$mois-$jour $heure" +%s 2>/dev/null)
# +%s Convertie en timestamp UNIX
date_act=$(date +%s)

# Vérification si la date en argument est valide
if [ -z "$date_arg" ];
then
    echo "Date invalide"
    exit 4
fi

# Comparaison des dates
if [ "$date_arg" -ge "$date_act" ];
then
    echo "La date est postérieur ou égale à la date actuelle"
    exit 0
else
    # Calcul de la différence en secondes
    diff=$((date_act - date_arg))
    jours=$((diff / 86400)) # Conversion en jours

    if [ "$jours" -gt 365 ];
    then
        # La date est antérieure de plus d'un an
        exit 1
    elif [ "$jours" -gt 30 ];
    then
        # La date est antérieure de plus d'un mois et de moins d'un an
        exit 2
    else
        # La date est antérieure de moins d'un mois
        exit 3
    fi
fi
