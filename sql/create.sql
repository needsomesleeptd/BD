CREATE TABLE players (
	player_id serial,
	player_username VARCHAR ( 50 ),
    player_name TEXT,
    time_played INT,
    was_banned BOOLEAN,
    best_hero_id INT,
    is_professional BOOLEAN
);

CREATE TABLE heroes (
	hero_id serial,
	hero_name TEXT,
    damage INT,
    health INT,
    best_player_id INT,
    pick_percentage INT
);

CREATE TABLE team (
	team_id serial,
	team_name TEXT,
    is_occupied BOOLEAN,
    winnings INT,
    popularity INT
);

CREATE TABLE sponsor (
	sponsor_id serial,
	sponsor_name TEXT,
    networth INT,
    product TEXT,
    is_foreign BOOLEAN
);

CREATE TABLE leaderboard(
    best_player_id INT,
    best_hero_id INT,
    timestamp TIME
);


CREATE TABLE game (
	game_id serial,
	player_id INT,
    hero_id INT,
    team_id INT,
    sponsor_id INT,
    viewers INT,
    kills INT,
    duration TIME,
    dark_won BOOLEAN
);
