/* 1. Инструкция SELECT, использующая предикат сравнения */
/*/1* */
/* */
SELECT  players.player_username FROM players WHERE length(player_username) < 7;

/* 2. Инструкция SELECT, использующая предикат BETWEEN */
/*/1* */
/* */
SELECT  players.player_username,players.time_played FROM players WHERE  time_played  BETWEEN 100  AND 1000;

/* 3. Инструкция SELECT, использующая предикат LIKE */
/*/1* */
SELECT  * FROM sponsor WHERE  product  LIKE '%r';

/* 4. Инструкция SELECT, использующая предикат IN со вложенным подзапросом */

SELECT  * FROM sponsor WHERE  product  IN ('Water','Computer','Pillow');
SELECT  * FROM sponsor WHERE  sponsor_id  IN (SELECT sponsor_id  from sponsor where networth< 2000);

/* 5. Инструкция SELECT, использующая предикат EXISTS со вложенным подзапросом */
/*Герои которых никогда не выбирали*/
SELECT  heroes.hero_id,* FROM heroes WHERE
                                  NOT EXISTS
                                      (SELECT hero_id from game  Where game.hero_id = heroes.hero_id);



/* 6. Инструкция SELECT, использующая предикат сравнения с квантором */
/*/1* */
/*Поиск игр у которых больше продолжительность чем у всех игр с меньшем чем 100 просмотрами*/
SELECT  * FROM game WHERE  game.duration  >
    ALL (SELECT game.duration from game  Where game.viewers < 100);

SELECT game.duration from game  Where game.viewers < 100;

/* 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов */
SELECT is_professional, AVG(players.time_played) as avg_time FROM players GROUP BY is_professional;
SELECT game.hero_id ,AVG(game.duration) as avg_time FROM game GROUP BY game.hero_id;



/* 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов */
/**/
SELECT player_id,player_name,
       (SELECT avg(duration) from game where game.player_id = players.player_id) from players;
/* 9. Инструкция SELECT, использующая простое выражение CASE */

SELECT
    game_id,
    dark_won,
    duration,
    CASE dark_won
        WHEN true THEN 'won_dire'
        ELSE 'won_radiant'

    END winnings
FROM
    game;


/* 10. Инструкция SELECT, использующая поисковое выражение CASE */
SELECT
    game_id,
    dark_won,
    duration,
    CASE
        WHEN duration < 30 THEN 'easy'
        WHEN duration  < 60 THEN 'medium'
        WHEN duration < 100 THEN 'hard'
        ELSE 'extrahard'

    END game_difficulty
FROM
    game;

/* 11. Создание новой временной локальной таблицы из резальтирующего набора данных инструкции SELECT */
/*/1* */
/* Works only from psql*/
CREATE TEMPORARY TABLE leaderboard as
    (select player_id,
            player_username,
            win_rate
     from players
     ORDER BY win_rate
     DESC);

SELECT player_id,player_username,win_rate INTO new_leaderboard from players  ORDER BY win_rate DESC;

SELECT * from leaderboard;

/* 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM */
/*/1* */
/* */
/*SELECT player_id,player_name
       (SELECT avg(win_rate * time_played) from players where game.player_id = players.player_id) as winrate from game;*/
/*Нашли всех игроков и компании которые в среднем стоят больше чем в среднем компании данного игрока*/
SELECT player_id,s_n,s_p from
                      (SELECT player_id,sponsor.sponsor_name as s_n,sponsor.product as s_p
                       from sponsor inner join game on game.sponsor_id = sponsor.sponsor_id
                      where (networth >
                          (SELECT avg(networth)
                          from sponsor inner join game on game.sponsor_id = sponsor.sponsor_id
                              where player_id = player_id)))
                          as sponsor_der;


/* 13. Инстркуция SELECT, использующая вложенные подзапросы с уровнем вложенности 3 */
/*/1* */
SELECT player_id,s_n,s_p from
                      (SELECT player_id,sponsor.sponsor_name as s_n,sponsor.product as s_p
                       from sponsor inner join game on game.sponsor_id = sponsor.sponsor_id
                      where (networth >
                          (SELECT avg(networth)
                          from sponsor inner join game on game.sponsor_id = sponsor.sponsor_id
                              where player_id = player_id)))
                          as sponsor_der;





/* 14. Инстркуция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING */
/*/1* */
SELECT product, avg(networth) AS avg_cost from sponsor GROUP BY product;


/* 15. Инстркуция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING */
/*/1* */
/* */
SELECT product, avg(networth) AS avg_cost
from sponsor GROUP BY product
HAVING avg(networth) > (SELECT avg(networth) from sponsor);

/* 16. Однострочная INSERT, выполняющая вставку в таблицу одной строки значений */
/*/1* */
/* */
INSERT INTO game (game_id ,
	player_id,
    hero_id ,
    team_id ,
    sponsor_id ,
    viewers ,
    kills ,
    duration ,
    dark_won ,
    time_start) VALUES (5000, 1, 1, 1, 1, 32,0,100,false,'01:01:01');
/* 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса */
/*/1* */
/* */
CREATE TEMPORARY TABLE IF NOT EXISTS players_stats(
	player_id serial,
	player_name TEXT,
    games_won INT,
    overall_games INT
);


INSERT INTO pg_temp.players_stats (player_id, player_name,games_won)
SELECT game.player_id, min(player_username), count(*) as games_won
    from game inner join players on players.player_id = game.player_id
    where dark_won = true
    group by(game.player_id);
SELECT * FROM players_stats;

/* 18. Простая инструкция UPDATE */
/*/1* */
/* */
UPDATE players SET player_username = '4epuha',player_name='Daniil Danilenko' WHERE player_id = 1;
/* 19. Инструкция UPDATE со скалярным подзапросом в предложении SET */
/*/1* */
/* */
UPDATE players SET was_banned = true  WHERE win_rate > (SELECT avg(win_rate) from players);

/* 20. Простая инструкция DELETE */
/*/1* */
/* */
DELETE  from leaderboard;
DELETE  from players_stats where (games_won < 1);

/* 21. Инструкция DELETE со вложенным коррелированным подзапросом в предложении WHERE */
/*/1* */
/* Тут поведение не определено*/
DELETE  FROM players_stats
        WHERE player_id  =
              (SELECT player_id from game LIMIT 1);

DELETE  from players_stats
        where player_id NOT IN
        (SELECT player_id from game);
SELECT * FROM players_stats;

/* 22. Инструкция SELECT, использующая простое обобщённое табличное выражение */
/*/1* */
/* */
WITH TIMINGS (player_id,game_id,time_game)
AS
(SELECT game_id, player_id, time_start AS time_game from game)
SELECT * from TIMINGS;

/* 23. Инструкция SELECT, использующая рекурсивное обобщённое табличное выражение */
/*/1* */
/* */
CREATE TEMPORARY TABLE IF NOT EXISTS worker(
	manager_id serial PRIMARY KEY ,
	employee_id INT UNIQUE,
	name TEXT
);


INSERT INTO worker VALUES (-1,0,'high');
INSERT INTO worker VALUES (0,1,'medium');
INSERT INTO worker VALUES (1,2,'low');
INSERT INTO worker VALUES (-2,-1,'not displayed');


WITH RECURSIVE CTE_Hierarchy AS (

    SELECT
        manager_id,
        employee_id,
        name
    FROM
        worker
    WHERE
        name = 'high'
    UNION ALL
    SELECT
        w.manager_id,
        w.employee_id,
        w.name
    FROM
        worker w
    JOIN
        CTE_Hierarchy c ON c.employee_id = w.manager_id
)
SELECT *
FROM CTE_Hierarchy;




/* 24. Оконные функции. Использование конструкция MIN/MAX/AVG/OVER() */
/*/1* */
/* */
INSERT INTO game (game_id ,
	player_id,
    hero_id ,
    team_id ,
    sponsor_id ,
    viewers ,
    kills ,
    duration ,
    dark_won ,
    time_start) VALUES (5003, 478, 1, 1, 6, 32,0,100,false,'02:02:02');
SELECT sponsor_name,sponsor.sponsor_id,player_id,
    AVG(sponsor.networth) OVER(PARTITION BY sponsor.sponsor_id,player_id) as salary,
    count(*)  OVER(PARTITION BY sponsor.sponsor_id,player_id) as c_sponsored
FROM sponsor JOIN game ON game.sponsor_id  = sponsor.sponsor_id;


/* 25. Оконные функции для устранения дублей */
/*/1* */
/* */

INSERT INTO pg_temp.leaderboard (SELECT  * from pg_temp.leaderboard);

SELECT * from pg_temp.leaderboard;

SELECT * from (SELECT player_id,
                      player_username,
                      win_rate,
                      row_number() over (PARTITION BY player_id) as row_n
               FROM leaderboard) as lead_temp
where row_n > 1;

/*Вывести информацию  о игроках которые сыграли не менее 3 игр, минимальная длительность всех игр  - 300,
  Вывести информацию о продуктах споносоров и названиях их компаний/
  Защита
 */

SELECT * FROM
    (SELECT game.player_id,COUNT(*) as cnt,SUM(duration) as dur
            FROM players
     JOIN game
    ON players.player_id=game.player_id
    GROUP BY game.player_id HAVING SUM(duration) > 300 AND COUNT(*) >=3 ) as needed_players;

/*completed task*/
 SELECT players.*,pl_sp.product,pl_sp.networth,pl_sp.sponsor_name
 FROM
     (
    SELECT s.networth,s.product,s.sponsor_name,player_id
    FROM game RIGHT JOIN sponsor s on game.sponsor_id = s.sponsor_id
     WHERE player_id IN
    (SELECT players.player_id
     FROM players
     JOIN game
    ON players.player_id=game.player_id
    GROUP BY players.player_id HAVING SUM(duration) > 300 AND COUNT(*) >=3 )) as pl_sp
    JOIN players on pl_sp.player_id = players.player_id;






 SELECT player_id,s.product,s.networth

    FROM game RIGHT JOIN sponsor s on game.sponsor_id = s.sponsor_id
     WHERE player_id IN
    (SELECT players.player_id
     FROM players
     JOIN game
    ON players.player_id=game.player_id
    GROUP BY players.player_id HAVING SUM(duration) > 300 AND COUNT(*) >=3 );

/*SELECT * from players ORDER BY players.win_rate DESC LIMIT 100;*/