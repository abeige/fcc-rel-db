#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

LOOKUP_KEY() {
    # if input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="atomic_number = $1"
  else
    CONDITION="symbol = '$1' OR name = '$1'"
  fi

  ELEMENT_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE $CONDITION;")

  # if result is not empty
  if [[ -z $ELEMENT_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT_RESULT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELT BAR BOIL BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
}

# if argument exists
if [[ ! -z $1 ]]
then
  LOOKUP_KEY $1
else
  echo "Please provide an element as an argument."
fi
