#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
    exit 1
fi

# Extract the argument
element=$1

# Query the database and output information about the element
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
query="SELECT * FROM elements WHERE atomic_number = '$element' OR symbol = '$element' OR name = '$element';"
result=$($PSQL "$query")

# Check if element is found
if [ -z "$result" ]; then
    echo "I could not find that element in the database."
else
    echo "$result"
fi
