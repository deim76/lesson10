-- Задание на денормализацию
-- Разобраться как построен и работает следующий запрос:
-- Список медиафайлов пользователя с количеством лайков
-- Какие изменения, включая денормализацию, можно внести в структуру БД
-- чтобы существенно повысить скорость работы этого запроса?

USE vk;
-- 1.  при отсутствии лайков запрос пустой. 
-- изменено COUNT(DISTINCT likes.id) AS total_likes если лайков нет COUNT(*) выведет 1 при LEFT JOIN
-- условие объединения ON media.id = likes.target_id AND likes.target_type_id=1
SELECT media.filename,
target_types.name,
COUNT(DISTINCT likes.id) AS total_likes,
CONCAT(first_name, ' ', last_name) AS owner
FROM media
LEFT JOIN likes
ON media.id = likes.target_id AND likes.target_type_id=1
LEFT JOIN target_types
ON likes.target_type_id = target_types.id 
JOIN users
ON users.id = media.user_id
WHERE users.id = 15
GROUP BY media.id;

-- 2. изменения likes.target_type_id= ENUM 
SELECT media.filename,
target_types.name,
COUNT(DISTINCT likes.id) AS total_likes,
CONCAT(first_name, ' ', last_name) AS owner
FROM media
LEFT JOIN likes
ON media.id = likes.target_id AND likes.target_type_id=ENUM(1)
JOIN users
ON users.id = media.user_id
WHERE users.id = 15
GROUP BY media.id;

-- 3. изменения media.total_like добавление столбца total_like
SELECT media.filename,
media.total_like,
CONCAT(first_name, ' ', last_name) AS owner
FROM media
JOIN users
ON users.id = media.user_id
WHERE users.id = 15
GROUP BY media.id;

