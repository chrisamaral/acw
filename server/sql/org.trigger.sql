DROP TRIGGER IF EXISTS acw.after_disable_org;
DELIMITER //
CREATE TRIGGER acw.after_disable_org
    AFTER DELETE ON active_org FOR EACH ROW
    BEGIN
    	INSERT INTO active_org_log
	    	(org, init, end)
	    	VALUES (OLD.org, OLD.init, current_timestamp);
    END //
DELIMITER ;