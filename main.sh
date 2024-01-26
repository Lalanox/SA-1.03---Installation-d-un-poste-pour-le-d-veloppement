#!/bin/sh
option=0  # Initialiser la variable option

chmod 700 "ListeNom.txt"
chmod 700 "logs.txt"

#Réalise toute les vérifications pour les fichiers
function checkFile()
{
    #Verification du nombre de parametres de la fonction
    if [ $1 -eq $2 ]; then
      #Verifie si le fichier existe
      if [ -f $3 ]; then
          if [ -r "$3" ]; then
            echo "Vous n'avez pas le droit de lecture sur le fichier"
            return 1
          fi
          if [ -x "$3" ]; then
            echo "Vous n'avez pas le droit d'execution sur le fichier"
            return 2
          fi
          return 0
      else 
          echo "Le fichier n'existe pas"
          return 3
      fi
    else
        echo "Le nombre de paramètres n'est pas valide" 
        return 4
    fi
}

#Afficher la liste des personnes
# Param 1 : fichier
function AfficherListe() {
  if checkFile $# 1; then
      cat "$1"
  fi
  return 0
}

#Affiche le nombre de personnes présente dans la liste
#Param 1 : fichier
function AfficherNbPersonne() {
  if checkFile $# 1; then
  #awk 'NF > 0' "$1"
    cat "$1" | wc -l
  fi
  return 0
}

#Saisir un chiffre entre 1 et le nombre de ligne dans le fichier donné
#Param 1 : fichier
function SaisieChiffre (){
  if checkFile $# 1; then
    NbPersonne=$(AfficherNbPersonne "$1") 
    echo "Mettre un chiffre entre 1 et "$NbPersonne" correspondant au nombre total de ligne du fichier"
    read SaisieChiffre
    if [ "$SaisieChiffre" -lt 1 ] || [ "$SaisieChiffre" -gt "$NbPersonne" ]
    then
      echo "La valeur n'est pas compris entre 1 et "$NbPersonne""
      return 1
    else
      return "$SaisieChiffre"
    fi
  fi
  return 0
}

#Affiche la personne correspondante au numeros de la ligne recherché
#Param 1 : fichier
function ChiffrePersonne() {
  if checkFile $# 1; then
    SaisieChiffre "$1"
    echo "Voici la "$SaisieChiffre" personne de la liste :"
    head -n "$SaisieChiffre" "$1" | tail -n + $SaisieChiffre
  fi
  return 0
}

#Ajout d'un nom donné dans les logs
# Param 1 : nom recherché
function AddToLogs() 
{
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "logs.txt"
    return 0
}

#Chercher dans la liste si le nom d'une personne est présent
# Param 1 : fichier  / Param 2 : nom
function SearchInList ()
{
    if checkFile $# 2; then
        if grep -q "$2" "$1"; then
            echo "Le nom  $2 est bien dans la liste"
            AddToLogs "$2"
        else
            echo "Le nom  $2 n'est pas dans la liste"
        fi
    fi
    return 0
}

#Afficher le fichier des logs
# Param 1 : nom du fichier 
function ShowLogsFile ()
{
    if checkFile $# 1; then
        cat "$1"
    fi
    return 0
}

#Affiche le numero de la première ligne
# Param 1: fichier / Param 2: nombre de ligne
function ShowNumberFirstLine ()
{
    if checkFile $# 2; then
        head -n "$2" "$1"
    fi
    return 0
}

#Affiche le numero de la dernière ligne
# Param 1: fichier / Param 2: nombre de ligne
function ShowNumberLastLine ()
{
    if checkFile $# 2; then
        tail -n "$2" "$1"
    fi
    return 0
}

#Copie et nomme un fichier donné 
#Param 1: nom de la copie du fichier / Param 2 : fichier
function CopyFile()
{
    if checkFile $# 2; then
        cp "$2" "$1"
    fi
    return 0
}

#Affiche la liste de nom trié par ordre alphabétique
#Param 1 : fichier
function SortList()
{
    if checkFile $# 1; then
        sort "$1"
    fi
    return 0
}

#Ajoute un nom dans la liste de nom du fichier référencé
#Param 1 : Nom à ajouter / Param 2 : fichier
function AddNameToFile()
{
    if checkFile $# 2; then
        echo "$1" >> "$2"
    fi
    return 0
}

#Cherche dans les logs pour un nom donnée, la date référencé
#Param 1 : nom à chercher / Param 2 : fichier
function SearchInLogsName()
{
  if checkFile $# 2; then
      echo "----------- Logs -----------" 
      if grep -E "^.* - $1" "$2"; then
          echo "----------------------------" 
      else
          echo "Le nom $1 n'est pas dans la liste"
      fi
  fi
  return 0
}

#Cherche dans les logs pour une date donnée, les noms référencés
#Param 1 : Date à chercher / Param 2 : fichier
function SearchInLogsDate()
{
  if checkFile $# 2; then
      echo "----------- Logs -----------" 
      if grep -E ""$1".* - " "$2"; then
          echo "----------------------------" 
      else
          echo "Aucun nom référencé sur cette date : $1 existe dans les logs"
      fi
  fi
  return 0
}

#Compte de fois qu'un nom donné apparaît dans le fichier de log
#Param 1 : nom à chercher / Param 2 : fichier
function CountLogs(){
  if checkFile $# 2; then
      var=$(grep " - "$1"" "$2" | wc -l)
      echo "Le nom est apparu $var fois dans les logs"
      #grep " - "$1"" "$2" | wc -l
  fi
  return 0
}

while [ "$option" -ne 17 ]; do
  echo "---------------------------------------------------------"
  echo "                      Menu des choix"
  echo "---------------------------------------------------------"
  echo ""
  echo "1) Afficher la liste des personnes"
  echo "2) Afficher le nombre de personnes de la liste"
  echo "3) Afficher la premiere personne de la liste"
  echo "4) Afficher la derniere personne de la liste"
  echo "5) Afficher la personne d'un numero de ligne donne"
  echo "6) Ajouter un nom dans la liste"
  echo "7) Chercher dans la liste si le nom d'une personne est present"
  echo "8) Retrouver dans les logs pour une date donne, le nom de la personne choisie"
  echo "9) Retrouver dans les logs pour un nom donne, la liste des dates"
  echo "10) Afficher le fichier des logs"
  echo "11) Creer une copie du fichier contenant la liste des noms"
  echo "12) Creer une copie du fichier contenant les logs"
  echo "13) Afficher les X premieres lignes du fichier des logs"
  echo "14) Afficher les X dernieres lignes du fichier des logs"
  echo "15) Afficher la liste de nom trie"
  echo "16) Compter le nombre de fois ou une personne a ete choisie dans les logs"
  echo "17) Quitter"
  echo ""
  echo "---------------------------------------------------------"
  echo "                Veuillez saisir une option :"
  read option
  echo ""

  case $option in
    1)
      echo "Voici la liste des noms :"
      AfficherListe "ListeNom.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    2)
      echo "Voici le nombre de personnes dans la liste :"
      AfficherNbPersonne "ListeNom.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    3)
      echo "Voici la première personne de la liste :"
      ShowNumberFirstLine "ListeNom.txt" 1
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    4)
      echo "Voici la dernière personne de la liste :"
      ShowNumberLastLine "ListeNom.txt" 1
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    5)
      ChiffrePersonne "ListeNom.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    6)
      echo "Veuillez saisir un nom à ajouter dans la liste : "
      read Nom
      AddNameToFile "$Nom" "ListeNom.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    7)

      echo "Veuillez saisir un nom à vérifier : "
      read Nom2
      SearchInList "ListeNom.txt" "$Nom2"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    8)
      echo "Veuillez saisir une date dans le format YYYY-MM-DD : "
      read Date
      SearchInLogsDate "$Date" "logs.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    9)
      echo "Veuillez saisir un nom à chercher dans les logs : "
      read Nom3
      SearchInLogsName "$Nom3" "logs.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    10)
      echo "Voici le contenu du fichier de logs :"
      ShowLogsFile "logs.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    11)
      echo "Veuillez saisir le nom de la copie de la liste de noms (chemin optionnel)"
      read File
      CopyFile "$File" "ListeNom.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    12)
      echo "Veuillez saisir le nom de la copie des logs (chemin optionnel)"
      read File
      CopyFile "$File" "logs.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    13)
      SaisieChiffre "logs.txt"
      echo "Voici les "$SaisieChiffre" premières lignes du fichier de logs :"
      ShowNumberFirstLine "logs.txt" "$SaisieChiffre"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    14)
      SaisieChiffre "logs.txt"
      echo "Voici les "$SaisieChiffre" dernières lignes du fichier de logs :"
      ShowNumberLastLine "logs.txt" "$SaisieChiffre"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    15)
      echo "Voici la liste des noms triés alphabétiquement :"
      SortList "ListeNom.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    16) 
      echo "Veuillez saisir un nom à vérifier :"
      read Nom4
      CountLogs "$Nom4" "logs.txt"
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------"
      ;;
    17)
      break
      ;;
    q)
      break
      ;;
    Q)
      break
      ;;
    .)
      break
      ;;
    *)
      echo "Option inexistante, veuillez reessayer."
      echo "---------------------------------------------------------"
      read -p "Appuyer sur entrée pour revenir au menu des choix "
      echo "---------------------------------------------------------" 
      ;;
  esac
done
