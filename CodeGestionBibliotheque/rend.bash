#!/bin/bash

adherent=$1
titre_livre=$2
file_emprunts="emprunts.txt"
file_exemplaires="exemplaires.txt"


#Teste le nombre d'arguments si y'en a 2
if [ $# -ne 2 ]
then
    echo "Erreur. Syntaxe $0 argument argument (nom_adhérent et titre du livre)"
    exit 1
fi 

#test si les fichiers existent
for file in "exemplaires.txt" "livres.txt" "membre.txt" "emprunts.txt";
do
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


# Vérifier si l'adhérent existe dans membre.txt
if grep -q ";$adherent;" membre.txt;
then
    echo "L'adhérent $adherent existe dans membre.txt."
else
    echo "L'adhérent $adherent n'existe pas dans membre.txt."
    exit 3
fi


# Vérifier si le titre du livre existe dans livres.txt
if grep -q ";$titre_livre;" livres.txt;
then
    echo "Le titre $titre_livre existe dans livres.txt."
else
    echo "Le titre $titre_livre n'existe pas dans livres.txt."
    exit 3
fi


id_membre=$(grep -i "^.*;$adherent;" membre.txt | cut -d ';' -f 1)

# Vérifier si l'ID a été trouvé
if [ -z "$id_membre" ];
then
    echo "L'adhérent $adherent n'a pas été trouvé dans le fichier."
    exit 4
else
    echo "L'ID de l'adhérent $adherent est : $id_membre"
fi


# Verifie que l'id est un chiffre ou un nombre
id_livre=$(grep -i "^[0-9]*;$titre_livre;" livres.txt | cut -d ';' -f 1)


# Vérification si l'ID a été trouvé
if [ -z "$id_livre" ];
then
    echo "Aucun livre trouvé pour le titre : $titre_livre"
    exit 4
else
    echo "L'ID du livre est : $id_livre"
fi

validite_emprunt=0

while read ligne
do

  membre=$(echo $ligne | cut -d ";" -f1)
  livre=$(echo $ligne | cut -d ";" -f2)

  # Vérifie si le livre est emprunté
  if [[ "$livre" == "$id_livre" && "$membre" == "$id_membre" ]]
  then
    # Supprimme la ligne avec le bonne id livre/membre
    validite_emprunt=1
    exemplaire=$(echo $ligne | cut -d ";" -f3)
    sed -i "/^$id_membre;$id_livre;/d" emprunts.txt
    echo "La ligne dans emprunts a était supprimé"
  fi

done <$file_emprunts 


if [ "$validite_emprunt" -ne 1 ]; 
then
  echo "Le livre n'est pas emprunté"
  exit 5
fi


while read ligne
do
  # Prend le numéro du livre le numéro de l"exmpaires et si c'est dispo ou pas (oui/non)
  livre=$(echo $ligne | cut -d ";" -f1)
  dispo=$(echo $ligne | cut -d ";" -f2)
  statut=$(echo $ligne | cut -d ";" -f3)

  # Vérifie si les Id sont bons
  if [[ "$id_livre" == "$livre" && "$exemplaire" == "$dispo" ]]
  then
    # Change la valeur "non" par "oui"
    sed -i "s/^$livre;$dispo;non$/$livre;$dispo;oui/" $file_exemplaires
    echo "La disponibilité pour l'exemplaire $dispo du livre ID : $livre a été mise à jour en 'oui'."
    exit 0
  fi

done <$file_exemplaires


echo "Le livre n'a pas était trouvé ou il est déjà disponible"
exit 6