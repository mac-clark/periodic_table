#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
fi

# Extract the argument
element=$1

# Check if the input is an integer
if [[ $element =~ ^[0-9]+$ ]]; then
    query="SELECT * FROM elements WHERE atomic_number = '$element';"
else
    query="SELECT * FROM elements WHERE symbol = '$element' OR name = '$element';"
fi

# Query the database and output information about the element
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
result=$($PSQL "$query")

# Check if element is found
if [ -z "$result" ]; then
    echo "I could not find that element in the database."
else
    atomic_number=$(echo "$result" | cut -d '|' -f 1 | tr -d '[:space:]')
    symbol=$(echo "$result" | cut -d '|' -f 2 | tr -d '[:space:]')
    name=$(echo "$result" | cut -d '|' -f 3 | tr -d '[:space:]')

    # Query additional information about the element from properties table
    query_properties="SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM properties INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number = '$atomic_number';"
    properties_result=$($PSQL "$query_properties")

    atomic_mass=$(echo "$properties_result" | cut -d '|' -f 1 | tr -d '[:space:]')
    melting_point_celsius=$(echo "$properties_result" | cut -d '|' -f 2 | tr -d '[:space:]')
    boiling_point_celsius=$(echo "$properties_result" | cut -d '|' -f 3 | tr -d '[:space:]')
    type=$(echo "$properties_result" | cut -d '|' -f 4 | tr -d '[:space:]')

    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
fi
