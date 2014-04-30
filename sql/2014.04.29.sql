-- MySQL dump 10.14  Distrib 5.5.36-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: acw
-- ------------------------------------------------------
-- Server version	5.5.36-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `id` varchar(20) NOT NULL,
  `descr` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action`
--

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` VALUES ('app.create','create app'),('app.off','disable app'),('app.on','enable app'),('org.app.off','disable app instance'),('org.app.on','enable app instance'),('org.app.user.off','disable access to organization app'),('org.app.user.on','enable access to organization app'),('org.create','create organization'),('org.off','disable organization'),('org.on','enable organization'),('org.user.admin.off','unset user as org.admin'),('org.user.admin.on','set user as org.admin'),('org.user.off','remove user from organization'),('org.user.on','add user to organization'),('user.admin.off','unset user as admin'),('user.admin.on','set user as admin'),('user.create','create user'),('user.off','disable user'),('user.on','enable user');
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_app`
--

DROP TABLE IF EXISTS `active_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_app` (
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`app`),
  CONSTRAINT `active_app_ibfk_1` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_app`
--

LOCK TABLES `active_app` WRITE;
/*!40000 ALTER TABLE `active_app` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_app` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_disable_app
    AFTER DELETE ON active_app FOR EACH ROW
    BEGIN
    	INSERT INTO active_app_log
	    	(app, init, end)
	    	VALUES (OLD.app, OLD.init, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `active_app_log`
--

DROP TABLE IF EXISTS `active_app_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_app_log` (
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `id` (`app`),
  CONSTRAINT `active_app_log_ibfk_1` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_app_log`
--

LOCK TABLES `active_app_log` WRITE;
/*!40000 ALTER TABLE `active_app_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_app_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_org`
--

DROP TABLE IF EXISTS `active_org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_org` (
  `org` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`org`),
  CONSTRAINT `active_org_ibfk_1` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_org`
--

LOCK TABLES `active_org` WRITE;
/*!40000 ALTER TABLE `active_org` DISABLE KEYS */;
INSERT INTO `active_org` VALUES ('newconnect','2014-04-29 14:40:33',NULL,'2014-04-29 17:40:33');
/*!40000 ALTER TABLE `active_org` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_disable_org
    AFTER DELETE ON active_org FOR EACH ROW
    BEGIN
    	INSERT INTO ative_org_log
	    	(org, init, end)
	    	VALUES (OLD.org, OLD.init, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `active_org_log`
--

DROP TABLE IF EXISTS `active_org_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_org_log` (
  `org` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `id` (`org`),
  CONSTRAINT `active_org_log_ibfk_1` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_org_log`
--

LOCK TABLES `active_org_log` WRITE;
/*!40000 ALTER TABLE `active_org_log` DISABLE KEYS */;
INSERT INTO `active_org_log` VALUES ('newconnect','2014-04-29 14:40:33','2014-04-29 14:40:33');
/*!40000 ALTER TABLE `active_org_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_user`
--

DROP TABLE IF EXISTS `active_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_user` (
  `user` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`),
  CONSTRAINT `active_user_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_user`
--

LOCK TABLES `active_user` WRITE;
/*!40000 ALTER TABLE `active_user` DISABLE KEYS */;
INSERT INTO `active_user` VALUES ('krbnc2n5da','2014-04-29 14:42:14',NULL,'2014-04-29 17:42:14');
/*!40000 ALTER TABLE `active_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_disable_user
    AFTER DELETE ON active_user FOR EACH ROW
    BEGIN
    	INSERT INTO active_user_log
    		(user, init, end)
    		VALUES (OLD.user, OLD.init, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `active_user_log`
--

DROP TABLE IF EXISTS `active_user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_user_log` (
  `user` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `id` (`user`),
  CONSTRAINT `active_user_log_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_user_log`
--

LOCK TABLES `active_user_log` WRITE;
/*!40000 ALTER TABLE `active_user_log` DISABLE KEYS */;
INSERT INTO `active_user_log` VALUES ('krbnc2n5da','2014-04-29 14:42:14','2014-04-29 14:42:14');
/*!40000 ALTER TABLE `active_user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app`
--

DROP TABLE IF EXISTS `app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app` (
  `id` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app`
--

LOCK TABLES `app` WRITE;
/*!40000 ALTER TABLE `app` DISABLE KEYS */;
INSERT INTO `app` VALUES ('GeCam','Gestão de Equipes de Campo',NULL);
/*!40000 ALTER TABLE `app` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_user`
--

DROP TABLE IF EXISTS `app_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  KEY `org_app` (`org_app`),
  KEY `user` (`user`),
  KEY `org` (`org`),
  KEY `app` (`app`),
  CONSTRAINT `app_user_ibfk_10` FOREIGN KEY (`org`) REFERENCES `org` (`id`),
  CONSTRAINT `app_user_ibfk_11` FOREIGN KEY (`app`) REFERENCES `app` (`id`),
  CONSTRAINT `app_user_ibfk_7` FOREIGN KEY (`org_app`) REFERENCES `org_app` (`id`) ON DELETE CASCADE,
  CONSTRAINT `app_user_ibfk_9` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_user`
--

LOCK TABLES `app_user` WRITE;
/*!40000 ALTER TABLE `app_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_delete_app_user
    AFTER DELETE ON app_user FOR EACH ROW
    BEGIN
    	INSERT INTO app_user_log
	    	(usr, org, app, init, end)
	    	VALUES (OLD.user, OLD.org, OLD.app, OLD.init, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `app_user_log`
--

DROP TABLE IF EXISTS `app_user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_user_log` (
  `user` varchar(10) NOT NULL,
  `org` varchar(10) DEFAULT NULL,
  `app` varchar(10) DEFAULT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `app` (`app`),
  KEY `org` (`org`),
  KEY `user` (`user`),
  CONSTRAINT `app_user_log_ibfk_3` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `app_user_log_ibfk_1` FOREIGN KEY (`app`) REFERENCES `app` (`id`),
  CONSTRAINT `app_user_log_ibfk_2` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_user_log`
--

LOCK TABLES `app_user_log` WRITE;
/*!40000 ALTER TABLE `app_user_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org`
--

DROP TABLE IF EXISTS `org`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org` (
  `id` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org`
--

LOCK TABLES `org` WRITE;
/*!40000 ALTER TABLE `org` DISABLE KEYS */;
INSERT INTO `org` VALUES ('newconnect','New Connect',NULL);
/*!40000 ALTER TABLE `org` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org_app`
--

DROP TABLE IF EXISTS `org_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org` varchar(10) NOT NULL,
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `org` (`org`),
  KEY `app` (`app`),
  CONSTRAINT `org_app_ibfk_10` FOREIGN KEY (`app`) REFERENCES `active_app` (`app`) ON DELETE CASCADE,
  CONSTRAINT `org_app_ibfk_9` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_app`
--

LOCK TABLES `org_app` WRITE;
/*!40000 ALTER TABLE `org_app` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_app` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.before_delete_org_app
    BEFORE DELETE ON org_app FOR EACH ROW
    BEGIN
    	UPDATE app_user 
    	set app_user.org = OLD.org AND app_user.app = OLD.app;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_delete_org_app
    AFTER DELETE ON org_app FOR EACH ROW
    BEGIN
    	INSERT INTO org_app_log
	    	(org, app, init, end)
	    	VALUES (OLD.org, OLD.app, OLD.init, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `org_app_log`
--

DROP TABLE IF EXISTS `org_app_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_app_log` (
  `org` varchar(10) NOT NULL,
  `app` varchar(10) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  KEY `org` (`org`),
  KEY `app` (`app`),
  CONSTRAINT `org_app_log_ibfk_2` FOREIGN KEY (`app`) REFERENCES `app` (`id`),
  CONSTRAINT `org_app_log_ibfk_1` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_app_log`
--

LOCK TABLES `org_app_log` WRITE;
/*!40000 ALTER TABLE `org_app_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_app_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page` (
  `id` varchar(10) NOT NULL,
  `title` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES ('admin','Administração'),('user','Opções de Conta');
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` varchar(20) NOT NULL,
  `descr` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('admin','Admistrador Geral'),('org.admin','Administrador de Organização'),('org.user','Funcionário da Empresa');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_action`
--

DROP TABLE IF EXISTS `role_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_action` (
  `role` varchar(20) NOT NULL,
  `action` varchar(20) NOT NULL,
  PRIMARY KEY (`role`,`action`),
  KEY `action` (`action`),
  CONSTRAINT `role_action_ibfk_5` FOREIGN KEY (`action`) REFERENCES `action` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_action_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_action`
--

LOCK TABLES `role_action` WRITE;
/*!40000 ALTER TABLE `role_action` DISABLE KEYS */;
INSERT INTO `role_action` VALUES ('admin','app.create'),('admin','app.off'),('admin','app.on'),('admin','org.app.off'),('admin','org.app.on'),('admin','org.app.user.off'),('admin','org.app.user.on'),('admin','org.create'),('admin','org.off'),('admin','org.on'),('admin','org.user.admin.off'),('admin','org.user.admin.on'),('admin','org.user.off'),('admin','org.user.on'),('admin','user.admin.off'),('admin','user.admin.on'),('admin','user.create'),('admin','user.off'),('admin','user.on'),('org.admin','org.app.user.off'),('org.admin','org.app.user.on'),('org.admin','org.user.off'),('org.admin','org.user.on'),('org.admin','user.create'),('org.admin','user.on');
/*!40000 ALTER TABLE `role_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_page`
--

DROP TABLE IF EXISTS `role_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_page` (
  `role` varchar(20) NOT NULL,
  `page` varchar(10) NOT NULL,
  PRIMARY KEY (`role`,`page`),
  KEY `page` (`page`),
  CONSTRAINT `role_page_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_page_ibfk_2` FOREIGN KEY (`page`) REFERENCES `page` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_page`
--

LOCK TABLES `role_page` WRITE;
/*!40000 ALTER TABLE `role_page` DISABLE KEYS */;
INSERT INTO `role_page` VALUES ('admin','admin'),('org.admin','admin');
/*!40000 ALTER TABLE `role_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_user`
--

DROP TABLE IF EXISTS `role_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user`
--

LOCK TABLES `role_user` WRITE;
/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` VALUES (2,'krbnc2n5da','newconnect','org.admin','2014-04-29 14:42:32',NULL,'2014-04-29 17:42:32'),(4,'krbnc2n5da',NULL,'admin','2014-04-29 18:07:45',NULL,'2014-04-29 21:07:45');
/*!40000 ALTER TABLE `role_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_delete_user_role
    AFTER DELETE ON role_user FOR EACH ROW
    BEGIN
    	INSERT INTO active_user_log
    		(user, init, end)
    		VALUES (OLD.user, OLD.init, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `role_user_log`
--

DROP TABLE IF EXISTS `role_user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_user_log` (
  `user` varchar(10) NOT NULL,
  `org` varchar(10) DEFAULT NULL,
  `role` varchar(20) NOT NULL,
  `init` datetime NOT NULL,
  `end` datetime NOT NULL,
  UNIQUE KEY `user_org_role` (`user`,`org`,`role`),
  KEY `user` (`user`),
  KEY `org` (`org`),
  KEY `role` (`role`),
  CONSTRAINT `role_user_log_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`),
  CONSTRAINT `role_user_log_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `role_user_log_ibfk_2` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user_log`
--

LOCK TABLES `role_user_log` WRITE;
/*!40000 ALTER TABLE `role_user_log` DISABLE KEYS */;
INSERT INTO `role_user_log` VALUES ('krbnc2n5da','newconnect','org.admin','2014-04-29 14:42:32','2014-04-29 14:42:32'),('krbnc2n5da',NULL,'admin','2014-04-29 18:07:45','2014-04-29 18:07:45');
/*!40000 ALTER TABLE `role_user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session`
--

DROP TABLE IF EXISTS `session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session`
--

LOCK TABLES `session` WRITE;
/*!40000 ALTER TABLE `session` DISABLE KEYS */;
INSERT INTO `session` VALUES ('2GngtGSoMOOR67aetq4BHYL5','2014-04-29 04:03:13','2014-04-30 04:03:13',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-04-30T07:03:13.488Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{}}','2014-04-29 07:03:13'),('43gLmzAoFdswd8tFKh8jFzUj','2014-04-29 04:20:13','2014-04-30 04:20:13',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-04-30T07:20:13.913Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{}}','2014-04-29 07:20:13'),('HMHvsHJBCVgqbU9CrWejcj0z','2014-04-29 16:57:16','2014-04-30 16:57:16',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-04-30T19:57:16.574Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-04-29 19:57:16'),('J4Gr5LyC1o6RhT38AKeg9mKW','2014-04-29 15:53:43','2014-04-30 21:26:49','krbnc2n5da','{\"cookie\":{\"originalMaxAge\":86399998,\"expires\":\"2014-05-01T00:26:49.508Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{\"user\":\"krbnc2n5da\"},\"flash\":{},\"user\":\"krbnc2n5da\"}','2014-04-30 00:26:49'),('ngG9RG9IuDIAFTwf1q5wHB9z','2014-04-29 14:44:57','2014-04-30 14:52:14',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-04-30T17:52:14.058Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"redirect_to\":\"/admin\",\"flash\":{\"error\":[\"Não foi possível verificar suas credenciai','2014-04-29 17:52:14'),('wQU2k07gXw73EKscy09aeTOH','2014-04-29 16:04:38','2014-04-30 16:04:38',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-04-30T19:04:38.948Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-04-29 19:04:38');
/*!40000 ALTER TABLE `session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('6irh2g0hua','Acácio','Acácio Neto',NULL,'2014-03-23 10:50:44',NULL,'2014-04-29 23:51:29'),('czlkd15v3s','Wagner','Wagner Silva',NULL,'2014-03-23 10:50:59',NULL,'2014-03-23 17:51:08'),('krbnc2n5da','Christian','Christian Amaral','hulrs7wi.jpg','2014-03-23 10:50:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 23:51:29');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER acw.after_user_updates
    AFTER UPDATE ON user FOR EACH ROW
    BEGIN
    	INSERT INTO user_log
    		(id,short_name,full_name,avatar,password, timestamp)
    		VALUES (OLD.id, OLD.short_name, OLD.full_name, OLD.avatar, OLD.password, current_timestamp);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_email`
--

DROP TABLE IF EXISTS `user_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_email` (
  `user` varchar(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user`,`email`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `user_email_ibfk_2` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_email`
--

LOCK TABLES `user_email` WRITE;
/*!40000 ALTER TABLE `user_email` DISABLE KEYS */;
INSERT INTO `user_email` VALUES ('6irh2g0hua','acaciomonteiro@gmail.com','2014-03-23 17:52:56'),('czlkd15v3s','wagnercmelosil@yahoo.com.br','2014-03-25 21:03:42'),('krbnc2n5da','christian.amaral@simtv.com.br','2014-04-25 20:55:36'),('krbnc2n5da','christianamaral@id.uff.br','2014-03-25 21:06:41'),('krbnc2n5da','darthcas@gmail.com','2014-03-25 21:03:42'),('krbnc2n5da','this.christian@yahoo.com','2014-03-25 21:06:44');
/*!40000 ALTER TABLE `user_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_log`
--

DROP TABLE IF EXISTS `user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_log`
--

LOCK TABLES `user_log` WRITE;
/*!40000 ALTER TABLE `user_log` DISABLE KEYS */;
INSERT INTO `user_log` VALUES ('krbnc2n5da','Christian','Christian Amaral','hufokyby.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:13:40'),('krbnc2n5da','Christian','Christian Amaral','hulr4qjo.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:31:55'),('krbnc2n5da','Christian','Christian Amaral','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:51:12'),('krbnc2n5da','Novo','Amaral dos Nomes','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:51:50'),('krbnc2n5da','Christian','Amaral','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:51:59');
/*!40000 ALTER TABLE `user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tel`
--

DROP TABLE IF EXISTS `user_tel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_tel`
--

LOCK TABLES `user_tel` WRITE;
/*!40000 ALTER TABLE `user_tel` DISABLE KEYS */;
INSERT INTO `user_tel` VALUES (2,'krbnc2n5da','997516519','21','55','2014-03-25 21:06:35');
/*!40000 ALTER TABLE `user_tel` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-04-29 22:19:10
