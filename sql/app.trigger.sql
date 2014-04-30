DROP TRIGGER IF EXISTS acw.before_delete_org_app;
DELIMITER //
CREATE TRIGGER acw.before_delete_org_app
    BEFORE DELETE ON org_app FOR EACH ROW
    BEGIN
    	UPDATE app_user 
    	set app_user.org = OLD.org AND app_user.app = OLD.app;
    END //
DELIMITER ;

DROP TRIGGER IF EXISTS acw.after_delete_org_app;
DELIMITER //
CREATE TRIGGER acw.after_delete_org_app
    AFTER DELETE ON org_app FOR EACH ROW
    BEGIN
    	INSERT INTO org_app_log
	    	(org, app, init, end)
	    	VALUES (OLD.org, OLD.app, OLD.init, current_timestamp);
    END //
DELIMITER ;

DROP TRIGGER IF EXISTS acw.after_disable_app;
DELIMITER //
CREATE TRIGGER acw.after_disable_app
    AFTER DELETE ON active_app FOR EACH ROW
    BEGIN
    	INSERT INTO active_app_log
	    	(app, init, end)
	    	VALUES (OLD.app, OLD.init, current_timestamp);
    END //
DELIMITER ;

DROP TRIGGER IF EXISTS acw.after_delete_app_user;
DELIMITER //
CREATE TRIGGER acw.after_delete_app_user
    AFTER DELETE ON app_user FOR EACH ROW
    BEGIN
    	INSERT INTO app_user_log
	    	(usr, org, app, init, end)
	    	VALUES (OLD.user, OLD.org, OLD.app, OLD.init, current_timestamp);
    END //
DELIMITER ;