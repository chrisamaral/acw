select user.*, IF(user_grant.timestamp IS NULL, 0, 1) activated
from user
left join user_grant ON (
	user_grant.user = user.id
	AND user_grant.init <= current_timestamp
	AND (user_grant.expiration IS NULL
			OR user_grant.expiration <= current_timestamp)
)
group by user.id