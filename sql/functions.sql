--1. Скалярную функцию
CREATE OR REPLACE FUNCTION findTheMostKillsGame(id integer)
    RETURNS integer AS
$$
DECLARE
    max_kills integer;
begin
    SELECT MAX(kills)
    into max_kills
    from game
    where id = player_id;
    return max_kills;


end;
$$ LANGUAGE plpgsql;


SELECT *
from findTheMostKillsGame(32);


--2. Подставляемую табличную функцию
CREATE OR REPLACE FUNCTION player_games(pl_id integer)
    RETURNS SETOF bool
AS
$$
BEGIN
    RETURN QUERY SELECT dark_won FROM game WHERE player_id = pl_id;
END;
$$ LANGUAGE plpgsql;

SELECT *
from player_games(6);

SELECT *
from game
where player_id = 6;



SELECT *
from get_best_won_games(1);

--3. Многооператорную табличную функцию
DROP FUNCTION player_stats;

CREATE OR REPLACE FUNCTION player_stats(pl_id integer)
    RETURNS TABLE
            (
                kills    int,
                duration int,
                viewers  int
            )
AS
$$
BEGIN
    RETURN QUERY SELECT game.kills,
                        game.duration,
                        game.viewers
                 from game
                 where player_id = pl_id;

end;
$$ LANGUAGE plpgsql;

SELECT *
from player_stats(6);

--4. Рекурсивную функцию или функцию с рекурсивным ОТ

CREATE TEMPORARY TABLE IF NOT EXISTS worker
(
    manager_id  serial PRIMARY KEY,
    employee_id INT UNIQUE,
    name        TEXT
);


INSERT INTO worker
VALUES (-1, 0, 'high');
INSERT INTO worker
VALUES (0, 1, 'medium');
INSERT INTO worker
VALUES (1, 2, 'low');
INSERT INTO worker
VALUES (-2, -1, 'not displayed');



DROP FUNCTION findFactorial;

CREATE OR REPLACE FUNCTION findFactorial(n integer)
    RETURNS integer
AS
$$
BEGIN
    IF n = 0 OR n = 1 THEN
        RETURN 1;
    ELSE
        RETURN n * findFactorial(n - 1);
    END IF;
END;
$$ LANGUAGE plpgsql;



SELECT *
from findFactorial(3);

--5. Хранимую процедуру без параметров или с параметрами

CREATE OR REPLACE PROCEDURE insertIntoTeam(id INT, name text, occupied bool, won int, pop int)
AS
$$
BEGIN
    INSERT INTO team
    VALUES (id, name, occupied, won, pop);
end;
$$ LANGUAGE plpgsql;

call insertIntoTeam(10000, 'idc4epuhaTeam', false, 321, 10000);


--6. Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
CREATE OR REPLACE PROCEDURE recursiveProc(n integer)
AS
$$
BEGIN
    WHILE n > 0
        LOOP
            -- Perform some operations or actions
            RAISE NOTICE 'Executing loop iteration: %', n;

            -- Increment the counter
            n := n - 1;

            -- Call the function recursively
            CALL recursiveProc(n - 1);
        END LOOP;
end;
$$ LANGUAGE plpgsql;

CALL recursiveProc(5);

--7. Хранимую процедуру с курсором

CREATE OR REPLACE PROCEDURE RichSponsorsView(min_networth INT)
AS
$$
DECLARE
    rich_sponsors CURSOR
        FOR
        SELECT sponsor_id, sponsor_name, product, networth
        FROM sponsor
        WHERE sponsor.networth > min_networth;
    id       INT;
    name     text;
    product  text;
    networth INT;
BEGIN
    OPEN rich_sponsors;
    FETCH NEXT FROM rich_sponsors INTO id, name,product,networth;

    WHILE FOUND
        LOOP
            RAISE NOTICE 'ID: %, Name: %, Product: %, Networth: %', id, name, product, networth;
            FETCH NEXT FROM rich_sponsors INTO id, name, product, networth;
        END LOOP;
end;
$$ LANGUAGE plpgsql;

CALL RichSponsorsView(10000);

SELECT *
from postgres.public.team;

--8. Хранимую процедуру доступа к метаданным
CREATE OR REPLACE PROCEDURE get_all_str_columns(sch text, t text)
AS
$$
DECLARE
    indexdata RECORD;
BEGIN
    for indexdata in
        SELECT indexname, indexdef
        FROM pg.as pg
        WHERE pg.tablename = t
          and pg.schemaname = sch
        LOOP
            raise notice 'Index name: %; indexdef: %',
                indexdata.indexname, indexdata.indexdef;
        end loop;

end;
$$ LANGUAGE plpgsql;

DROP PROCEDURE get_all_str_columns;
CREATE or REPLACE PROCEDURE get_all_str_columns(sch TEXT, t TEXT)
AS
$$
DECLARE
    indexdata RECORD;
BEGIN
    RAISE NOTICE 'Notice message  %', now();
    for indexdata in
        SELECT column_name, data_type
        FROM information_schema.columns as cl
        WHERE data_type = 'text'
          and table_name = t
          and table_schema = sch
        LOOP
            raise notice 'Column name: %; Type: %',
                indexdata.column_name, indexdata.data_type;
        end loop;
END;
$$ LANGUAGE PLPGSQL;

CALL get_all_str_columns('public', 'sponsor');


SELECT *
FROM information_schema.columns
WHERE table_name = 'sponsor';

--9. Триггер AFTER

CREATE OR REPLACE FUNCTION trigger_log()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF NEW.player_name <> OLD.player_name THEN
        RAISE NOTICE 'OLD name: %, NEW name: %',OLD.player_name,NEW.player_name;
    END IF;
    RETURN NEW;
END ;
$$;



CREATE TRIGGER players_log
    AFTER UPDATE
    ON players
    FOR EACH ROW
EXECUTE FUNCTION trigger_log();


UPDATE players
SET player_name = 'FREAK'
WHERE player_username = '4epuha';

--10. Триггер INSTEAD OF

CREATE OR REPLACE FUNCTION insert_players()
    RETURNS TRIGGER
AS
$$
BEGIN
    IF new.win_rate is null THEN
        RAISE WARNING 'For VAC check  win_rate must be specified!';
        RETURN NULL;
    ELSIF new.is_professional is null THEN
        RAISE WARNING 'For VAC check  is_professional must be specified!';
        RETURN NULL;
    ELSIF new.win_rate > 90 AND new.is_professional = FALSE THEN
        new.was_banned = TRUE;
        RAISE WARNING 'Player % had to be banned,with unhealthy winrate',new.player_name;

    RAISE INFO 'Success!';
    INSERT INTO players
    VALUES (new.player_id,
            new.player_username,
            new.player_name,
            new.time_played,
            new.was_banned,
            new.win_rate,
            new.is_professional);
    RETURN NEW;
    END IF;
END;
$$ LANGUAGE PLPGSQL;



DROP VIEW IF EXISTS players_view;
CREATE VIEW players_view
AS SELECT * FROM players;

DROP TRIGGER VAC_trigger ON players_view;

CREATE TRIGGER VAC_trigger
    INSTEAD OF INSERT
    ON players_view
    FOR EACH ROW
EXECUTE FUNCTION insert_players();

INSERT INTO players_view VALUES (7000,'SHreck','nss',10,TRUE,32,TRUE);

INSERT INTO players_view VALUES (7001,'SHreck','nss',10,TRUE,NULL,TRUE);

INSERT INTO players_view VALUES (7003,'asreck','nss',10,FALSE,96,TRUE);


INSERT INTO players_view VALUES (6534,'4epuha.Gelenzhik2007','nss',10,FALSE,96,FALSE);

SELECT * from players_view where player_id = 6534;