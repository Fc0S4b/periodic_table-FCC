#!/bin/bash


PSQL="psql -X --tuples-only --username=freecodecamp --dbname=periodic_table -c"


INPUT=$1

if [[ $INPUT ]]
then
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then

    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT ")

    if [[ $ATOMIC_NUMBER ]]
    then
      TOTAL_QUERY=$($PSQL "SELECT name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$INPUT")
      TOTAL_QUERY=${TOTAL_QUERY// /}
      TOTAL_QUERY=${TOTAL_QUERY//| /|}
      TOTAL_QUERY=${TOTAL_QUERY// |/|}
      IFS='|' read col1 col2 col3 col4 col5 col6 <<< "$TOTAL_QUERY"
      echo "The element with atomic number $INPUT is $col1 ($col2). It's a $col6, with a mass of $col3 amu. Hydrogen has a melting point of $col4 celsius and a boiling point of $col5 celsius."

    else
      echo -e "I could not find that element in the database."
    fi

  elif [[ $INPUT =~ ^[a-zA-Z]+$ ]]
  then
      TOTAL_QUERY_SYMBOL=$($PSQL "SELECT name, atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$INPUT'")
      TOTAL_QUERY_NAME=$($PSQL "SELECT atomic_number, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties FULL JOIN elements USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$INPUT'")
      TOTAL_QUERY_SYMBOL=${TOTAL_QUERY_SYMBOL// /}
      TOTAL_QUERY_SYMBOL=${TOTAL_QUERY_SYMBOL//| /|}
      TOTAL_QUERY_SYMBOL=${TOTAL_QUERY_SYMBOL// |/|}
      TOTAL_QUERY_NAME=${TOTAL_QUERY_NAME// /}
      TOTAL_QUERY_NAME=${TOTAL_QUERY_NAME//| /|}
      TOTAL_QUERY_NAME=${TOTAL_QUERY_NAME// |/|}


     if [[ $TOTAL_QUERY_SYMBOL ]]
     then
         IFS='|' read col1 col2 col3 col4 col5 col6 <<< "$TOTAL_QUERY_SYMBOL"
         echo "The element with atomic number $col2 is $col1 ($INPUT). It's a $col6, with a mass of $col3 amu. $col1 has a melting point of $col4 celsius and a boiling point of $col5 celsius."
     elif [[ $TOTAL_QUERY_NAME ]]
     then
      IFS='|' read col1 col2 col3 col4 col5 col6 <<< "$TOTAL_QUERY_NAME"
         echo "The element with atomic number $col1 is $INPUT ($col2). It's a $col6, with a mass of $col3 amu. $INPUT has a melting point of $col4 celsius and a boiling point of $col5 celsius."
     else
       echo "I could not find that element in the database."
     fi

  else
  echo -e "invalid input"
  fi

else

  echo -e "Please provide an element as an argument."

fi



