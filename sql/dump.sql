-- Adminer 4.1.0 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `acw` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `acw`;

DROP TABLE IF EXISTS `active_app`;
CREATE TABLE `active_app` (
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`app`),
  CONSTRAINT `active_app_ibfk_1` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `active_org`;
CREATE TABLE `active_org` (
  `org` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`org`),
  CONSTRAINT `active_org_ibfk_1` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `active_user`;
CREATE TABLE `active_user` (
  `user` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`),
  CONSTRAINT `active_user_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `active_user` (`user`, `init`, `timestamp`) VALUES
('krbnc2n5da',	current_timestamp,	current_timestamp);

DROP TABLE IF EXISTS `app`;
CREATE TABLE `app` (
  `id` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `app` (`id`, `name`) VALUES
('acw',	'Site do Projeto');

DROP TABLE IF EXISTS `org`;
CREATE TABLE `org` (
  `id` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `org_app`;
CREATE TABLE `org_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org` varchar(10) NOT NULL,
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `org` (`org`),
  KEY `app` (`app`),
  CONSTRAINT `org_app_ibfk_10` FOREIGN KEY (`app`) REFERENCES `active_app` (`app`) ON DELETE CASCADE,
  CONSTRAINT `org_app_ibfk_9` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `page`;
CREATE TABLE `page` (
  `id` varchar(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `page` (`id`, `title`) VALUES
('user',	'Opções de Conta');

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` varchar(10) NOT NULL,
  `descr` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `role` (`id`, `descr`) VALUES
('admin',	'Admistrador do Sistema');

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

INSERT INTO `session` (`sid`, `creation`, `expires`, `user`, `data`, `timestamp`) VALUES
('xQJcupLLGECyPeQn4rXF0OeF',	'2014-04-26 00:46:29',	'2014-04-27 00:54:04',	'krbnc2n5da',	'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-04-27T03:54:04.842Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{\"user\":\"krbnc2n5da\"},\"flash\":{},\"user\":\"krbnc2n5da\"}',	'2014-04-26 03:54:04');

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` varchar(10) NOT NULL,
  `short_name` varchar(10) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `avatar` varchar(200) DEFAULT NULL,
  `creation` datetime NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `user` (`id`, `short_name`, `full_name`, `avatar`, `creation`, `password`, `last_update`) VALUES
('6irh2g0hua',	'Acácio',	'Acácio Neto',	NULL,	'2014-03-23 10:50:03',	NULL,	'2014-03-23 17:50:03'),
('czlkd15v3s',	'Wagner',	'Wagner Silva',	NULL,	'2014-03-23 10:50:59',	NULL,	'2014-03-23 17:51:08'),
('krbnc2n5da',	'Christian',	'Christian Amaral',	'hufokyby.jpg',	'2014-03-23 10:50:44',	'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e',	'2014-04-25 16:15:40');

DROP TABLE IF EXISTS `user_app`;
CREATE TABLE `user_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(10) NOT NULL,
  `user_org` int(11) DEFAULT NULL,
  `org_app` int(11) DEFAULT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_org` (`user_org`),
  KEY `org_app` (`org_app`),
  KEY `user` (`user`),
  CONSTRAINT `user_app_ibfk_6` FOREIGN KEY (`user_org`) REFERENCES `user_org` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_app_ibfk_7` FOREIGN KEY (`org_app`) REFERENCES `org_app` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_app_ibfk_9` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_email`;
CREATE TABLE `user_email` (
  `user` varchar(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`email`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `user_email_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `user_email` (`user`, `email`, `timestamp`) VALUES
('6irh2g0hua',	'acaciomonteiro@gmail.com',	'2014-03-23 17:52:56'),
('czlkd15v3s',	'wagnercmelosil@yahoo.com.br',	'2014-03-25 21:03:42'),
('krbnc2n5da',	'christian.amaral@simtv.com.br',	'2014-04-25 20:55:36'),
('krbnc2n5da',	'christianamaral@id.uff.br',	'2014-03-25 21:06:41'),
('krbnc2n5da',	'darthcas@gmail.com',	'2014-03-25 21:03:42'),
('krbnc2n5da',	'this.christian@yahoo.com',	'2014-03-25 21:06:44');

DROP TABLE IF EXISTS `user_org`;
CREATE TABLE `user_org` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(10) NOT NULL,
  `org` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_org` (`user`,`org`),
  KEY `org` (`org`),
  CONSTRAINT `user_org_ibfk_12` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE,
  CONSTRAINT `user_org_ibfk_9` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(10) NOT NULL,
  `org` varchar(10) DEFAULT NULL,
  `role` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_org_role` (`user`,`org`,`role`),
  KEY `role` (`role`),
  KEY `org` (`org`),
  KEY `user` (`user`),
  CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE,
  CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_role_ibfk_3` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE
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

INSERT INTO `user_tel` (`id`, `user`, `number`, `area`, `country`, `timestamp`) VALUES
(2,	'krbnc2n5da',	'997516519',	'21',	'55',	'2014-03-25 21:06:35');

-- 2014-04-26 03:54:40