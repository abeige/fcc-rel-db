#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# clear database
echo $($PSQL "TRUNCATE TABLE games, teams")

# read csv file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OP_GOALS
do
  if [[ $YEAR != year ]]
  then
    # get winning team id
    WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    # team id doesn't exist
    if [[ -z $WIN_TEAM_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
      WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi

    # get opposing team id
    OP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    # team id doesn't exist
    if [[ -z $OP_TEAM_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
      OP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_TEAM_ID, $OP_TEAM_ID, $WIN_GOALS, $OP_GOALS);")
  fi
done