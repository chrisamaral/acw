-- Adminer 4.1.0 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `action`;
CREATE TABLE `action` (
  `id` varchar(20) NOT NULL,
  `descr` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `action` (`id`, `descr`) VALUES
('app.create',  'create app'),
('app.get', 'get app info'),
('app.list',    'list apps'),
('app.off', 'disable app'),
('app.on',  'enable app'),
('org.app.off', 'disable app instance'),
('org.app.on',  'enable app instance'),
('org.app.user.off',    'disable access to app instance'),
('org.app.user.on', 'enable access to app instance'),
('org.create',  'create organization'),
('org.get', 'get organization info'),
('org.list',    'list organizations'),
('org.off', 'disable organization'),
('org.on',  'enable organization'),
('org.user.admin.off',  'unset user as org.admin'),
('org.user.admin.on',   'set user as org.admin'),
('org.user.get',    'get organization user info'),
('org.user.list',   'list organization users'),
('org.user.off',    'remove user from organization'),
('org.user.on', 'add user to organization'),
('user.admin.off',  'unset user as admin'),
('user.admin.on',   'set user as admin'),
('user.create', 'create user'),
('user.get',    'get user info'),
('user.list',   'list users'),
('user.off',    'disable user'),
('user.on', 'enable user');

DROP TABLE IF EXISTS `active_app`;
CREATE TABLE `active_app` (
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`app`),
  CONSTRAINT `active_app_ibfk_3` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;

CREATE TRIGGER `after_disable_app` AFTER DELETE ON `active_app` FOR EACH ROW
BEGIN
        INSERT INTO active_app_log
            (app, init, end)
            VALUES (OLD.app, OLD.init, current_timestamp);
    END;;

DELIMITER ;

DROP TABLE IF EXISTS `active_app_log`;
CREATE TABLE `active_app_log` (
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `id` (`app`),
  CONSTRAINT `active_app_log_ibfk_3` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP VIEW IF EXISTS `active_email`;
CREATE TABLE `active_email` (`email` varchar(50), `full_name` varchar(100));


DROP TABLE IF EXISTS `active_org`;
CREATE TABLE `active_org` (
  `org` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`org`),
  CONSTRAINT `active_org_ibfk_3` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;

CREATE TRIGGER `after_disable_org` AFTER DELETE ON `active_org` FOR EACH ROW
BEGIN
        INSERT INTO active_org_log
            (org, init, end)
            VALUES (OLD.org, OLD.init, current_timestamp);
    END;;

DELIMITER ;

DROP TABLE IF EXISTS `active_org_log`;
CREATE TABLE `active_org_log` (
  `org` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `id` (`org`),
  CONSTRAINT `active_org_log_ibfk_3` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `active_user`;
CREATE TABLE `active_user` (
  `user` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`),
  CONSTRAINT `active_user_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;

CREATE TRIGGER `after_disable_user` AFTER DELETE ON `active_user` FOR EACH ROW
BEGIN
        INSERT INTO active_user_log
            (user, init, end)
            VALUES (OLD.user, OLD.init, current_timestamp);
    END;;

DELIMITER ;

DROP TABLE IF EXISTS `active_user_log`;
CREATE TABLE `active_user_log` (
  `user` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `id` (`user`),
  CONSTRAINT `active_user_log_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `app`;
CREATE TABLE `app` (
  `id` varchar(10) NOT NULL,
  `abbr` varchar(15) NOT NULL,
  `name` varchar(200) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `creation` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `abbr` (`abbr`),
  KEY `creation` (`creation`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(10) NOT NULL,
  `org_app` int(11) NOT NULL,
  `org` varchar(10) DEFAULT NULL,
  `app` varchar(10) DEFAULT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_org_app` (`user`,`org_app`),
  UNIQUE KEY `user_org_app_other` (`user`,`org`,`app`),
  KEY `org_app` (`org_app`),
  KEY `app` (`app`),
  KEY `org` (`org`),
  CONSTRAINT `app_user_ibfk_14` FOREIGN KEY (`app`) REFERENCES `app` (`id`),
  CONSTRAINT `app_user_ibfk_15` FOREIGN KEY (`org`) REFERENCES `org` (`id`),
  CONSTRAINT `app_user_ibfk_7` FOREIGN KEY (`org_app`) REFERENCES `org_app` (`id`) ON DELETE CASCADE,
  CONSTRAINT `app_user_ibfk_9` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;

CREATE TRIGGER `after_delete_app_user` AFTER DELETE ON `app_user` FOR EACH ROW
BEGIN
        INSERT INTO app_user_log
            (user, org, app, init, end)
            VALUES (OLD.user, OLD.org, OLD.app, OLD.init, current_timestamp);
    END;;

DELIMITER ;

DROP TABLE IF EXISTS `app_user_log`;
CREATE TABLE `app_user_log` (
  `user` varchar(10) NOT NULL,
  `org` varchar(10) NOT NULL,
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `user` (`user`),
  KEY `app` (`app`),
  KEY `org` (`org`),
  CONSTRAINT `app_user_log_ibfk_3` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `app_user_log_ibfk_4` FOREIGN KEY (`app`) REFERENCES `app` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `app_user_log_ibfk_5` FOREIGN KEY (`org`) REFERENCES `org` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `org`;
CREATE TABLE `org` (
  `id` varchar(10) NOT NULL,
  `abbr` varchar(15) NOT NULL,
  `name` varchar(200) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `creation` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `abbr` (`abbr`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `org` (`id`, `abbr`, `name`, `icon`, `creation`, `timestamp`) VALUES
('chvie0f3m',   'simtv',    'Sim Tv',   NULL,   '2014-05-22 15:22:47',  '2014-05-22 18:22:47'),
('ihv034u1b',   'NewConnect',   'New Connect Parceira Claro',   NULL,   '2014-05-09 19:58:00',  '2014-05-09 22:58:26'),
('ihv03788b',   'Antiga',   'Joãozinho & Cia',  NULL,   '2014-05-09 20:00:00',  '2014-05-20 18:31:26'),
('ihvfja8yb',   'outraEmpresa', 'Nome extenso', NULL,   '2014-05-20 15:27:05',  '2014-05-20 18:31:18'),
('lhvfj4871',   'nenhumNome',   'empresa especializada em te x%#$', NULL,   '2014-05-20 15:22:24',  '2014-05-20 18:31:08');

DROP TABLE IF EXISTS `org_app`;
CREATE TABLE `org_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org` varchar(10) NOT NULL,
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_app` (`org`,`app`),
  KEY `app` (`app`),
  CONSTRAINT `org_app_ibfk_13` FOREIGN KEY (`app`) REFERENCES `active_app` (`app`) ON DELETE CASCADE,
  CONSTRAINT `org_app_ibfk_14` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `org_app` (`id`, `org`, `app`, `init`, `expiration`, `timestamp`) VALUES
(33,    'chvie0f3m',    'xhuzy3eeg',    '2014-05-22 16:08:21',  NULL,   '2014-05-22 19:08:21'),
(34,    'ihv034u1b',    'xhuzy3eeg',    '2014-05-22 18:04:24',  NULL,   '2014-05-22 21:04:24');

DELIMITER ;;

CREATE TRIGGER `after_delete_org_app` AFTER DELETE ON `org_app` FOR EACH ROW
BEGIN
   INSERT INTO org_app_log
      (org, app, init, end)
   VALUES (OLD.org, OLD.app, OLD.init, current_timestamp);
END;;

DELIMITER ;

DROP TABLE IF EXISTS `org_app_log`;
CREATE TABLE `org_app_log` (
  `org` varchar(10) NOT NULL,
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `org` (`org`),
  KEY `app` (`app`),
  CONSTRAINT `org_app_log_ibfk_5` FOREIGN KEY (`org`) REFERENCES `org` (`id`),
  CONSTRAINT `org_app_log_ibfk_6` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `org_app_log` (`org`, `app`, `init`, `end`) VALUES
('chvie0f3m',   'xhuzy3eeg',    '2014-05-22 15:57:04',  '2014-05-22 15:58:04'),
('chvie0f3m',   'xhuzy3eeg',    '2014-05-22 15:59:23',  '2014-05-22 16:04:19'),
('chvie0f3m',   'xhuzy3eeg',    '2014-05-22 16:04:50',  '2014-05-22 16:05:31');

DROP TABLE IF EXISTS `page`;
CREATE TABLE `page` (
  `id` varchar(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `page` (`id`, `title`) VALUES
('admin',   'Administração'),
('home',    'Página Inicial'),
('user',    'Opções de Conta');

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` varchar(20) NOT NULL,
  `descr` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `role` (`id`, `descr`) VALUES
('admin',   'Admistrador Geral'),
('org.admin',   'Administrador'),
('org.user',    'Funcionário');

DROP TABLE IF EXISTS `role_action`;
CREATE TABLE `role_action` (
  `role` varchar(20) NOT NULL,
  `action` varchar(20) NOT NULL,
  PRIMARY KEY (`role`,`action`),
  KEY `action` (`action`),
  CONSTRAINT `role_action_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_action_ibfk_5` FOREIGN KEY (`action`) REFERENCES `action` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `role_action` (`role`, `action`) VALUES
('admin',   'app.create'),
('admin',   'app.get'),
('admin',   'app.list'),
('admin',   'app.off'),
('admin',   'app.on'),
('admin',   'org.app.off'),
('admin',   'org.app.on'),
('admin',   'org.app.user.off'),
('admin',   'org.app.user.on'),
('admin',   'org.create'),
('admin',   'org.get'),
('admin',   'org.list'),
('admin',   'org.off'),
('admin',   'org.on'),
('admin',   'org.user.admin.off'),
('admin',   'org.user.admin.on'),
('admin',   'org.user.get'),
('admin',   'org.user.list'),
('admin',   'org.user.off'),
('admin',   'org.user.on'),
('admin',   'user.admin.off'),
('admin',   'user.admin.on'),
('admin',   'user.create'),
('admin',   'user.get'),
('admin',   'user.list'),
('admin',   'user.off'),
('admin',   'user.on'),
('org.admin',   'org.app.user.off'),
('org.admin',   'org.app.user.on'),
('org.admin',   'org.user.admin.off'),
('org.admin',   'org.user.admin.on'),
('org.admin',   'org.user.get'),
('org.admin',   'org.user.list'),
('org.admin',   'org.user.off'),
('org.admin',   'org.user.on'),
('org.admin',   'user.create'),
('org.admin',   'user.on');

DROP TABLE IF EXISTS `role_page`;
CREATE TABLE `role_page` (
  `role` varchar(20) NOT NULL,
  `page` varchar(10) NOT NULL,
  PRIMARY KEY (`role`,`page`),
  KEY `page` (`page`),
  CONSTRAINT `role_page_ibfk_2` FOREIGN KEY (`page`) REFERENCES `page` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_page_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `role_page` (`role`, `page`) VALUES
('admin',   'admin'),
('org.admin',   'admin');

DROP TABLE IF EXISTS `role_user`;
CREATE TABLE `role_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(10) NOT NULL,
  `org` varchar(10) DEFAULT NULL,
  `role` varchar(20) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_org_role` (`user`,`org`,`role`),
  KEY `org` (`org`),
  KEY `user` (`user`),
  KEY `role` (`role`),
  CONSTRAINT `role_user_ibfk_1` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE,
  CONSTRAINT `role_user_ibfk_3` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE,
  CONSTRAINT `role_user_ibfk_4` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;

CREATE TRIGGER `after_delete_user_role` AFTER DELETE ON `role_user` FOR EACH ROW
BEGIN
        INSERT INTO active_user_log
            (user, init, end)
            VALUES (OLD.user, OLD.init, current_timestamp);
    END;;

DELIMITER ;

DROP TABLE IF EXISTS `role_user_log`;
CREATE TABLE `role_user_log` (
  `user` varchar(10) NOT NULL,
  `org` varchar(10) DEFAULT NULL,
  `role` varchar(20) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  UNIQUE KEY `user_org_role` (`user`,`org`,`role`),
  KEY `user` (`user`),
  KEY `role` (`role`),
  KEY `org` (`org`),
  CONSTRAINT `role_user_log_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `role_user_log_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`),
  CONSTRAINT `role_user_log_ibfk_4` FOREIGN KEY (`org`) REFERENCES `org` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `sid` varchar(32) NOT NULL,
  `creation` datetime NOT NULL,
  `expires` datetime NOT NULL,
  `user` varchar(10) DEFAULT NULL,
  `data` varchar(200) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sid`),
  KEY `user` (`user`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` varchar(10) NOT NULL,
  `short_name` varchar(10) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `avatar` varchar(100) DEFAULT NULL,
  `creation` datetime NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `short_name` (`short_name`),
  KEY `full_name` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;

CREATE TRIGGER `after_user_updates` AFTER UPDATE ON `user` FOR EACH ROW
BEGIN
        INSERT INTO user_log
            (id,short_name,full_name,avatar,password, timestamp)
            VALUES (OLD.id, OLD.short_name, OLD.full_name, OLD.avatar, OLD.password, current_timestamp);
    END;;

DELIMITER ;

DROP TABLE IF EXISTS `user_email`;
CREATE TABLE `user_email` (
  `user` varchar(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`email`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `user_email_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_log`;
CREATE TABLE `user_log` (
  `id` varchar(10) NOT NULL,
  `short_name` varchar(10) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `avatar` varchar(200) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `id` (`id`),
  CONSTRAINT `user_log_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_session`;
CREATE TABLE `user_session` (
  `user` varchar(10) NOT NULL,
  `session` varchar(32) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`),
  UNIQUE KEY `session` (`session`),
  CONSTRAINT `user_session_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_tel`;
CREATE TABLE `user_tel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(10) NOT NULL,
  `number` varchar(10) NOT NULL,
  `area` varchar(10) NOT NULL DEFAULT '21',
  `country` varchar(10) NOT NULL DEFAULT '55',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `country_area_number` (`country`,`area`,`number`),
  KEY `user` (`user`),
  CONSTRAINT `user_tel_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `active_email`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `active_email` AS select `user_email`.`email` AS `email`,`user`.`full_name` AS `full_name` from ((`active_user` join `user` on((`user`.`id` = `active_user`.`user`))) join `user_email` on((`user_email`.`user` = `active_user`.`user`)));

-- 2014-08-29 20:24:05