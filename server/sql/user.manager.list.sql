SELECT
   user.id,
   user.full_name,
   user.short_name,
   IF(active_user.user IS NULL, 0, 1) active
FROM user
JOIN active_user ON user.id = active_user.user
WHERE
   user.creation > (
      select creation
      from user
      where
         id = 'krbnc2n5da'
   )
ORDER BY user.full_name
LIMIT 30 OFFSET 0;


SELECT
   user.id,
   user.full_name,
   user.short_name,
   IF(active_user.user IS NULL, 0, 1) active
FROM user
JOIN active_user ON user.id = active_user.user
JOIN user me ON me.id = 'krbnc2n5da'
WHERE
   user.creation > me.creation
ORDER BY user.full_name
LIMIT 30 OFFSET 0;