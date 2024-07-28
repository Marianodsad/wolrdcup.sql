#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

delete=$($PSQL "TRUNCATE teams, games")
echo $delete

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    TEAM_ID_WIN=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    if [[ -z $TEAM_ID_WIN ]]
    then
      INSERT_TEAM_W=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_W == "INSERT 0 1" ]]
      then 
        echo inserted into teams, $WINNER        
      fi
      TEAM_ID_WIN=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi


  fi
  

  if [[ $OPPONENT != opponent ]]
  then
    TEAM_ID_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $TEAM_ID_OPP ]]
    then
      INSERT_TEAM_O=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_O == "INSERT 0 1" ]]
      then 
        echo inserted into teams, $OPPONENT        
      fi
      TEAM_ID_OPP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

  fi
  
  INSERT_DATA_GAMES=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $TEAM_ID_WIN, $TEAM_ID_OPP)")



done
