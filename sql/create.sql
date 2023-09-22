CREATE TABLE  IF NOT EXISTS players (
	player_id serial,
	player_username VARCHAR ( 50 ),
    player_name TEXT,
    time_played INT,
    was_banned BOOLEAN,
    win_rate INT,
    is_professional BOOLEAN
);

CREATE TABLE IF NOT EXISTS heroes (
	hero_id serial,
	hero_name TEXT,
    damage INT,
    health INT,
    best_player_id INT,
    pick_percentage INT
);

CREATE TABLE IF NOT EXISTS team (
	team_id serial,
	team_name TEXT,
    is_occupied BOOLEAN,
    winnings INT,
    popularity INT
);

CREATE TABLE IF NOT EXISTS sponsor (
	sponsor_id serial,
	sponsor_name TEXT,
    networth INT,
    product TEXT,
    is_foreign BOOLEAN
);



CREATE TABLE IF NOT EXISTS game(
	game_id serial,
	player_id INT,
    hero_id INT,
    team_id INT,
    sponsor_id INT,
    viewers INT,
    kills INT,
    duration INT,
    dark_won BOOLEAN,
    time_start TIME
);
