#! /bin/bash

if [[ $1 == "test" ]]
then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "CREATE TABLE teams(
    team_id BIGSERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL UNIQUE
);"

$PSQL "CREATE TABLE games(
    game_id BIGSERIAL PRIMARY KEY NOT NULL,
    year INT NOT NULL,
    round VARCHAR(50) NOT NULL,
    winner VARCHAR(50) NOT NULL,
    opponent VARCHAR(50) NOT NULL,
    winner_id INT NOT NULL,
    opponent_id INT NOT NULL,
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL,
    FOREIGN KEY (winner_id) REFERENCES teams(team_id),
    FOREIGN KEY (opponent_id) REFERENCES teams(team_id)
);"

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR == 'year' ]]
  then
    continue
  fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  INSERT_ALL=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

done