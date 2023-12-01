CREATE EXTENSION IF NOT EXISTS plpython3u;
SELECT *
FROM pg_language;

-- Создать, развернуть и протестировать 6 объектов SQL CLR:

-- 1. Определяемую пользователем скалярную функцию CLR,


DROP FUNCTION IF EXISTS findTheMostKillsGame;
CREATE OR REPLACE FUNCTION findTheMostKillsGame(pl_id integer)
    RETURNS integer
AS
$$
    query = plpy.prepare("""
    SELECT MAX(kills)
    from game
    where player_id = $1;
    """, ['int']
                         )
    result = plpy.execute(query, [pl_id])
    if result:
        return result[0]['max']
$$ LANGUAGE plpython3u;

SELECT MAX(kills)
from game
where player_id = 32;

SELECT *
from findTheMostKillsGame(32);


-- 2. Пользовательскую агрегатную функцию CLR


DROP FUNCTION IF EXISTS whoWonMore;
CREATE OR REPLACE FUNCTION whoWonMore()
    RETURNS text
AS
$$
    query = plpy.prepare("""
    SELECT dark_won,count(*)
    from game
    group by dark_won
    """, []
                         )
    result = plpy.execute(query, [])
    if result[0]['dark_won'] and result[0]['count'] > result[1]['count']:
        return 'Dire'
    else:
        return 'Radiant'
$$ LANGUAGE plpython3u;

Select *
from whoWonMore();


SELECT dark_won, count(*)
from game
group by dark_won;


--3.  Определяемую пользователем табличную функцию CLR,


DROP FUNCTION IF EXISTS player_stats;
CREATE OR REPLACE FUNCTION player_stats(pl_id integer)
    RETURNS TABLE
            (
                kills    int,
                duration int,
                viewers  int
            )
AS
$$
    query = plpy.prepare("""
        SELECT game.kills,
               game.duration,
               game.viewers
        FROM game
        WHERE player_id = $1
        """, ["int"])

    result = plpy.execute(query, [pl_id])
    return result
$$ LANGUAGE plpython3u;

SELECT  * from player_stats(22);



--4. Хранимую процедуру CLR
DROP FUNCTION IF EXISTS insertIntoTeam;
CREATE OR REPLACE PROCEDURE insertIntoTeam(id INT, name text, occupied bool, won int, pop int)
AS
$$
    query = plpy.prepare("""
    INSERT INTO team
    VALUES ($1, $2, $3, $4, $5);
    """,['int','text','bool','int','int'])
    try:
        plpy.execute(query,[id,name,occupied,won,pop])
    except:
        plpy.notice('Error insertion' , hint="4epuha the best")
$$ LANGUAGE plpython3u;


call insertIntoTeam(10001, 'idc4epuhaTeamNew', false, 321, 10000);
call insertIntoTeam(10000, 'idc4epuhaTeamNew', false, 321, 10000);


--5.  Триггер CLR,

DROP FUNCTION IF EXISTS trigger_log;
CREATE OR REPLACE FUNCTION trigger_log()
RETURNS TRIGGER
AS $$
    old_name =  TD["old"]["player_name"]
    new_name =  TD["new"]["player_name"]
    if old_name !=  new_name:
        plpy.notice(old_name,new_name
    )
    return None
$$ LANGUAGE plpython3u;


DROP Trigger players_log on players;
CREATE TRIGGER players_log
    AFTER UPDATE
    ON players
    FOR EACH ROW
EXECUTE FUNCTION trigger_log();

UPDATE players
SET player_name = '13'
WHERE player_id = '0';


--6. Определяемый пользователем тип данных CLR

Drop type if exists  SponsorProduct;
CREATE TYPE  SponsorProduct
AS (
    prod_name     text,
    price  int,
    is_foreign bool
);


DROP FUNCTION IF EXISTS getSponsorsInfo;
CREATE OR REPLACE FUNCTION getSponsorsInfo(name_comp text)
RETURNS SponsorProduct
AS $$
    query = plpy.prepare("""
    SELECT product as prod_name, networth as price,is_foreign
    from sponsor
    where sponsor.sponsor_name = $1
    """,["text"])
    result = plpy.execute(query, [name_comp])
    if result:
        #return (result[0]["prod_name"], result[0]["price"], result[0]["is_foreign"])
        return result[0]
$$ LANGUAGE plpython3u;

SELECT * from getSponsorsInfo('Boone Inc');

SELECT * from getSponsorsInfo('Callahan, Wallace and Vega');






