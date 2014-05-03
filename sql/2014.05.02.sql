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
INSERT INTO `active_user` VALUES ('6irh2g0hua','2014-05-02 14:00:44',NULL,'2014-05-02 17:00:44'),('ahuq5fmwb','2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('ahuq5fthd','2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('bhuq5ffow','2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('bhuq5fj9c','2014-05-02 21:05:03',NULL,'2014-05-03 00:05:23'),('bhuq5fkf5','2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('bhuq5fpdf','2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('bhuq5frun','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('chuq5fhbf','2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('chuq5fofz','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('czlkd15v3s','2014-05-02 14:00:33',NULL,'2014-05-02 17:00:33'),('dhuq5fowp','2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('dhuq5fr00','2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('dhuq5frxf','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('ehuq5fhs8','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('ehuq5fm7a','2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('ehuq5fqax','2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('ehuq5fs30','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('fhuq5fsv1','2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('ghuq5fkyn','2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('ghuq5fnza','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('ghuq5fo22','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('hhuq5fjex','2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('hhuq5ftmz','2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('ihuq5fhe9','2014-05-02 21:05:00',NULL,'2014-05-03 00:05:21'),('ihuq5fj6j','2014-05-02 21:05:03',NULL,'2014-05-03 00:05:23'),('ihuq5fozi','2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('ihuq5ftsk','2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('jhuq5fq5d','2014-05-02 21:05:12',NULL,'2014-05-03 00:05:28'),('jhuq5fqm3','2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('khuq5fi66','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('khuq5fl70','2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('khuq5fl9s','2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('khuq5flyw','2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('khuq5fmfn','2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('krbnc2n5da','2014-04-29 14:42:14',NULL,'2014-04-29 17:42:14'),('lhuq5ffgj','2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('lhuq5fg00','2014-05-02 21:04:58',NULL,'2014-05-03 00:05:18'),('lhuq5fgxi','2014-05-02 21:05:00',NULL,'2014-05-03 00:05:19'),('lhuq5fmqr','2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('lhuq5fn1v','2014-05-02 21:05:08',NULL,'2014-05-03 00:05:26'),('lhuq5fr8e','2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('mhuq5feal','2014-05-02 21:04:56',NULL,'2014-05-03 00:05:16'),('mhuq5fihe','2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('mhuq5fjna','2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('mhuq5fq85','2014-05-02 21:05:12',NULL,'2014-05-03 00:05:28'),('mhuq5frji','2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('nhuq5fjhp','2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('nhuq5flkz','2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('nhuq5fsbf','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('nhuq5ft0l','2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('ohuq5feu5','2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('ohuq5fl48','2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('ohuq5fnlc','2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('ohuq5fo4u','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('ohuq5fquf','2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('ohuq5fs5s','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('ohuq5ft3d','2014-05-02 21:05:15',NULL,'2014-05-03 00:05:31'),('phuq5fk18','2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('phuq5fmz3','2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('phuq5fnfs','2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('phuq5fr2t','2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('qhuq5fhmo','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('qhuq5fplu','2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('rhuq5fedd','2014-05-02 21:04:56',NULL,'2014-05-03 00:05:16'),('rhuq5fh32','2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('rhuq5fhxs','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('rhuq5fibs','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:23'),('rhuq5fnd0','2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('rhuq5fnwh','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('rhuq5ft65','2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('shuq5fezs','2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('shuq5fhjv','2014-05-02 21:05:00',NULL,'2014-05-03 00:05:21'),('thuq5fivd','2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('uhuq5fi0l','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('uhuq5fmcv','2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('uhuq5fpwz','2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('uhuq5fpzs','2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('vhuq5ffjb','2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('vhuq5fgry','2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('vhuq5fknh','2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('vhuq5flfc','2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('vhuq5fmif','2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('vhuq5fp2a','2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('whuq5ferd','2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('whuq5foae','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('whuq5ftps','2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('xhuq5fois','2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('xhuq5fs8l','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('xhuq5ftk6','2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('yhuq5fhpg','2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('yhuq5fkhx','2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('zhuq5fgmd','2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('zhuq5fh0a','2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('zhuq5fisl','2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('zhuq5folk','2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('zhuq5frrv','2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30');
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
INSERT INTO `active_user_log` VALUES ('krbnc2n5da','2014-04-29 14:42:14','2014-04-29 14:42:14'),('krbnc2n5da','2014-04-29 18:07:45','2014-04-30 20:12:28');
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
INSERT INTO `page` VALUES ('admin','Administração'),('home','Página Inicial'),('user','Opções de Conta');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user`
--

LOCK TABLES `role_user` WRITE;
/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` VALUES (2,'krbnc2n5da','newconnect','org.admin','2014-04-29 14:42:32',NULL,'2014-04-29 17:42:32'),(5,'krbnc2n5da',NULL,'admin','2014-04-30 20:13:58',NULL,'2014-04-30 23:13:58');
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
INSERT INTO `session` VALUES ('3IRFIGcvYP2UbBaYXaxjYYEX','2014-05-02 04:17:49','2014-05-03 04:17:49',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-05-03T07:17:49.271Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-05-02 07:17:49'),('EynUSHQDXKzz1Xr9cDQHKmIP','2014-05-02 17:41:59','2014-05-03 17:41:59',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-05-03T20:41:59.262Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-05-02 20:41:59'),('HGVsygslaGcybS9n60J3w03u','2014-05-02 17:32:42','2014-05-03 17:32:42',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-05-03T20:32:42.093Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-05-02 20:32:42'),('lEXjFSGB87kdPnQZpKDxmngO','2014-05-01 16:57:36','2014-05-03 21:05:34','krbnc2n5da','{\"cookie\":{\"originalMaxAge\":86399994,\"expires\":\"2014-05-04T00:05:34.808Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{\"user\":\"krbnc2n5da\"},\"flash\":{},\"user\":\"krbnc2n5da\"}','2014-05-03 00:05:34'),('OFQ4jlBnJmG2qwdmZ1NruhHJ','2014-05-02 04:03:20','2014-05-03 04:03:20',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-05-03T07:03:20.401Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-05-02 07:03:20'),('qKH2qyz0IR2EJHfzN4fJSXqq','2014-05-02 16:05:26','2014-05-03 16:05:26',NULL,'{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2014-05-03T19:05:26.602Z\",\"httpOnly\":true,\"path\":\"/\"},\"passport\":{},\"flash\":{}}','2014-05-02 19:05:26');
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
  PRIMARY KEY (`id`),
  KEY `short_name` (`short_name`),
  KEY `full_name` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('6irh2g0hua','Acácio','Acácio Neto',NULL,'2014-03-23 10:50:44',NULL,'2014-04-29 23:51:29'),('ahuq5feoj','Bernardo','Bernardo Cavalcante',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('ahuq5fi90','Gabriel','Gabriel Ferreira',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('ahuq5fkvv','Guilherme','Guilherme Correia',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('ahuq5flw4','Arthur','Arthur Pereira',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('ahuq5fm4h','Manuela','Manuela Cavalcante',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('ahuq5fmwb','Julia','Julia Almeida',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('ahuq5frdy','Pedro','Pedro Souza',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('ahuq5fthd','Davi','Davi Cavalcante',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('bhuq5ffow','Manuela','Manuela Souza',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('bhuq5fggs','Matheus','Matheus Souza',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('bhuq5fj0y','Beatriz','Beatriz Rocha',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('bhuq5fj9c','Alice','Alice Correia',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:23'),('bhuq5fkf5','Manuela','Manuela Martins',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('bhuq5fpdf','Laura','Laura Fernandes',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('bhuq5frun','Maria Edua','Maria Eduarda Dias',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('chuq5ff2k','Isabella','Isabella Dias',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('chuq5fg2u','Arthur','Arthur Costa',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:18'),('chuq5fge0','Valentina','Valentina Teixeira',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('chuq5fhbf','Matheus','Matheus Costa',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('chuq5fofz','Giovanna','Giovanna Almeida',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('chuq5fsgz','Bernardo','Bernardo Santos',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('czlkd15v3s','Wagner','Wagner Silva',NULL,'2014-03-23 10:50:59',NULL,'2014-03-23 17:51:08'),('dhuq5fgb8','Valentina','Valentina Correia',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('dhuq5fkqa','Gabriel','Gabriel Melo',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:24'),('dhuq5fowp','Laura','Laura Gonçalves',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('dhuq5fp52','Maria Edua','Maria Eduarda Melo',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('dhuq5fpj1','Sophia','Sophia Martins',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('dhuq5fr00','Laura','Laura Montes',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('dhuq5frxf','Gabriel','Gabriel Almeida',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('ehuq5fhs8','Alice','Alice Gomes',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('ehuq5fi3e','Bernardo','Bernardo Azevedo',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('ehuq5flck','Pedro','Pedro Alves',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('ehuq5fm7a','Isabella','Isabella Dias',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('ehuq5fna8','Isabella','Isabella Almeida',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:26'),('ehuq5fod6','Bernardo','Bernardo Martins',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('ehuq5fqax','Isabella','Isabella Correia',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:28'),('ehuq5fs30','Valentina','Valentina Gomes',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('ehuq5fss7','Julia','Julia Teixeira',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('fhuq5fg8f','Maria Edua','Maria Eduarda Cardoso',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('fhuq5flqj','Julia','Julia Melo',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('fhuq5fmnz','Isabella','Isabella Gonçalves',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('fhuq5fn7g','Valentina','Valentina Alves',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:26'),('fhuq5frgq','Maria Edua','Maria Eduarda Schmitz',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('fhuq5fsv1','Julia','Julia Souza',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('ghuq5fiem','Valentina','Valentina Carvalho',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('ghuq5fkyn','Sophia','Sophia Teixeira',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('ghuq5fnik','Lucas','Lucas Carvalho',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('ghuq5fnza','Laura','Laura Carvalho',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('ghuq5fo22','Beatriz','Beatriz Carvalho',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('ghuq5fpon','Valentina','Valentina Silva',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('hhuq5feix','Laura','Laura Dias',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('hhuq5fjex','Arthur','Arthur Lima',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('hhuq5for5','Beatriz','Beatriz Almeida',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('hhuq5frb6','Maria Edua','Maria Eduarda Silva',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('hhuq5ftmz','Maria Edua','Maria Eduarda Gomes',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('ihuq5fhe9','Alice','Alice Oliveira',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:21'),('ihuq5fiy6','Manuela','Manuela Azevedo',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('ihuq5fj6j','Guilherme','Guilherme Costa',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:23'),('ihuq5fjvn','Guilherme','Guilherme Araújo',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('ihuq5fk41','Bernardo','Bernardo Correia',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('ihuq5fozi','Beatriz','Beatriz Martins',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('ihuq5ftsk','Guilherme','Guilherme Gonçalves',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('jhuq5ffm4','Pedro','Pedro Costa',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('jhuq5fg5n','Laura','Laura Araújo',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:18'),('jhuq5fgp5','Giovanna','Giovanna Pereira',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('jhuq5fnqx','Giovanna','Giovanna Silva',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('jhuq5fq5d','Gabriel','Gabriel Barbosa',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:28'),('jhuq5fqm3','Miguel','Miguel Alves',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('jhuq5fqov','Beatriz','Beatriz Montes',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('jhuq5frp3','Sophia','Sophia Alves',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:29'),('jhuq5fsml','Davi','Davi Gomes',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('khuq5fi66','Matheus','Matheus Cavalcante',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('khuq5fjyg','Bernardo','Bernardo Melo',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('khuq5fl70','Alice','Alice Ribeiro',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('khuq5fl9s','Matheus','Matheus Martins',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('khuq5fli6','Rafael','Rafael Gomes',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('khuq5flyw','Isabella','Isabella Pereira',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('khuq5fmfn','Miguel','Miguel Cardoso',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('krbnc2n5da','Christian','Christian Amaral','hulrs7wi.jpg','2014-03-23 10:50:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 23:51:29'),('lhuq5ff5d','Guilherme','Guilherme Araújo',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('lhuq5ffay','Manuela','Manuela Silva',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('lhuq5ffgj','Isabella','Isabella Silva',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('lhuq5ffug','Valentina','Valentina Dias',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:18'),('lhuq5fg00','Arthur','Arthur Gomes',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:18'),('lhuq5fgxi','Matheus','Matheus Almeida',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:19'),('lhuq5flnr','Sophia','Sophia Dias',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('lhuq5fml7','Rafael','Rafael Rodrigues',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('lhuq5fmqr','Julia','Julia Ribeiro',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('lhuq5fn1v','Sophia','Sophia Pereira',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:26'),('lhuq5fr8e','Manuela','Manuela Fernandes',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('mhuq5feal','Arthur','Arthur Carvalho',NULL,'2014-05-02 21:04:56',NULL,'2014-05-03 00:05:16'),('mhuq5ff85','Isabella','Isabella Almeida',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('mhuq5fihe','Beatriz','Beatriz Morais',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('mhuq5fjna','Alice','Alice Rocha',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('mhuq5fltb','Laura','Laura Schmitz',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('mhuq5fq85','Davi','Davi Ferreira',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:28'),('mhuq5fqgh','Beatriz','Beatriz Ribeiro',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('mhuq5fqrn','Beatriz','Beatriz Pereira',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('mhuq5frji','Julia','Julia Alves',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('mhuq5fsxt','Guilherme','Guilherme Cardoso',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('nhuq5felr','Manuela','Manuela Schmitz',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('nhuq5ffro','Julia','Julia Silva',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('nhuq5fipt','Julia','Julia Azevedo',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('nhuq5fjhp','Beatriz','Beatriz Cavalcante',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('nhuq5fk9l','Gabriel','Gabriel Gonçalves',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('nhuq5flkz','Davi','Davi Gonçalves',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('nhuq5fsbf','Maria Edua','Maria Eduarda Schmitz',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('nhuq5ft0l','Guilherme','Guilherme Azevedo',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('ohuq5feu5','Davi','Davi Costa',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('ohuq5fj3r','Valentina','Valentina Silva',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('ohuq5fl48','Pedro','Pedro Almeida',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('ohuq5fn4n','Guilherme','Guilherme Melo',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:26'),('ohuq5fnlc','Julia','Julia Alves',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('ohuq5fo4u','Matheus','Matheus Cavalcante',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('ohuq5fp7v','Manuela','Manuela Ferreira',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('ohuq5fqjb','Gabriel','Gabriel Costa',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('ohuq5fquf','Matheus','Matheus Silva',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('ohuq5fs5s','Laura','Laura Melo',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('ohuq5fsjt','Rafael','Rafael Araújo',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('ohuq5ft3d','Rafael','Rafael Carvalho',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('phuq5ffdq','Arthur','Arthur Morais',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('phuq5fjkh','Guilherme','Guilherme Souza',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('phuq5fk18','Rafael','Rafael Schmitz',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('phuq5fmz3','Lucas','Lucas Oliveira',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('phuq5fnfs','Rafael','Rafael Teixeira',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('phuq5fntp','Matheus','Matheus Costa',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('phuq5fpg9','Lucas','Lucas Oliveira',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('phuq5fq2k','Bernardo','Bernardo Melo',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('phuq5fr2t','Rafael','Rafael Santos',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('qhuq5fguq','Manuela','Manuela Oliveira',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:19'),('qhuq5fhmo','Matheus','Matheus Cavalcante',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:21'),('qhuq5fmtj','Gabriel','Gabriel Souza',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('qhuq5food','Guilherme','Guilherme Alves',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('qhuq5fpan','Matheus','Matheus Rodrigues',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('qhuq5fplu','Beatriz','Beatriz Correia',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('qhuq5fr5l','Julia','Julia Oliveira',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('rhuq5fedd','Lucas','Lucas Dias',NULL,'2014-05-02 21:04:56',NULL,'2014-05-03 00:05:16'),('rhuq5ffx8','Arthur','Arthur Gonçalves',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:18'),('rhuq5fh32','Rafael','Rafael Correia',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('rhuq5fhxs','Matheus','Matheus Cavalcante',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('rhuq5fibs','Isabella','Isabella Carvalho',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('rhuq5fkkp','Julia','Julia Araújo',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('rhuq5fm1p','Alice','Alice Barbosa',NULL,'2014-05-02 21:05:06',NULL,'2014-05-03 00:05:25'),('rhuq5fnd0','Gabriel','Gabriel Lima',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('rhuq5fno5','Laura','Laura Lima',NULL,'2014-05-02 21:05:08',NULL,'2014-05-03 00:05:27'),('rhuq5fnwh','Arthur','Arthur Ribeiro',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('rhuq5fotx','Maria Edua','Maria Eduarda Dias',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('rhuq5fqx8','Sophia','Sophia Carvalho',NULL,'2014-05-02 21:05:13',NULL,'2014-05-03 00:05:29'),('rhuq5fs08','Maria Edua','Maria Eduarda Teixeira',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('rhuq5fse7','Matheus','Matheus Souza',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('rhuq5fspf','Davi','Davi Correia',NULL,'2014-05-02 21:05:15',NULL,'2014-05-03 00:05:30'),('rhuq5ft65','Giovanna','Giovanna Alves',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('shuq5fezs','Guilherme','Guilherme Costa',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('shuq5fhjv','Maria Edua','Maria Eduarda Alves',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:21'),('shuq5fhv0','Arthur','Arthur Dias',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('thuq5feg5','Beatriz','Beatriz Teixeira',NULL,'2014-05-02 21:04:56',NULL,'2014-05-03 00:05:16'),('thuq5fh8n','Lucas','Lucas Souza',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('thuq5fivd','Bernardo','Bernardo Gomes',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('thuq5fl1f','Isabella','Isabella Barbosa',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('thuq5frma','Maria Edua','Maria Eduarda Rocha',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:29'),('thuq5ftek','Manuela','Manuela Montes',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('uhuq5fi0l','Bernardo','Bernardo Silva',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('uhuq5fjq2','Maria Edua','Maria Eduarda Cardoso',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('uhuq5fmcv','Beatriz','Beatriz Dias',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('uhuq5fpwz','Miguel','Miguel Melo',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('uhuq5fpzs','Sophia','Sophia Gonçalves',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('uhuq5ftbr','Giovanna','Giovanna Lima',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('vhuq5fewz','Davi','Davi Rodrigues',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('vhuq5ffjb','Manuela','Manuela Almeida',NULL,'2014-05-02 21:04:58',NULL,'2014-05-03 00:05:17'),('vhuq5fgjk','Gabriel','Gabriel Rodrigues',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('vhuq5fgry','Lucas','Lucas Teixeira',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('vhuq5fik8','Giovanna','Giovanna Rocha',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('vhuq5fk6t','Arthur','Arthur Rocha',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('vhuq5fkcd','Giovanna','Giovanna Teixeira',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('vhuq5fknh','Laura','Laura Cardoso',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('vhuq5flfc','Bernardo','Bernardo Gonçalves',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:25'),('vhuq5fmif','Guilherme','Guilherme Carvalho',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:26'),('vhuq5fo7m','Davi','Davi Montes',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('vhuq5fp2a','Valentina','Valentina Almeida',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:28'),('vhuq5fprf','Valentina','Valentina Montes',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('vhuq5fpu7','Miguel','Miguel Ribeiro',NULL,'2014-05-02 21:05:11',NULL,'2014-05-03 00:05:28'),('whuq5ferd','Davi','Davi Cavalcante',NULL,'2014-05-02 21:04:57',NULL,'2014-05-03 00:05:17'),('whuq5foae','Miguel','Miguel Costa',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('whuq5ftps','Julia','Julia Azevedo',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('xhuq5fois','Matheus','Matheus Lima',NULL,'2014-05-02 21:05:09',NULL,'2014-05-03 00:05:27'),('xhuq5fs8l','Laura','Laura Melo',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('xhuq5ftk6','Gabriel','Gabriel Schmitz',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31'),('yhuq5fhh2','Sophia','Sophia Morais',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:21'),('yhuq5fhpg','Guilherme','Guilherme Carvalho',NULL,'2014-05-02 21:05:01',NULL,'2014-05-03 00:05:22'),('yhuq5fjsv','Alice','Alice Correia',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:24'),('yhuq5fkhx','Gabriel','Gabriel Gomes',NULL,'2014-05-02 21:05:04',NULL,'2014-05-03 00:05:24'),('yhuq5fkt2','Miguel','Miguel Cavalcante',NULL,'2014-05-02 21:05:05',NULL,'2014-05-03 00:05:24'),('yhuq5fma3','Guilherme','Guilherme Gonçalves',NULL,'2014-05-02 21:05:07',NULL,'2014-05-03 00:05:25'),('zhuq5fgmd','Sophia','Sophia Silva',NULL,'2014-05-02 21:04:59',NULL,'2014-05-03 00:05:19'),('zhuq5fh0a','Miguel','Miguel Oliveira',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:19'),('zhuq5fh5u','Guilherme','Guilherme Costa',NULL,'2014-05-02 21:05:00',NULL,'2014-05-03 00:05:20'),('zhuq5fin1','Guilherme','Guilherme Cavalcante',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('zhuq5fisl','Alice','Alice Martins',NULL,'2014-05-02 21:05:02',NULL,'2014-05-03 00:05:23'),('zhuq5fjc4','Alice','Alice Silva',NULL,'2014-05-02 21:05:03',NULL,'2014-05-03 00:05:23'),('zhuq5folk','Matheus','Matheus Montes',NULL,'2014-05-02 21:05:10',NULL,'2014-05-03 00:05:27'),('zhuq5fqdp','Julia','Julia Cavalcante',NULL,'2014-05-02 21:05:12',NULL,'2014-05-03 00:05:29'),('zhuq5frrv','Lucas','Lucas Martins',NULL,'2014-05-02 21:05:14',NULL,'2014-05-03 00:05:30'),('zhuq5ft8y','Bernardo','Bernardo Silva',NULL,'2014-05-02 21:05:16',NULL,'2014-05-03 00:05:31');
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
INSERT INTO `user_email` VALUES ('6irh2g0hua','acaciomonteiro@gmail.com','2014-03-23 17:52:56'),('ahuq5feoj','bernardo.ahuq5feoj@gmail.com','2014-05-03 00:05:17'),('ahuq5fi90','gabriel.ahuq5fi90@gmail.com','2014-05-03 00:05:22'),('ahuq5fkvv','guilherme.ahuq5fkvv@gmail.com','2014-05-03 00:05:25'),('ahuq5flw4','arthur.ahuq5flw4@gmail.com','2014-05-03 00:05:25'),('ahuq5fm4h','manuela.ahuq5fm4h@gmail.com','2014-05-03 00:05:25'),('ahuq5fmwb','julia.ahuq5fmwb@gmail.com','2014-05-03 00:05:26'),('ahuq5frdy','pedro.ahuq5frdy@gmail.com','2014-05-03 00:05:29'),('ahuq5fthd','davi.ahuq5fthd@gmail.com','2014-05-03 00:05:31'),('bhuq5ffow','manuela.bhuq5ffow@gmail.com','2014-05-03 00:05:17'),('bhuq5fggs','matheus.bhuq5fggs@gmail.com','2014-05-03 00:05:19'),('bhuq5fj0y','beatriz.bhuq5fj0y@gmail.com','2014-05-03 00:05:23'),('bhuq5fj9c','alice.bhuq5fj9c@gmail.com','2014-05-03 00:05:23'),('bhuq5fkf5','manuela.bhuq5fkf5@gmail.com','2014-05-03 00:05:24'),('bhuq5fpdf','laura.bhuq5fpdf@gmail.com','2014-05-03 00:05:28'),('bhuq5frun','maria eduarda.bhuq5frun@gmail.com','2014-05-03 00:05:30'),('chuq5ff2k','isabella.chuq5ff2k@gmail.com','2014-05-03 00:05:17'),('chuq5fg2u','arthur.chuq5fg2u@gmail.com','2014-05-03 00:05:18'),('chuq5fge0','valentina.chuq5fge0@gmail.com','2014-05-03 00:05:19'),('chuq5fhbf','matheus.chuq5fhbf@gmail.com','2014-05-03 00:05:20'),('chuq5fofz','giovanna.chuq5fofz@gmail.com','2014-05-03 00:05:27'),('chuq5fsgz','bernardo.chuq5fsgz@gmail.com','2014-05-03 00:05:30'),('czlkd15v3s','wagnercmelosil@yahoo.com.br','2014-03-25 21:03:42'),('dhuq5fgb8','valentina.dhuq5fgb8@gmail.com','2014-05-03 00:05:19'),('dhuq5fkqa','gabriel.dhuq5fkqa@gmail.com','2014-05-03 00:05:24'),('dhuq5fowp','laura.dhuq5fowp@gmail.com','2014-05-03 00:05:27'),('dhuq5fp52','maria eduarda.dhuq5fp52@gmail.com','2014-05-03 00:05:28'),('dhuq5fpj1','sophia.dhuq5fpj1@gmail.com','2014-05-03 00:05:28'),('dhuq5fr00','laura.dhuq5fr00@gmail.com','2014-05-03 00:05:29'),('dhuq5frxf','gabriel.dhuq5frxf@gmail.com','2014-05-03 00:05:30'),('ehuq5fhs8','alice.ehuq5fhs8@gmail.com','2014-05-03 00:05:22'),('ehuq5fi3e','bernardo.ehuq5fi3e@gmail.com','2014-05-03 00:05:22'),('ehuq5flck','pedro.ehuq5flck@gmail.com','2014-05-03 00:05:25'),('ehuq5fm7a','isabella.ehuq5fm7a@gmail.com','2014-05-03 00:05:25'),('ehuq5fna8','isabella.ehuq5fna8@gmail.com','2014-05-03 00:05:26'),('ehuq5fod6','bernardo.ehuq5fod6@gmail.com','2014-05-03 00:05:27'),('ehuq5fqax','isabella.ehuq5fqax@gmail.com','2014-05-03 00:05:29'),('ehuq5fs30','valentina.ehuq5fs30@gmail.com','2014-05-03 00:05:30'),('ehuq5fss7','julia.ehuq5fss7@gmail.com','2014-05-03 00:05:30'),('fhuq5fg8f','maria eduarda.fhuq5fg8f@gmail.com','2014-05-03 00:05:19'),('fhuq5flqj','julia.fhuq5flqj@gmail.com','2014-05-03 00:05:25'),('fhuq5fmnz','isabella.fhuq5fmnz@gmail.com','2014-05-03 00:05:26'),('fhuq5fn7g','valentina.fhuq5fn7g@gmail.com','2014-05-03 00:05:26'),('fhuq5frgq','maria eduarda.fhuq5frgq@gmail.com','2014-05-03 00:05:29'),('fhuq5fsv1','julia.fhuq5fsv1@gmail.com','2014-05-03 00:05:30'),('ghuq5fiem','valentina.ghuq5fiem@gmail.com','2014-05-03 00:05:23'),('ghuq5fkyn','sophia.ghuq5fkyn@gmail.com','2014-05-03 00:05:25'),('ghuq5fnik','lucas.ghuq5fnik@gmail.com','2014-05-03 00:05:27'),('ghuq5fnza','laura.ghuq5fnza@gmail.com','2014-05-03 00:05:27'),('ghuq5fo22','beatriz.ghuq5fo22@gmail.com','2014-05-03 00:05:27'),('ghuq5fpon','valentina.ghuq5fpon@gmail.com','2014-05-03 00:05:28'),('hhuq5feix','laura.hhuq5feix@gmail.com','2014-05-03 00:05:17'),('hhuq5fjex','arthur.hhuq5fjex@gmail.com','2014-05-03 00:05:24'),('hhuq5for5','beatriz.hhuq5for5@gmail.com','2014-05-03 00:05:27'),('hhuq5frb6','maria eduarda.hhuq5frb6@gmail.com','2014-05-03 00:05:29'),('hhuq5ftmz','maria eduarda.hhuq5ftmz@gmail.com','2014-05-03 00:05:31'),('ihuq5fhe9','alice.ihuq5fhe9@gmail.com','2014-05-03 00:05:21'),('ihuq5fiy6','manuela.ihuq5fiy6@gmail.com','2014-05-03 00:05:23'),('ihuq5fj6j','guilherme.ihuq5fj6j@gmail.com','2014-05-03 00:05:23'),('ihuq5fjvn','guilherme.ihuq5fjvn@gmail.com','2014-05-03 00:05:24'),('ihuq5fk41','bernardo.ihuq5fk41@gmail.com','2014-05-03 00:05:24'),('ihuq5fozi','beatriz.ihuq5fozi@gmail.com','2014-05-03 00:05:28'),('ihuq5ftsk','guilherme.ihuq5ftsk@gmail.com','2014-05-03 00:05:31'),('jhuq5ffm4','pedro.jhuq5ffm4@gmail.com','2014-05-03 00:05:17'),('jhuq5fg5n','laura.jhuq5fg5n@gmail.com','2014-05-03 00:05:18'),('jhuq5fgp5','giovanna.jhuq5fgp5@gmail.com','2014-05-03 00:05:19'),('jhuq5fnqx','giovanna.jhuq5fnqx@gmail.com','2014-05-03 00:05:27'),('jhuq5fq5d','gabriel.jhuq5fq5d@gmail.com','2014-05-03 00:05:28'),('jhuq5fqm3','miguel.jhuq5fqm3@gmail.com','2014-05-03 00:05:29'),('jhuq5fqov','beatriz.jhuq5fqov@gmail.com','2014-05-03 00:05:29'),('jhuq5frp3','sophia.jhuq5frp3@gmail.com','2014-05-03 00:05:30'),('jhuq5fsml','davi.jhuq5fsml@gmail.com','2014-05-03 00:05:30'),('khuq5fi66','matheus.khuq5fi66@gmail.com','2014-05-03 00:05:22'),('khuq5fjyg','bernardo.khuq5fjyg@gmail.com','2014-05-03 00:05:24'),('khuq5fl70','alice.khuq5fl70@gmail.com','2014-05-03 00:05:25'),('khuq5fl9s','matheus.khuq5fl9s@gmail.com','2014-05-03 00:05:25'),('khuq5fli6','rafael.khuq5fli6@gmail.com','2014-05-03 00:05:25'),('khuq5flyw','isabella.khuq5flyw@gmail.com','2014-05-03 00:05:25'),('khuq5fmfn','miguel.khuq5fmfn@gmail.com','2014-05-03 00:05:26'),('krbnc2n5da','christian.amaral@simtv.com.br','2014-04-25 20:55:36'),('krbnc2n5da','christianamaral@id.uff.br','2014-03-25 21:06:41'),('krbnc2n5da','darthcas@gmail.com','2014-03-25 21:03:42'),('krbnc2n5da','this.christian@yahoo.com','2014-03-25 21:06:44'),('lhuq5ff5d','guilherme.lhuq5ff5d@gmail.com','2014-05-03 00:05:17'),('lhuq5ffay','manuela.lhuq5ffay@gmail.com','2014-05-03 00:05:17'),('lhuq5ffgj','isabella.lhuq5ffgj@gmail.com','2014-05-03 00:05:17'),('lhuq5ffug','valentina.lhuq5ffug@gmail.com','2014-05-03 00:05:18'),('lhuq5fg00','arthur.lhuq5fg00@gmail.com','2014-05-03 00:05:18'),('lhuq5fgxi','matheus.lhuq5fgxi@gmail.com','2014-05-03 00:05:19'),('lhuq5flnr','sophia.lhuq5flnr@gmail.com','2014-05-03 00:05:25'),('lhuq5fml7','rafael.lhuq5fml7@gmail.com','2014-05-03 00:05:26'),('lhuq5fmqr','julia.lhuq5fmqr@gmail.com','2014-05-03 00:05:26'),('lhuq5fn1v','sophia.lhuq5fn1v@gmail.com','2014-05-03 00:05:26'),('lhuq5fr8e','manuela.lhuq5fr8e@gmail.com','2014-05-03 00:05:29'),('mhuq5feal','arthur.mhuq5feal@gmail.com','2014-05-03 00:05:16'),('mhuq5ff85','isabella.mhuq5ff85@gmail.com','2014-05-03 00:05:17'),('mhuq5fihe','beatriz.mhuq5fihe@gmail.com','2014-05-03 00:05:23'),('mhuq5fjna','alice.mhuq5fjna@gmail.com','2014-05-03 00:05:24'),('mhuq5fltb','laura.mhuq5fltb@gmail.com','2014-05-03 00:05:25'),('mhuq5fq85','davi.mhuq5fq85@gmail.com','2014-05-03 00:05:28'),('mhuq5fqgh','beatriz.mhuq5fqgh@gmail.com','2014-05-03 00:05:29'),('mhuq5fqrn','beatriz.mhuq5fqrn@gmail.com','2014-05-03 00:05:29'),('mhuq5frji','julia.mhuq5frji@gmail.com','2014-05-03 00:05:29'),('mhuq5fsxt','guilherme.mhuq5fsxt@gmail.com','2014-05-03 00:05:30'),('nhuq5felr','manuela.nhuq5felr@gmail.com','2014-05-03 00:05:17'),('nhuq5ffro','julia.nhuq5ffro@gmail.com','2014-05-03 00:05:18'),('nhuq5fipt','julia.nhuq5fipt@gmail.com','2014-05-03 00:05:23'),('nhuq5fjhp','beatriz.nhuq5fjhp@gmail.com','2014-05-03 00:05:24'),('nhuq5fk9l','gabriel.nhuq5fk9l@gmail.com','2014-05-03 00:05:24'),('nhuq5flkz','davi.nhuq5flkz@gmail.com','2014-05-03 00:05:25'),('nhuq5fsbf','maria eduarda.nhuq5fsbf@gmail.com','2014-05-03 00:05:30'),('nhuq5ft0l','guilherme.nhuq5ft0l@gmail.com','2014-05-03 00:05:30'),('ohuq5feu5','davi.ohuq5feu5@gmail.com','2014-05-03 00:05:17'),('ohuq5fj3r','valentina.ohuq5fj3r@gmail.com','2014-05-03 00:05:23'),('ohuq5fl48','pedro.ohuq5fl48@gmail.com','2014-05-03 00:05:25'),('ohuq5fn4n','guilherme.ohuq5fn4n@gmail.com','2014-05-03 00:05:26'),('ohuq5fnlc','julia.ohuq5fnlc@gmail.com','2014-05-03 00:05:27'),('ohuq5fo4u','matheus.ohuq5fo4u@gmail.com','2014-05-03 00:05:27'),('ohuq5fp7v','manuela.ohuq5fp7v@gmail.com','2014-05-03 00:05:28'),('ohuq5fqjb','gabriel.ohuq5fqjb@gmail.com','2014-05-03 00:05:29'),('ohuq5fquf','matheus.ohuq5fquf@gmail.com','2014-05-03 00:05:29'),('ohuq5fs5s','laura.ohuq5fs5s@gmail.com','2014-05-03 00:05:30'),('ohuq5fsjt','rafael.ohuq5fsjt@gmail.com','2014-05-03 00:05:30'),('ohuq5ft3d','rafael.ohuq5ft3d@gmail.com','2014-05-03 00:05:30'),('phuq5ffdq','arthur.phuq5ffdq@gmail.com','2014-05-03 00:05:17'),('phuq5fjkh','guilherme.phuq5fjkh@gmail.com','2014-05-03 00:05:24'),('phuq5fk18','rafael.phuq5fk18@gmail.com','2014-05-03 00:05:24'),('phuq5fmz3','lucas.phuq5fmz3@gmail.com','2014-05-03 00:05:26'),('phuq5fnfs','rafael.phuq5fnfs@gmail.com','2014-05-03 00:05:27'),('phuq5fntp','matheus.phuq5fntp@gmail.com','2014-05-03 00:05:27'),('phuq5fpg9','lucas.phuq5fpg9@gmail.com','2014-05-03 00:05:28'),('phuq5fq2k','bernardo.phuq5fq2k@gmail.com','2014-05-03 00:05:28'),('phuq5fr2t','rafael.phuq5fr2t@gmail.com','2014-05-03 00:05:29'),('qhuq5fguq','manuela.qhuq5fguq@gmail.com','2014-05-03 00:05:19'),('qhuq5fhmo','matheus.qhuq5fhmo@gmail.com','2014-05-03 00:05:22'),('qhuq5fmtj','gabriel.qhuq5fmtj@gmail.com','2014-05-03 00:05:26'),('qhuq5food','guilherme.qhuq5food@gmail.com','2014-05-03 00:05:27'),('qhuq5fpan','matheus.qhuq5fpan@gmail.com','2014-05-03 00:05:28'),('qhuq5fplu','beatriz.qhuq5fplu@gmail.com','2014-05-03 00:05:28'),('qhuq5fr5l','julia.qhuq5fr5l@gmail.com','2014-05-03 00:05:29'),('rhuq5fedd','lucas.rhuq5fedd@gmail.com','2014-05-03 00:05:16'),('rhuq5ffx8','arthur.rhuq5ffx8@gmail.com','2014-05-03 00:05:18'),('rhuq5fh32','rafael.rhuq5fh32@gmail.com','2014-05-03 00:05:20'),('rhuq5fhxs','matheus.rhuq5fhxs@gmail.com','2014-05-03 00:05:22'),('rhuq5fibs','isabella.rhuq5fibs@gmail.com','2014-05-03 00:05:22'),('rhuq5fkkp','julia.rhuq5fkkp@gmail.com','2014-05-03 00:05:24'),('rhuq5fm1p','alice.rhuq5fm1p@gmail.com','2014-05-03 00:05:25'),('rhuq5fnd0','gabriel.rhuq5fnd0@gmail.com','2014-05-03 00:05:27'),('rhuq5fno5','laura.rhuq5fno5@gmail.com','2014-05-03 00:05:27'),('rhuq5fnwh','arthur.rhuq5fnwh@gmail.com','2014-05-03 00:05:27'),('rhuq5fotx','maria eduarda.rhuq5fotx@gmail.com','2014-05-03 00:05:27'),('rhuq5fqx8','sophia.rhuq5fqx8@gmail.com','2014-05-03 00:05:29'),('rhuq5fs08','maria eduarda.rhuq5fs08@gmail.com','2014-05-03 00:05:30'),('rhuq5fse7','matheus.rhuq5fse7@gmail.com','2014-05-03 00:05:30'),('rhuq5fspf','davi.rhuq5fspf@gmail.com','2014-05-03 00:05:30'),('rhuq5ft65','giovanna.rhuq5ft65@gmail.com','2014-05-03 00:05:31'),('shuq5fezs','guilherme.shuq5fezs@gmail.com','2014-05-03 00:05:17'),('shuq5fhjv','maria eduarda.shuq5fhjv@gmail.com','2014-05-03 00:05:21'),('shuq5fhv0','arthur.shuq5fhv0@gmail.com','2014-05-03 00:05:22'),('thuq5feg5','beatriz.thuq5feg5@gmail.com','2014-05-03 00:05:16'),('thuq5fh8n','lucas.thuq5fh8n@gmail.com','2014-05-03 00:05:20'),('thuq5fivd','bernardo.thuq5fivd@gmail.com','2014-05-03 00:05:23'),('thuq5fl1f','isabella.thuq5fl1f@gmail.com','2014-05-03 00:05:25'),('thuq5frma','maria eduarda.thuq5frma@gmail.com','2014-05-03 00:05:29'),('thuq5ftek','manuela.thuq5ftek@gmail.com','2014-05-03 00:05:31'),('uhuq5fi0l','bernardo.uhuq5fi0l@gmail.com','2014-05-03 00:05:22'),('uhuq5fjq2','maria eduarda.uhuq5fjq2@gmail.com','2014-05-03 00:05:24'),('uhuq5fmcv','beatriz.uhuq5fmcv@gmail.com','2014-05-03 00:05:26'),('uhuq5fpwz','miguel.uhuq5fpwz@gmail.com','2014-05-03 00:05:28'),('uhuq5fpzs','sophia.uhuq5fpzs@gmail.com','2014-05-03 00:05:28'),('uhuq5ftbr','giovanna.uhuq5ftbr@gmail.com','2014-05-03 00:05:31'),('vhuq5fewz','davi.vhuq5fewz@gmail.com','2014-05-03 00:05:17'),('vhuq5ffjb','manuela.vhuq5ffjb@gmail.com','2014-05-03 00:05:17'),('vhuq5fgjk','gabriel.vhuq5fgjk@gmail.com','2014-05-03 00:05:19'),('vhuq5fgry','lucas.vhuq5fgry@gmail.com','2014-05-03 00:05:19'),('vhuq5fik8','giovanna.vhuq5fik8@gmail.com','2014-05-03 00:05:23'),('vhuq5fk6t','arthur.vhuq5fk6t@gmail.com','2014-05-03 00:05:24'),('vhuq5fkcd','giovanna.vhuq5fkcd@gmail.com','2014-05-03 00:05:24'),('vhuq5fknh','laura.vhuq5fknh@gmail.com','2014-05-03 00:05:24'),('vhuq5flfc','bernardo.vhuq5flfc@gmail.com','2014-05-03 00:05:25'),('vhuq5fmif','guilherme.vhuq5fmif@gmail.com','2014-05-03 00:05:26'),('vhuq5fo7m','davi.vhuq5fo7m@gmail.com','2014-05-03 00:05:27'),('vhuq5fp2a','valentina.vhuq5fp2a@gmail.com','2014-05-03 00:05:28'),('vhuq5fprf','valentina.vhuq5fprf@gmail.com','2014-05-03 00:05:28'),('vhuq5fpu7','miguel.vhuq5fpu7@gmail.com','2014-05-03 00:05:28'),('whuq5ferd','davi.whuq5ferd@gmail.com','2014-05-03 00:05:17'),('whuq5foae','miguel.whuq5foae@gmail.com','2014-05-03 00:05:27'),('whuq5ftps','julia.whuq5ftps@gmail.com','2014-05-03 00:05:31'),('xhuq5fois','matheus.xhuq5fois@gmail.com','2014-05-03 00:05:27'),('xhuq5fs8l','laura.xhuq5fs8l@gmail.com','2014-05-03 00:05:30'),('xhuq5ftk6','gabriel.xhuq5ftk6@gmail.com','2014-05-03 00:05:31'),('yhuq5fhh2','sophia.yhuq5fhh2@gmail.com','2014-05-03 00:05:21'),('yhuq5fhpg','guilherme.yhuq5fhpg@gmail.com','2014-05-03 00:05:22'),('yhuq5fjsv','alice.yhuq5fjsv@gmail.com','2014-05-03 00:05:24'),('yhuq5fkhx','gabriel.yhuq5fkhx@gmail.com','2014-05-03 00:05:24'),('yhuq5fkt2','miguel.yhuq5fkt2@gmail.com','2014-05-03 00:05:24'),('yhuq5fma3','guilherme.yhuq5fma3@gmail.com','2014-05-03 00:05:26'),('zhuq5fgmd','sophia.zhuq5fgmd@gmail.com','2014-05-03 00:05:19'),('zhuq5fh0a','miguel.zhuq5fh0a@gmail.com','2014-05-03 00:05:20'),('zhuq5fh5u','guilherme.zhuq5fh5u@gmail.com','2014-05-03 00:05:20'),('zhuq5fin1','guilherme.zhuq5fin1@gmail.com','2014-05-03 00:05:23'),('zhuq5fisl','alice.zhuq5fisl@gmail.com','2014-05-03 00:05:23'),('zhuq5fjc4','alice.zhuq5fjc4@gmail.com','2014-05-03 00:05:23'),('zhuq5folk','matheus.zhuq5folk@gmail.com','2014-05-03 00:05:27'),('zhuq5fqdp','julia.zhuq5fqdp@gmail.com','2014-05-03 00:05:29'),('zhuq5frrv','lucas.zhuq5frrv@gmail.com','2014-05-03 00:05:30'),('zhuq5ft8y','bernardo.zhuq5ft8y@gmail.com','2014-05-03 00:05:31');
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

-- Dump completed on 2014-05-02 21:06:37
