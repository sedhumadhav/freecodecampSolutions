#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo "SERVER: test"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo "SERVER: prod"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
# ---------------------------------------------------------------------------------------

# INSERT DATA INTO TEAMS
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # skip the first column
  if [[ $YEAR != "year" ]]; then
    # find if winner is already in teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if winner doesn't exist in teams table [-z means empty or zero length string]
    if [[ -z $WINNER_ID ]]; then
      WINNER_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      echo "> SUCCESS : Inserted $WINNER at id $WINNER_ID"
    else 
      echo "> FAILURE : $WINNER already exists at id $WINNER_ID"
    fi

    # find if loser is already in teams table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if winner doesn't exist in teams table [-z means empty or zero length string]
    if [[ -z $OPPONENT_ID ]]; then
      OPPONENT_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      echo "> SUCCESS : Inserted $OPPONENT at id $OPPOENET_ID"
    else 
      echo "> FAILURE : $OPPONENT already exists at id $OPPONENT_ID"
    fi
  fi
done
# SHOW TEAMS TABLE
RESULT_TEAM_TABLE=$($PSQL "SELECT * FROM teams")
echo -e "RESULT :  \n$RESULT_TEAM_TABLE"

# ---------------------------------------------------------------------------------------

# INSERT DATA INTO GAMES
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # skip the first column
  if [[ $YEAR != "year" ]]; then
    # find if game is already in games table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")
    # if game doesn't exist in games table [-z means empty or zero length string]
    if [[ -z $GAME_ID ]]; then
      GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      echo "> SUCCESS : Inserted game at id $GAME_ID"
    else 
      echo "> FAILURE : game already exists at id $GAME_ID"
    fi
  fi
done
# SHOW GAMES TABLE
RESULT_GAME_TABLE=$($PSQL "SELECT * FROM games")
echo -e "RESULT :  \n$RESULT_GAME_TABLE"

# ---------------------------------------------------------------------------------------

# # RESET COMMANDS FOR GAMES
# $PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1"
# $PSQL "DELETE FROM games"
# # RESET COMMANDS FOR TEAMS
# $PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1"
# $PSQL "DELETE FROM teams"
