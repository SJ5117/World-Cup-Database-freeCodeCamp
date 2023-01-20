#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND TEAM_W TEAM_O WINNER_GOALS OPPONENT_GOALS
do
  if [[ $TEAM_W != "winner" && $TEAM_O != "opponent" ]]
  then
  
    #get team
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_W'")
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_O'")

    #check if team is in teams already (if not found)
    if [[ -z $TEAM_ID_W ]] 
    then
    #insert team into teams
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_W')")
    fi

    #check if team is in teams already (if not found)
    if [[ -z $TEAM_ID_O ]] 
    then
    #insert team into teams
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_O')")
    fi

    #get winner/opponent_id from teams(team_id)
    TEAM_W_TEXT_GET=$($PSQL "SELECT name FROM teams WHERE name='$TEAM_W'")
    TEAM_O_TEXT_GET=$($PSQL "SELECT name FROM teams WHERE name='$TEAM_O'")
    WINNER_ID_GET=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_W'")
    OPPONENT_ID_GET=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_O'")

    #check if winner/opponent_id in games already (if not found)
    if [[ $TEAM_W == $TEAM_W_TEXT_GET && $TEAM_O == $TEAM_O_TEXT_GET ]]
    then  
      #insert into games
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID_GET, $OPPONENT_ID_GET, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi
  fi
done

