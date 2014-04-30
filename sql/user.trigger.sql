DROP TRIGGER IF EXISTS acw.after_user_updates;
DELIMITER //
CREATE TRIGGER acw.after_user_updates
    AFTER UPDATE ON user FOR EACH ROW
    BEGIN
    	INSERT INTO user_log
    		(id,short_name,full_name,avatar,password, timestamp)
    		VALUES (OLD.id, OLD.short_name, OLD.full_name, OLD.avatar, OLD.password, current_timestamp);
    END //
DELIMITER ;

DROP TRIGGER IF EXISTS acw.after_disable_user;
DELIMITER //
CREATE TRIGGER acw.after_disable_user
    AFTER DELETE ON active_user FOR EACH ROW
    BEGIN
    	INSERT INTO active_user_log
    		(user, init, end)
    		VALUES (OLD.user, OLD.init, current_timestamp);
    END //
DELIMITER ;

DROP TRIGGER IF EXISTS acw.after_delete_user_role;
DELIMITER //
CREATE TRIGGER acw.after_delete_user_role
    AFTER DELETE ON role_user FOR EACH ROW
    BEGIN
    	INSERT INTO active_user_log
    		(user, init, end)
    		VALUES (OLD.user, OLD.init, current_timestamp);
    END //
DELIMITER ;

