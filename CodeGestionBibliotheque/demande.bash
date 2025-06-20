#!/bin/bash


# Arguments
file_livre="livres.txt"
file_membre="membre.txt"
file_exemplaires="exemplaires.txt"
file_emprunts="emprunts.txt"


#Vérifie qu'il y a 2 arguments
if [ $# -ne 2 ];
then
    echo "Erreur : Vous devez fournir exactement deux arguments."
    exit 1
fi 


# Vérifier si les fichiers existent
for file in "$file_livre" "$file_membre" "$file_exemplaires" "$file_emprunts"; do
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
    # Découper la ligne avec cut titre puis recupere l'id
    titre=$(echo "$ligne" | cut -d';' -f2)
    id=$(echo "$ligne" | cut -d';' -f1)

    # Test si l'auteur et le livre est dans le fichier, l'ordre importe peu
    # On vérifie dans les deux sens
    if [[ "$titre" == "$1" ]] || [[ "$titre" == "$2" ]];
    then
      num_livre=$id
      livre_trouve=1
      break
    fi

done <$file_livre


# Si aucun livre est trouvé alors livre n'est pas dans la bibliothèque
if [[ $livre_trouve -eq 0 ]];
then
    echo "Le livre n'est pas dans la bibliotheque"
    exit 3
fi


while read ligne
do

    # Verifie si l'argument pour le nom est dans le fichier membre
    nom_personne=$(echo "$ligne" | cut -d';' -f2)

    if [[ "$nom_personne" == "$1" ]] || [[ "$nom_personne" == "$2" ]];
    then
        num_membre=$(echo "$ligne" | cut -d';' -f1)
        membre_trouve=1
        break
    fi
    
done <$file_membre


compteur=0
while read ligne
do
    idmenbre_emprunts=$(echo "$ligne" | cut -d ";" -f1)
    idlivre_emprunts=$(echo "$ligne" | cut -d ";" -f2)

    # Vérifie que la même personne n'est pas emprunté deux fois le même livre
    if [[ "$idmenbre_emprunts" == "$num_membre" ]] && [[ "$num_livre" == "$idlivre_emprunts" ]];
    then
        compteur=$((compteur + 1))
    fi

done <$file_emprunts


# Verifie si le livre a était emprunter plus de 1 fois par la même personne
if [ $compteur -gt 0 ];
then
    echo "Le livre a déjà était emprunté par $1 1 fois. Il ne peut pas emprunté 2 fois le même livre"
    exit 4
fi

if [[ $membre_trouve -eq 0 ]];
then
    echo "Le nom est incorrect"
    exit 5
fi


while read ligne
do

    # Stocke l'id de l'exemplaire et s'il est disponible (oui ou non)
    id_livre_exemplaire=$(echo "$ligne" | cut -d';' -f1)
    disponible=$(echo "$ligne" | cut -d';' -f3)
    num_exemplaire=$(echo "$ligne" | cut -d';' -f2)

    # Vérifie si le numéro d'exemplaire est le bon et si il est bon alors il regarde s'il est disponible
    if [[ "$num_livre" == "$id_livre_exemplaire" ]] && [[ "$disponible" == "oui" ]];
    then
        echo "Le livre a été emprunté avec succès"

        date_formate=$(date | tr -s ' ' ':')
        heure=$(echo $date_formate | cut -d':' -f4-6)
        jour=$(echo $date_formate | cut -d':' -f3)
        mois=$(date +"%m")
        annee=$(echo $date_formate | cut -d':' -f7)

        echo "$num_membre;$num_livre;$num_exemplaire;$jour $mois $annee $heure" >> emprunts.txt
        # Change le oui par non dans le fichier exemplaires.txt
        sed -i "/^$num_livre;$num_exemplaire;/s/oui/non/" exemplaires.txt
        exit 0
    fi

done <$file_exemplaires


echo "Le livre n'est pas disponible (il est déjà emprunté)"
exit 0