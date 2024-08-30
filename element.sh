#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  LOOKUP="atomic_number"
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
then
  LOOKUP="symbol"
else
  LOOKUP="name"
fi
  
ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.$LOOKUP = '$1'")

if [[ $ELEMENT ]]
then
  echo "$ELEMENT" | while read NUM BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
  do
    echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
else
  echo "I could not find that element in the database."
fi
