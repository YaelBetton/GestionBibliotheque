#!/bin/bash


#Teste le nombre d'arguments si y'en a 4
if test $# -ne 4 
then
    echo "Erreur. Syntaxe $0 commande argument argument argument"
    exit 1
fi 


# Test si les fichiers existent
for file in "exemplaires.txt" "livres.txt" "membre.txt";
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


# Ajout d'un nouveau membre au fichier membres.txt
if [ "$1" = "-a" ]
then

    nom=$2
    prenom=$3
    ville=$4

    # Vérifie que les arguments ne sont pas déjà dans le fichier membres
    if grep -q "$nom;$prenom;$ville" "membre.txt"
    then
        echo "Les valeurs renseignées sont déjà présentes dans le fichier membre.txt"
        exit 6
    fi
    
    echo "Vous avez choisi d'ajouter cette personne: $2, $3" 
    echo "Avec les informations suivantes: "$4""

    # Ajout du nouveau membre
    numMembres=$(tail -n 1 membre.txt | cut -d ";" -f 1)
    numMembres=$((numMembres+1))
    ligne="$numMembres;$2;$3;$4"

    echo $ligne >> membre.txt
    echo "Voici le contenu des 5 dernières lignes du fichier membre :"
    tail -5 membre.txt

# Ajout d'un nouveau livre au fichier livres.txt
elif [ $1 = "-l" ]
then   

    nbExemplaire=$2
    titre=$3
    auteur=$4

    echo "Vous avez choisi d'inscrire un livre"
    echo "Avez les informations suivants : $nbExemplaire , $titre , $auteur"

    if [ $nbExemplaire -ge 0 ]
    then
        if [ $nbExemplaire -ne 0 ]
        then
            #Ecris dans le fichier livres.txt le livre que l'on souhaite ajouter
            numLivre=$(tail -n 1 livres.txt | cut -d ";" -f 1)
            numLivre=$((numLivre+1))

            echo "$numLivre;$titre;$auteur" >> livres.txt
            echo " "
            echo "Voici le contenu des 5 dernières lignes du fichier livres : "
            tail -5 livres.txt

            #On écrit ici le nombre d'exemplaire dans le fichier exemplaires.txt
                for var in $(seq 1 "$nbExemplaire")
                do  
                    echo "$numLivre;$var;oui" >> exemplaires.txt
                done

                echo " "
                echo "Voici le contenu des exemplaires : "
                cat exemplaires.txt

        # Argument égal à 0
        else
            echo "Impossible d'ajouter le livre puisqu'il n'y a pas d'exemplaires : $nbExemplaire"
            exit 5
        fi

    # Argument égal à un entier négatif
    else
        echo "Erreur. Syntaxe $nbExemplaire n'est pas un entier positif"
        exit 4
    fi 


# Si le premier argument ne correspond pas à -l ou à -a
else
    echo "Vous n'avez pas fait le bon choix d'option !"
    exit 3
fi