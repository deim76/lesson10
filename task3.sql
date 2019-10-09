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

SELECT * From (
SELECT name, #concat(users.first_name,' ',users.last_name),
(SELECT count(*) FROM users)  as all_users,
FIRST_VALUE(birthday) over(w ORDER BY birthday DESC)  AS yong,
FIRST_VALUE(birthday) over(w ORDER BY birthday)  AS old,
COUNT(*) over w as count_users_gr,
COUNT(*) over w as avg_users_gr,
COUNT(*) OVER w / (SELECT count(*) FROM users)   * 100 AS "%%"
from communities
JOIN communities_users on communities_users.community_id=communities.id
JOIN profiles on communities_users.user_id=profiles.user_id
JOIN users on users.id=communities_users.user_id
WINDOW w AS (PARTITION BY name)) tab
GROUP BY name
