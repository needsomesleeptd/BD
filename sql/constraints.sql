
ALTER TABLE players ADD PRIMARY KEY (player_id);
ALTER TABLE players ADD CONSTRAINT player_constraint UNIQUE (player_username);
ALTER TABLE players ADD CONSTRAINT time_constraint CHECK(time_played < 100000);
/*ALTER TABLE players ADD CONSTRAINT best_hero_constraint FOREIGN KEY (hero_id) REFERENCES heroes ();*/


ALTER TABLE heroes ADD PRIMARY KEY (hero_id);
ALTER TABLE heroes ADD CONSTRAINT hero_name_constraint UNIQUE (hero_name);
ALTER TABLE heroes ADD CONSTRAINT hero_damage_contraint CHECK(damage < 5000);
ALTER TABLE heroes ADD CONSTRAINT hero_health_constraint CHECK(health < 200000);
ALTER TABLE heroes ADD CONSTRAINT pick_percentage_constraint CHECK(pick_percentage < 100);
/*ALTER TABLE ADD CONSTRAINT best_player_id FOREIGN KEY (best_player_id)
        REFERENCES players (player_id)*/

ALTER TABLE team ADD PRIMARY KEY (team_id);

ALTER TABLE sponsor ADD PRIMARY KEY (sponsor_id);
ALTER TABLE sponsor ADD CONSTRAINT networth_constraint_high CHECK(networth < 2000000000);
ALTER TABLE sponsor ADD CONSTRAINT networth_constraint_low CHECK(0 < networth);


/*game*/

ALTER TABLE game ADD PRIMARY KEY (game_id);
ALTER TABLE game ADD CONSTRAINT player_game_constraint FOREIGN KEY (player_id)
        REFERENCES players (player_id) ON DELETE CASCADE;

ALTER TABLE game ADD CONSTRAINT hero_game_constraint FOREIGN KEY (hero_id) REFERENCES heroes (hero_id) ON DELETE CASCADE;

ALTER TABLE game ADD CONSTRAINT team_game_constraint FOREIGN KEY (team_id)
        REFERENCES team (team_id) ON DELETE CASCADE;

ALTER TABLE game ADD CONSTRAINT sponsor_id FOREIGN KEY (sponsor_id)
        REFERENCES sponsor (sponsor_id) ON DELETE CASCADE;

ALTER TABLE game ADD CONSTRAINT game_viewer_constraint CHECK(viewers < 1000000) ON DELETE CASCADE;


