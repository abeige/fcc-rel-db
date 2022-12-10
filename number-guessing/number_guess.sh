#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

NUMBER=$(($RANDOM % 1000 + 1))
echo $NUMBER

echo "Enter your username:"
read USERNAME

USER_RESULT=$($PSQL "SELECT * FROM player WHERE username = '$USERNAME'")

BEST_GAME=0

if [[ -z $USER_RESULT ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO player(username) VALUES('$USERNAME')")
else
  echo "$USER_RESULT" | while read USERNAME BAR GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

PROMPT_GUESS() {
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    PROMPT_GUESS
  fi
}

NUM_GUESSES=1
echo "Guess the secret number between 1 and 1000:"
PROMPT_GUESS

while [[ $GUESS != $NUMBER ]]
do
  if [[ $NUMBER < $GUESS ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi

  NUM_GUESSES=$(( NUM_GUESSES + 1 ))
  PROMPT_GUESS
done

echo "You guessed it in $NUM_GUESSES tries. The secret number was $NUMBER. Nice job!"

UPDATE_USER_RESULT=$($PSQL "UPDATE player SET games_played = $GAMES_PLAYED + 1 WHERE username = '$USERNAME'")

if [[ $NUM_GUESSES < $BEST_GAME || $BEST_GAME == 0 ]]
then
  UPDATE_USER_RESULT=$($PSQL "UPDATE player SET best_game = $NUM_GUESSES WHERE username = '$USERNAME'")
fi
