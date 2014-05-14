SELECT org.id, org.abbr, org.name
FROM org
JOIN active_org ON org.id = active_org.org
JOIN role_user ON (
	( role_user.role = 'admin'
		OR ( role_user.org = org.id AND role_user.role = 'org.admin' )
	) AND role_user.user = 'krbnc2n5da'
) GROUP BY org.id
ORDER BY org.name