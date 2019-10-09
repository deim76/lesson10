-- Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы

-- Таблица Users
-- 1.1 Индекс e_mail tab users. если авторизация приложения по e-mail 
CREATE UNIQUE INDEX users_email_uq ON users(email);
-- 1.2 Индекс phone tab users. если авторизация приложения по телефону 
CREATE UNIQUE INDEX users_phone_uq ON users(phone);

-- Таблица profiles
-- 2.1 Нет смысла в индексе поле id первичный ключ значения hometown и birthday может иметь множество одинаковых значений.
SELECT user_id FROM profiles WHERE hometown='value';
CREATE INDEX profiles_hometown_uq ON profiles(hometown);

-- Таблица Messages
-- 3.1 индексация сообщения  
SELECT to_user_id  FROM messages WHERE from_user_id='id'; 
SELECT from_user_id, COUNT(id) FROM messages WHERE delivered=1;
CREATE INDEX messages__to_user_id_from_user_id_uq ON messages(to_user_id,from_user_id);

-- Таблица POST
-- 4.1 индексация posts добавлены 3 индекса 
-- 1. при поиске post основной поиск по заголовкам.
-- 2. для запросов о постах друзей
-- 3. запросы событий в группе.
SELECT *  FROM posts WHERE title='title';
SELECT *  FROM posts WHERE user_id='id'; 
SELECT *  FROM posts WHERE user_id='communitie_id'; 
CREATE INDEX posts__title_uq ON posts(title);
CREATE INDEX posts__user_id_title_uq ON posts(user_id,title);
CREATE INDEX posts__communitie_id_title_uq ON posts(communitie_id,title);

-- Таблица MEDIA
-- 5.1 Обработка сообщений о добавлении медиа событий у других пользователей.
SELECT * FROM media WHERE user_id='id' AND media_type_id="media" ORDER BY updated_at DESC LIMIT 1; 
CREATE INDEX media_user_id_media_type_id_updated_at_uq ON media(user_id,media_type_id,updated_at);

-- Таблица LIKES 
-- 6.1 для аналитики по user поставившему like
SELECT * FROM likes WHERE user_id='id'; 
CREATE INDEX likes_user_id_uq ON likes(user_id);
-- индексация по полям для запросов
 SELECT * FROM likes WHERE target_id='id' and arget_type_id='target_type'; 
CREATE INDEX likes_target_id_target_type_id_uq ON likes(target_id,target_type_id);


