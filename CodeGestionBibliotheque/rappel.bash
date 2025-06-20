#!/bin/bash

file_emprunts="emprunts.txt"
file_livre="livres.txt"
file_membre="membre.txt"

#Teste le nombre d'arguments si y'en a 2
if [ $# -ne 0 ]
then
    echo "Erreur. Syntaxe $0"
    exit 1
fi 


# Test si le fichier existe
for file in "$file_livre" "$file_emprunts" "$file_membre"; do
    if [[ ! -f "$file" ]];
    then
        echo "Erreur : Le fichier $file n'existe pas."
        exit 2
    fi

    # Vérifie si le fichier se termine par un retour à la ligne sinon ça crée une erreur
    if [ "$(tail -c 1 "$file")" != "" ];
    then
        # Ajoute un retour à la ligne à la fin du fichier
        echo >> "$file"
    fi
done

while read ligne
do
    # Vérifie si le livre doit être rendu
    date_emprunt=$(echo "$ligne" | cut -d';' -f4)
    id_membre=$(echo "$ligne" | cut -d ';' -f1)
    id_livre=$(echo "$ligne" | cut -d ';' -f2)
    ./comptemps.bash $date_emprunt  
    retour_exit=$?

    # En fonction du retour de comptemps, le message va varier
    if [ $retour_exit -eq 1 ] || [ $retour_exit -eq 2 ]; then

        while read ligne_fic_livre
        do 
            id_livres=$(echo "$ligne_fic_livre" | cut -d ';' -f1)
            nom_livre=$(echo "$ligne_fic_livre" | cut -d ';' -f2)

            # Comparaison des IDs du livre emprunté et des livres dans le fichier
            if [ $id_livre -eq $id_livres ];
            then
                break
            fi

        done <$file_livre

        while read ligne_fic_membre
        do
            id_membres=$(echo "$ligne_fic_membre" | cut -d ';' -f1)
            nom_membre=$(echo "$ligne_fic_membre" | cut -d ';' -f2)

            if [ $id_membre -eq $id_membres ];
            then
                break
            fi

        done <$file_membre

        echo "Cela fait plus d'un mois que le livre $nom_livre est emprunté par $nom_membre"
    fi
done <$file_emprunts