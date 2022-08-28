!#/bin/bash

psql -U postgres < worldcup.sql
psql --username=freecodecamp --dbname=worldcup
