/* 1. Инструкция SELECT, использующая предикат сравнения */
/*/1* */
/* */
/*SELECT  players.player_username FROM players WHERE length(player_username) < 7;*/

/* 2. Инструкция SELECT, использующая предикат BETWEEN */
/*/1* */
/* */
/*SELECT  players.player_username,players.time_played FROM players WHERE  time_played  BETWEEN 100  AND 1000;*/

/* 3. Инструкция SELECT, использующая предикат LIKE */
/*/1* */
/*SELECT  * FROM sponsor WHERE  product  LIKE '%r';*/

/* 4. Инструкция SELECT, использующая предикат IN со вложенным подзапросом */
/*/1* */
/*SELECT  * FROM sponsor WHERE  product  IN ('Water','Computer','Pillow');*/
/*SELECT  * FROM sponsor WHERE  sponsor_id  IN (SELECT sponsor_id  from sponsor where networth< 2000);*/

/* 5. Инструкция SELECT, использующая предикат EXISTS со вложенным подзапросом */
/*SELECT  hero_id,* FROM heroes WHERE  NOT EXISTS (SELECT hero_id from game  Where game.hero_id = heroes.hero_id)*/



/* 6. Инструкция SELECT, использующая предикат сравнения с квантором */
/*/1* */
/* */
/*SELECT  * FROM heroes WHERE  hero_id  = ANY (SELECT game.hero_id from game  Where game.hero_id = heroes.hero_id)*/

/* 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов */
SELECT is_professional, AVG(players.time_played) as avg_time FROM players GROUP BY is_professional;
SELECT game.hero_id ,AVG(game.duration) as avg_time FROM game GROUP BY game.hero_id;



/* 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов */
SELECT game_id,(SELECT max(players.time_played) from players where player_id = game.player_id) FROM game;

/* 9. Инструкция SELECT, использующая простое выражение CASE */
SELECT
    game_id,
    dark_won,
    duration,
    CASE
        WHEN duration < 30 THEN 'easy'
        WHEN duration  < 60 THEN 'medium'
        WHEN duration >= 60 THEN 'hard'
        ELSE 'extrahard'

    END game_difficulty
FROM
    game;

/* 10. Инструкция SELECT, использующая поисковое выражение CASE */


/* 11. Создание новой временной локальной таблицы из резальтирующего набора данных инструкции SELECT */
/*/1* */
/* */

/* 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM */
/*/1* */
/* */

/* 13. Инстркуция SELECT, использующая вложенные подзапросы с уровнем вложенности 3 */
/*/1* */
/* */

/* 14. Инстркуция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING */
/*/1* */
/* */

/* 15. Инстркуция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING */
/*/1* */
/* */

/* 16. Однострочная INSERT, выполняющая вставку в таблицу одной строки значений */
/*/1* */
/* */

/* 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса */
/*/1* */
/* */

/* 18. Простая инструкция UPDATE */
/*/1* */
/* */

/* 19. Инструкция UPDATE со скалярным подзапросом в предложении SET */
/*/1* */
/* */

/* 20. Простая инструкция DELETE */
/*/1* */
/* */

/* 21. Инструкция DELETE со вложенным коррелированным подзапросом в предложении WHERE */
/*/1* */
/* */

/* 22. Инструкция SELECT, использующая простое обобщённое табличное выражение */
/*/1* */
/* */

/* 23. Инструкция SELECT, использующая рекурсивное обобщённое табличное выражение */
/*/1* */
/* */

/* 24. Оконные функции. Использование конструкция MIN/MAX/AVG/OVER() */
/*/1* */
/* */

/* 25. Оконные функции для устранения дублей */
/*/1* */
/* */
