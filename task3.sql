/* оконные функции
Построить запрос, который будет выводить следующие столбцы:
имя группы
среднее количество пользователей в группе
самый молодой пользователь в группе
самый пожилой пользователь в группе
общее количество пользователей в группе
всего пользователей в системе
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100 */

USE vk;

SELECT community_id, communities.name,users.first_name,
MAX(communities_users.user_id) over w AS 'row_number',
MIN(profiles.birthday) over(ORDER BY profiles.birthday) as yong,
MAX(profiles.birthday) over w as old,
COUNT(communities_users.user_id) OVER w / COUNT(communities_users.user_id) OVER() * 100 AS "%%"
FROM communities_users
JOIN communities ON id=community_id
JOIN profiles ON communities_users.user_id=profiles.user_id
JOIN users ON users.id=profiles.user_id
WINDOW w AS (PARTITION BY community_id,profiles.birthday ORDER BY communities_users.user_id);




/*SELECT community_id, ROW_NUMBER() OVER w AS 'row_number'
FROM communities_users
WINDOW w AS (PARTITION BY community_id=2);

SELECT 
  ROW_NUMBER() OVER w AS 'row_number',
 FIRST_VALUE(user_id)  OVER w AS 'first',
  LAST_VALUE(user_id)   OVER w AS 'last',
  NTH_VALUE(user_id, 2) OVER w AS 'second'
    FROM communities_users
      WINDOW w AS (PARTITION BY LEFT(created_at, 3) ORDER BY created_at); */  