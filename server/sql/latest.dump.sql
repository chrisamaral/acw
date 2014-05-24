-- MySQL dump 10.14  Distrib 5.5.37-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: acw
-- ------------------------------------------------------
-- Server version	5.5.37-MariaDB-log

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
INSERT INTO `action` VALUES ('app.create','create app'),('app.get','get app info'),('app.list','list apps'),('app.off','disable app'),('app.on','enable app'),('org.app.off','disable app instance'),('org.app.on','enable app instance'),('org.app.user.off','disable access to app instance'),('org.app.user.on','enable access to app instance'),('org.create','create organization'),('org.get','get organization info'),('org.list','list organizations'),('org.off','disable organization'),('org.on','enable organization'),('org.user.admin.off','unset user as org.admin'),('org.user.admin.on','set user as org.admin'),('org.user.get','get organization user info'),('org.user.list','list organization users'),('org.user.off','remove user from organization'),('org.user.on','add user to organization'),('user.admin.off','unset user as admin'),('user.admin.on','set user as admin'),('user.create','create user'),('user.get','get user info'),('user.list','list users'),('user.off','disable user'),('user.on','enable user');
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
  CONSTRAINT `active_app_ibfk_3` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_app`
--

LOCK TABLES `active_app` WRITE;
/*!40000 ALTER TABLE `active_app` DISABLE KEYS */;
INSERT INTO `active_app` VALUES ('ghvfj2owi','2014-05-20 15:27:41',NULL,'2014-05-20 18:27:41'),('hhuzy6df7','2014-05-20 15:40:49',NULL,'2014-05-20 18:40:49'),('uhvfj9ww4','2014-05-20 15:27:43',NULL,'2014-05-20 18:27:43'),('vhvfiwy8s','2014-05-20 15:16:48',NULL,'2014-05-20 18:16:48'),('xhuzy3eeg','2014-05-14 17:56:07',NULL,'2014-05-14 20:56:07'),('zhvfixovu','2014-05-20 15:27:39',NULL,'2014-05-20 18:27:39');
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
  CONSTRAINT `active_app_log_ibfk_3` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_app_log`
--

LOCK TABLES `active_app_log` WRITE;
/*!40000 ALTER TABLE `active_app_log` DISABLE KEYS */;
INSERT INTO `active_app_log` VALUES ('hhuzy6df7','2014-05-09 17:39:00','2014-05-14 05:43:15'),('xhuzy3eeg','2014-05-09 17:37:00','2014-05-14 15:59:30'),('xhuzy3eeg','2014-05-14 16:41:03','2014-05-14 16:41:04'),('xhuzy3eeg','2014-05-14 16:41:21','2014-05-14 16:43:55'),('xhuzy3eeg','2014-05-14 16:45:02','2014-05-14 16:49:39'),('xhuzy3eeg','2014-05-14 16:49:45','2014-05-14 16:49:55'),('xhuzy3eeg','2014-05-14 16:50:34','2014-05-14 17:55:02'),('hhuzy6df7','2014-05-14 05:44:47','2014-05-20 15:40:23'),('hhuzy6df7','2014-05-20 15:40:31','2014-05-20 15:40:43');
/*!40000 ALTER TABLE `active_app_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `active_email`
--

DROP TABLE IF EXISTS `active_email`;
/*!50001 DROP VIEW IF EXISTS `active_email`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `active_email` (
  `email` tinyint NOT NULL,
  `full_name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

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
  CONSTRAINT `active_org_ibfk_3` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_org`
--

LOCK TABLES `active_org` WRITE;
/*!40000 ALTER TABLE `active_org` DISABLE KEYS */;
INSERT INTO `active_org` VALUES ('chvie0f3m','2014-05-22 15:22:47',NULL,'2014-05-22 18:22:47'),('ihv034u1b','2014-05-14 16:50:10',NULL,'2014-05-14 19:50:10'),('ihv03788b','2014-05-14 03:12:19',NULL,'2014-05-14 06:12:19'),('ihvfja8yb','2014-05-20 15:27:05',NULL,'2014-05-20 18:27:05');
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_disable_org` AFTER DELETE ON `active_org` FOR EACH ROW
BEGIN
    	INSERT INTO active_org_log
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
  CONSTRAINT `active_org_log_ibfk_3` FOREIGN KEY (`org`) REFERENCES `org` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_org_log`
--

LOCK TABLES `active_org_log` WRITE;
/*!40000 ALTER TABLE `active_org_log` DISABLE KEYS */;
INSERT INTO `active_org_log` VALUES ('ihv034u1b','2014-05-09 20:00:00','2014-05-09 20:00:31'),('ihv034u1b','2014-05-09 20:00:00','2014-05-09 20:00:54'),('ihv03788b','2014-05-09 20:00:00','2014-05-13 18:30:44'),('ihv03788b','2014-05-13 18:30:51','2014-05-13 20:22:05'),('ihv034u1b','2014-05-13 18:22:19','2014-05-14 03:57:43'),('ihv034u1b','2014-05-14 03:57:59','2014-05-14 16:49:58'),('lhvfj4871','2014-05-20 15:27:46','2014-05-20 15:41:03');
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
INSERT INTO `active_user` VALUES ('6irh2g0hua','2014-05-13 14:02:25',NULL,'2014-05-22 18:57:43'),('ahuvq312r','2014-05-06 18:42:02',NULL,'2014-05-06 21:42:21'),('ahuvq3235','2014-05-06 18:42:03',NULL,'2014-05-06 21:42:22'),('ahuvq382q','2014-05-14 02:44:22',NULL,'2014-05-14 05:50:01'),('ahuvq395w','2014-05-06 18:42:13',NULL,'2014-05-14 06:05:55'),('ahuvq39jv','2014-05-14 03:05:35',NULL,'2014-05-14 06:05:39'),('ahuvq39pg','2014-05-06 18:42:13',NULL,'2014-05-06 21:42:28'),('ahuvq3f00','2014-05-06 18:42:20',NULL,'2014-05-06 21:42:32'),('bhuvq30lz','2014-05-06 18:42:01',NULL,'2014-05-06 21:42:21'),('bhuvq33n9','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:24'),('bhuvq34qd','2014-05-06 18:42:07',NULL,'2014-05-06 21:42:24'),('bhuvq37ua','2014-05-06 18:42:11',NULL,'2014-05-06 21:42:26'),('bhuvq3933','2014-05-06 18:42:12',NULL,'2014-05-06 21:42:27'),('bhuvq3bhz','2014-05-06 18:42:16',NULL,'2014-05-06 21:42:29'),('bhuvq3bqc','2014-05-06 18:42:16',NULL,'2014-05-06 21:42:29'),('chuvq39s9','2014-05-06 18:42:13',NULL,'2014-05-06 21:42:28'),('chv8efolc','2014-05-15 15:36:57',NULL,'2014-05-15 18:36:57'),('czlkd15v3s','2014-05-02 14:00:33',NULL,'2014-05-14 22:08:55'),('dhuvq2zr6','2014-05-06 18:42:00',NULL,'2014-05-06 21:42:20'),('dhuvq302c','2014-05-06 18:42:01',NULL,'2014-05-06 21:42:21'),('dhuvq31p6','2014-05-06 18:42:03',NULL,'2014-05-06 21:42:22'),('dhuvq36ip','2014-05-06 18:42:09',NULL,'2014-05-06 21:42:25'),('dhuvq3erl','2014-05-06 18:42:20',NULL,'2014-05-06 21:42:32'),('dhvh0il8k','2014-05-21 16:17:14',NULL,'2014-05-21 19:18:30'),('ehuvq32sd','2014-05-06 18:42:04',NULL,'2014-05-06 21:42:23'),('ehuvq3b3y','2014-05-06 18:42:15',NULL,'2014-05-06 21:42:29'),('ehuvq3b6s','2014-05-06 18:42:15',NULL,'2014-05-06 21:42:29'),('ehuvq3c9w','2014-05-06 18:42:17',NULL,'2014-05-06 21:42:30'),('fhuvq2ztz','2014-05-06 18:42:00',NULL,'2014-05-06 21:42:20'),('fhuvq315j','2014-05-06 18:42:02',NULL,'2014-05-06 21:42:21'),('fhuvq31rz','2014-05-06 18:42:03',NULL,'2014-05-06 21:42:22'),('fhuvq367j','2014-05-06 18:42:09',NULL,'2014-05-06 21:42:25'),('fhuvq37op','2014-05-06 18:42:11',NULL,'2014-05-14 21:29:34'),('fhuvq3dad','2014-05-06 18:42:18',NULL,'2014-05-06 21:42:31'),('fhv69w2xe','2014-05-14 03:54:12',NULL,'2014-05-15 18:31:29'),('fhv8e687k','2014-05-15 15:29:36',NULL,'2014-05-15 18:29:36'),('ghuvq32ed','2014-05-06 18:42:04',NULL,'2014-05-06 21:42:22'),('ghuvq330t','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:23'),('ghuvq34t6','2014-05-06 18:42:07',NULL,'2014-05-06 21:42:24'),('ghuvq354e','2014-05-06 18:42:07',NULL,'2014-05-06 21:42:25'),('ghuvq37ri','2014-05-06 18:42:11',NULL,'2014-05-06 21:42:26'),('ghuvq38uq','2014-05-06 18:42:12',NULL,'2014-05-06 21:42:27'),('ghuvq38xi','2014-05-24 14:41:01',NULL,'2014-05-24 17:41:17'),('ghuvq3c74','2014-05-06 18:42:16',NULL,'2014-05-06 21:42:30'),('hhuvq3dzl','2014-05-06 18:42:19',NULL,'2014-05-06 21:42:31'),('hhuvq3ex7','2014-05-06 18:42:20',NULL,'2014-05-06 21:42:32'),('hhv8eeyx0','2014-05-15 15:36:24',NULL,'2014-05-15 18:36:24'),('ihuvq328r','2014-05-13 13:20:00',NULL,'2014-05-13 16:20:28'),('ihuvq37zw','2014-05-06 18:42:11',NULL,'2014-05-06 21:42:27'),('jhuvq39e9','2014-05-06 18:42:13',NULL,'2014-05-06 21:42:28'),('jhuvq3d1x','2014-05-06 18:42:18',NULL,'2014-05-06 21:42:30'),('jhuvq3dlk','2014-05-06 18:42:18',NULL,'2014-05-06 21:42:31'),('jhuvq3edl','2014-05-06 18:42:19',NULL,'2014-05-06 21:42:31'),('jhuvq3eot','2014-05-06 18:42:20',NULL,'2014-05-06 21:42:32'),('khuvq32jz','2014-05-06 18:42:04',NULL,'2014-05-06 21:42:23'),('khuvq3398','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:23'),('khuvq36d4','2014-05-06 18:42:09',NULL,'2014-05-06 21:42:25'),('khuvq38jh','2014-05-06 18:42:12',NULL,'2014-05-06 21:42:27'),('khuvq39h3','2014-05-06 18:42:13',NULL,'2014-05-06 21:42:28'),('krbnc2n5da','2014-04-29 14:42:14',NULL,'2014-05-21 19:16:06'),('lhuvq3an6','2014-05-06 18:42:14',NULL,'2014-05-06 21:42:28'),('lhuvq3c1i','2014-05-06 18:42:16',NULL,'2014-05-06 21:42:30'),('mhuvq3417','2014-05-06 18:42:06',NULL,'2014-05-06 21:42:24'),('mhuvq3754','2014-05-06 18:42:10',NULL,'2014-05-06 21:42:26'),('mhuvq3cl3','2014-05-06 18:42:17',NULL,'2014-05-06 21:42:30'),('nhuvq33yf','2014-05-06 18:42:06',NULL,'2014-05-06 21:42:24'),('ohuvq388c','2014-05-06 18:42:11',NULL,'2014-05-06 21:42:27'),('ohuvq38mb','2014-05-06 18:42:12',NULL,'2014-05-20 22:54:44'),('ohuvq3apz','2014-05-06 18:42:15',NULL,'2014-05-06 21:42:28'),('phuvq35cs','2014-05-06 18:42:08',NULL,'2014-05-06 21:42:25'),('phv8ealws','2014-05-15 15:33:01',NULL,'2014-05-15 18:33:01'),('qhuvq33eu','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:23'),('qhuvq351l','2014-05-06 18:42:07',NULL,'2014-05-06 21:42:24'),('qhuvq37dj','2014-05-06 18:42:10',NULL,'2014-05-06 21:42:26'),('qhuvq3byq','2014-05-06 18:42:16',NULL,'2014-05-06 21:42:30'),('qhv69v4zi','2014-05-14 03:53:28',NULL,'2014-05-14 06:53:28'),('rhuvq34w0','2014-05-06 18:42:07',NULL,'2014-05-06 21:42:24'),('rhuvq37gc','2014-05-06 18:42:10',NULL,'2014-05-06 21:42:26'),('rhuvq3b9k','2014-05-06 18:42:15',NULL,'2014-05-06 21:42:29'),('rhuvq3bvx','2014-05-07 15:15:00',NULL,'2014-05-14 07:13:55'),('rhuvq3cfi','2014-05-06 18:42:17',NULL,'2014-05-06 21:42:30'),('rhuvq3e7z','2014-05-06 18:42:19',NULL,'2014-05-14 06:16:36'),('shuvq307y','2014-05-06 18:42:01',NULL,'2014-05-06 21:42:21'),('shuvq333m','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:23'),('shuvq38dw','2014-05-06 18:42:12',NULL,'2014-05-06 21:42:27'),('shuvq3bkr','2014-05-06 18:42:16',NULL,'2014-05-06 21:42:29'),('shuvq3d7j','2014-05-06 18:42:18',NULL,'2014-05-06 21:42:31'),('thuvq32v7','2014-05-06 18:42:04',NULL,'2014-05-06 21:42:23'),('uhuvq346s','2014-05-06 18:42:06',NULL,'2014-05-06 21:42:24'),('uhuvq36ab','2014-05-06 18:42:09',NULL,'2014-05-06 21:42:25'),('uhuvq36zi','2014-05-06 18:42:10',NULL,'2014-05-06 21:42:26'),('uhuvq39bh','2014-05-06 18:42:13',NULL,'2014-05-06 21:42:28'),('vhuvq33kg','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:23'),('xhuvq33q1','2014-05-06 18:42:05',NULL,'2014-05-06 21:42:24'),('xhuvq36fw','2014-05-06 18:42:09',NULL,'2014-05-06 21:42:25'),('xhuvq3akc','2014-05-06 18:42:14',NULL,'2014-05-06 21:42:28'),('xhuvq3bf5','2014-05-06 18:42:15',NULL,'2014-05-06 21:42:29'),('xhuvq3elz','2014-05-06 18:42:20',NULL,'2014-05-06 21:42:32'),('yhuvq30j6','2014-05-06 18:42:01',NULL,'2014-05-06 21:42:21'),('yhuvq3a6c','2014-05-06 18:42:14',NULL,'2014-05-06 21:42:28'),('yhuvq3doe','2014-05-06 18:42:18',NULL,'2014-05-06 21:42:31'),('zhuvq30zz','2014-05-06 18:42:02',NULL,'2014-05-06 21:42:21'),('zhuvq33su','2014-05-06 18:42:06',NULL,'2014-05-06 21:42:24'),('zhuvq3ear','2014-05-06 18:42:19',NULL,'2014-05-06 21:42:31');
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
INSERT INTO `active_user_log` VALUES ('krbnc2n5da','2014-04-29 14:42:14','2014-04-29 14:42:14'),('krbnc2n5da','2014-04-29 18:07:45','2014-04-30 20:12:28'),('6irh2g0hua','2014-05-02 14:00:44','2014-05-06 18:16:55'),('krbnc2n5da','2014-04-30 20:13:58','2014-05-06 20:18:58'),('6irh2g0hua','0000-00-00 00:00:00','2014-05-06 21:53:59'),('khuvvwuqd','0000-00-00 00:00:00','2014-05-06 21:53:59'),('ehuvwze71','0000-00-00 00:00:00','2014-05-06 21:55:28'),('rhuvq34w0','0000-00-00 00:00:00','2014-05-13 13:19:35'),('krbnc2n5da','2014-05-06 20:19:30','2014-05-13 13:59:36'),('ghuvq38xi','2014-05-13 13:20:00','2014-05-13 20:36:58'),('ihuvq328r','2014-05-13 13:20:00','2014-05-13 20:36:58'),('krbnc2n5da','2014-05-13 14:00:27','2014-05-13 20:36:58'),('6irh2g0hua','2014-05-13 14:02:27','2014-05-13 20:36:58'),('ahuvq312r','2014-05-14 01:31:30','2014-05-14 01:31:43'),('ahuvq312r','2014-05-14 01:31:51','2014-05-14 01:31:55'),('ahuvq312r','2014-05-14 01:35:10','2014-05-14 01:35:30'),('ahuvq312r','2014-05-14 01:35:59','2014-05-14 01:36:06'),('ahuvq312r','2014-05-13 21:19:02','2014-05-14 01:36:12'),('ahuvq312r','2014-05-14 01:36:09','2014-05-14 01:37:15'),('ahuvq312r','2014-05-14 01:37:17','2014-05-14 01:37:19'),('ahuvq312r','2014-05-14 01:37:20','2014-05-14 01:37:24'),('ahuvq312r','2014-05-14 01:39:13','2014-05-14 01:39:18'),('ahuvq312r','2014-05-14 01:37:43','2014-05-14 01:39:20'),('dhuvq36ip','2014-05-14 01:47:35','2014-05-14 01:48:18'),('dhuvq36ip','2014-05-14 01:48:26','2014-05-14 01:51:51'),('dhuvq36ip','2014-05-14 01:48:21','2014-05-14 01:51:55'),('dhuvq36ip','2014-05-14 01:54:01','2014-05-14 01:54:02'),('dhuvq36ip','2014-05-14 01:52:03','2014-05-14 01:54:06'),('dhuvq36ip','2014-05-14 01:54:09','2014-05-14 01:54:34'),('dhuvq36ip','2014-05-14 01:54:40','2014-05-14 01:55:23'),('dhuvq36ip','2014-05-14 01:55:25','2014-05-14 02:19:41'),('ahuvq382q','2014-05-14 02:44:22','2014-05-14 02:49:13'),('ahuvq382q','2014-05-14 02:50:01','2014-05-14 02:55:50'),('ahuvq395w','2014-05-14 02:45:20','2014-05-14 03:04:18'),('ahuvq395w','2014-05-14 03:05:55','2014-05-14 03:06:05'),('ahuvq39jv','2014-05-14 03:05:39','2014-05-14 03:06:08'),('6irh2g0hua','2014-05-14 03:07:23','2014-05-14 03:07:41'),('6irh2g0hua','2014-05-14 05:11:33','2014-05-14 05:29:47'),('6irh2g0hua','2014-05-14 05:29:52','2014-05-14 05:29:54'),('ghuvq38xi','2014-05-06 18:42:12','2014-05-14 16:51:24'),('ghuvq38xi','2014-05-14 16:51:47','2014-05-14 16:52:06'),('ghuvq38xi','2014-05-14 18:21:16','2014-05-14 18:27:40'),('6irh2g0hua','2014-05-14 18:44:24','2014-05-14 18:44:32'),('ehuvwze71','2014-05-06 21:55:00','2014-05-14 19:07:31'),('czlkd15v3s','2014-05-14 19:07:50','2014-05-14 19:08:27'),('czlkd15v3s','2014-05-14 19:08:32','2014-05-14 19:08:50'),('6irh2g0hua','2014-05-14 19:41:52','2014-05-14 19:43:05'),('6irh2g0hua','2014-05-14 19:45:09','2014-05-14 19:45:17'),('6irh2g0hua','2014-05-14 19:56:20','2014-05-14 19:56:32'),('6irh2g0hua','2014-05-14 19:56:40','2014-05-14 19:56:46'),('6irh2g0hua','2014-05-14 19:56:17','2014-05-14 20:00:29'),('6irh2g0hua','2014-05-14 05:59:30','2014-05-14 21:06:17'),('chv8efolc','2014-05-15 15:36:57','2014-05-16 17:50:48'),('fhv8e687k','2014-05-15 15:29:36','2014-05-16 17:50:49'),('hhv8eeyx0','2014-05-15 15:36:24','2014-05-16 17:50:51'),('phv8ealws','2014-05-15 15:33:01','2014-05-16 17:50:52'),('rhuvq3e7z','2014-05-14 03:16:36','2014-05-16 17:50:54'),('6irh2g0hua','2014-05-14 21:06:29','2014-05-16 18:05:32'),('6irh2g0hua','2014-05-14 21:06:28','2014-05-16 18:05:34'),('krbnc2n5da','2014-05-14 21:16:42','2014-05-16 18:05:39'),('krbnc2n5da','2014-05-14 21:16:33','2014-05-16 18:05:39'),('mhuvq377y','2014-05-06 18:42:10','2014-05-16 20:43:56'),('krbnc2n5da','2014-05-14 00:02:44','2014-05-16 20:58:14'),('6irh2g0hua','2014-05-14 21:05:16','2014-05-16 21:29:48'),('6irh2g0hua','2014-05-16 18:05:57','2014-05-16 21:29:56'),('6irh2g0hua','2014-05-16 21:30:11','2014-05-16 21:30:23'),('ohuvq38mb','2014-05-20 19:54:44','2014-05-20 19:54:45'),('ghuvq38xi','2014-05-14 16:52:17','2014-05-21 14:02:05'),('czlkd15v3s','2014-05-14 19:07:08','2014-05-21 16:11:48'),('fhv69w2xe','2014-05-15 15:31:29','2014-05-21 16:12:02'),('6irh2g0hua','2014-05-16 21:32:31','2014-05-21 16:15:51'),('krbnc2n5da','2014-05-21 16:16:06','2014-05-21 16:16:15'),('ghuvq38xi','2014-05-14 18:32:02','2014-05-24 14:06:20'),('ghuvq38xi','2014-05-14 16:53:37','2014-05-24 14:06:26'),('ghuvq38xi','2014-05-14 16:51:34','2014-05-24 14:40:50');
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app`
--

LOCK TABLES `app` WRITE;
/*!40000 ALTER TABLE `app` DISABLE KEYS */;
INSERT INTO `app` VALUES ('ghvfj2owi','nomeChato','But I can\'t give you this case, it don\'t belong to me. Besides, I\'ve already been through too much shit this morning over this case to hand it over to your dumb ass.',NULL,'2014-05-20 15:21:12','2014-05-20 18:29:19'),('hhuzy6df7','maisUm','Look, just because I don\'t be givin\' no man a foot massage don\'t make it right for Marsellus to throw Antwone into a glass motherfuckin\' house, fuckin\' up the way the nigger talks. Motherfucker do tha','bhvdyustq.png','2014-05-09 17:39:00','2014-05-19 16:07:26'),('uhvfj9ww4','123456','Now that we know who you are, I know who I am. I\'m not a mistake! It all makes sense! In a comic, you know how you can tell who the arch-villain\'s going to be? He\'s the exact opposite of the hero. And',NULL,'2014-05-20 15:26:49','2014-05-20 18:26:49'),('vhvfiwy8s','outro','Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I\'m in a transitional period so I don\'t wanna kill you, I wanna help you. But I can\'t give you ',NULL,'2014-05-20 15:16:45','2014-05-20 18:28:03'),('xhuzy3eeg','pager','Painel de Gestão de Equipes e Rotas Inteligentes','dhveg329k.jpg','2014-05-09 17:37:00','2014-05-20 00:09:45'),('zhvfixovu','yetanotherapp','I should\'ve known way back when... You know why, David? Because of the kids. They called me Mr Glass.',NULL,'2014-05-20 15:17:19','2014-05-20 18:28:39');
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
  UNIQUE KEY `user_org_app` (`user`,`org_app`),
  UNIQUE KEY `user_org_app_other` (`user`,`org`,`app`),
  KEY `org_app` (`org_app`),
  KEY `app` (`app`),
  KEY `org` (`org`),
  CONSTRAINT `app_user_ibfk_14` FOREIGN KEY (`app`) REFERENCES `app` (`id`),
  CONSTRAINT `app_user_ibfk_15` FOREIGN KEY (`org`) REFERENCES `org` (`id`),
  CONSTRAINT `app_user_ibfk_7` FOREIGN KEY (`org_app`) REFERENCES `org_app` (`id`) ON DELETE CASCADE,
  CONSTRAINT `app_user_ibfk_9` FOREIGN KEY (`user`) REFERENCES `active_user` (`user`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_user`
--

LOCK TABLES `app_user` WRITE;
/*!40000 ALTER TABLE `app_user` DISABLE KEYS */;
INSERT INTO `app_user` VALUES (28,'6irh2g0hua',33,'chvie0f3m','xhuzy3eeg','2014-05-22 16:08:53',NULL,'2014-05-22 19:08:53'),(29,'ghuvq38xi',34,'ihv034u1b','xhuzy3eeg','2014-05-24 14:41:23',NULL,'2014-05-24 17:41:23');
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_delete_app_user` AFTER DELETE ON `app_user` FOR EACH ROW
BEGIN
    	INSERT INTO app_user_log
	    	(user, org, app, init, end)
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_user_log`
--

LOCK TABLES `app_user_log` WRITE;
/*!40000 ALTER TABLE `app_user_log` DISABLE KEYS */;
INSERT INTO `app_user_log` VALUES ('6irh2g0hua','chvie0f3m','xhuzy3eeg','2014-05-22 15:59:35','2014-05-22 16:01:07'),('6irh2g0hua','chvie0f3m','xhuzy3eeg','2014-05-22 16:04:54','2014-05-22 16:05:13'),('6irh2g0hua','chvie0f3m','xhuzy3eeg','2014-05-22 16:08:29','2014-05-22 16:08:43');
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
  `abbr` varchar(15) NOT NULL,
  `name` varchar(200) NOT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `creation` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `abbr` (`abbr`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org`
--

LOCK TABLES `org` WRITE;
/*!40000 ALTER TABLE `org` DISABLE KEYS */;
INSERT INTO `org` VALUES ('chvie0f3m','simtv','Sim Tv',NULL,'2014-05-22 15:22:47','2014-05-22 18:22:47'),('ihv034u1b','NewConnect','New Connect Parceira Claro',NULL,'2014-05-09 19:58:00','2014-05-09 22:58:26'),('ihv03788b','Antiga','Joãozinho & Cia',NULL,'2014-05-09 20:00:00','2014-05-20 18:31:26'),('ihvfja8yb','outraEmpresa','Nome extenso',NULL,'2014-05-20 15:27:05','2014-05-20 18:31:18'),('lhvfj4871','nenhumNome','empresa especializada em te x%#$',NULL,'2014-05-20 15:22:24','2014-05-20 18:31:08');
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
  UNIQUE KEY `org_app` (`org`,`app`),
  KEY `app` (`app`),
  CONSTRAINT `org_app_ibfk_13` FOREIGN KEY (`app`) REFERENCES `active_app` (`app`) ON DELETE CASCADE,
  CONSTRAINT `org_app_ibfk_14` FOREIGN KEY (`org`) REFERENCES `active_org` (`org`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_app`
--

LOCK TABLES `org_app` WRITE;
/*!40000 ALTER TABLE `org_app` DISABLE KEYS */;
INSERT INTO `org_app` VALUES (33,'chvie0f3m','xhuzy3eeg','2014-05-22 16:08:21',NULL,'2014-05-22 19:08:21'),(34,'ihv034u1b','xhuzy3eeg','2014-05-22 18:04:24',NULL,'2014-05-22 21:04:24');
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_delete_org_app` AFTER DELETE ON `org_app` FOR EACH ROW
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
  CONSTRAINT `org_app_log_ibfk_5` FOREIGN KEY (`org`) REFERENCES `org` (`id`),
  CONSTRAINT `org_app_log_ibfk_6` FOREIGN KEY (`app`) REFERENCES `app` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_app_log`
--

LOCK TABLES `org_app_log` WRITE;
/*!40000 ALTER TABLE `org_app_log` DISABLE KEYS */;
INSERT INTO `org_app_log` VALUES ('chvie0f3m','xhuzy3eeg','2014-05-22 15:57:04','2014-05-22 15:58:04'),('chvie0f3m','xhuzy3eeg','2014-05-22 15:59:23','2014-05-22 16:04:19'),('chvie0f3m','xhuzy3eeg','2014-05-22 16:04:50','2014-05-22 16:05:31');
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
INSERT INTO `role` VALUES ('admin','Admistrador Geral'),('org.admin','Administrador'),('org.user','Funcionário');
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
  CONSTRAINT `role_action_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_action_ibfk_5` FOREIGN KEY (`action`) REFERENCES `action` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_action`
--

LOCK TABLES `role_action` WRITE;
/*!40000 ALTER TABLE `role_action` DISABLE KEYS */;
INSERT INTO `role_action` VALUES ('admin','app.create'),('admin','app.get'),('admin','app.list'),('admin','app.off'),('admin','app.on'),('admin','org.app.off'),('admin','org.app.on'),('admin','org.app.user.off'),('admin','org.app.user.on'),('admin','org.create'),('admin','org.get'),('admin','org.list'),('admin','org.off'),('admin','org.on'),('admin','org.user.admin.off'),('admin','org.user.admin.on'),('admin','org.user.get'),('admin','org.user.list'),('admin','org.user.off'),('admin','org.user.on'),('admin','user.admin.off'),('admin','user.admin.on'),('admin','user.create'),('admin','user.get'),('admin','user.list'),('admin','user.off'),('admin','user.on'),('org.admin','org.app.user.off'),('org.admin','org.app.user.on'),('org.admin','org.user.admin.off'),('org.admin','org.user.admin.on'),('org.admin','org.user.get'),('org.admin','org.user.list'),('org.admin','org.user.off'),('org.admin','org.user.on'),('org.admin','user.create'),('org.admin','user.on');
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
  CONSTRAINT `role_page_ibfk_2` FOREIGN KEY (`page`) REFERENCES `page` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_page_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
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
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user`
--

LOCK TABLES `role_user` WRITE;
/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` VALUES (42,'fhuvq37op','ihv03788b','org.user','2014-05-14 03:12:40',NULL,'2014-05-14 06:12:40'),(54,'fhuvq37op','ihv03788b','org.admin','2014-05-14 18:29:29',NULL,'2014-05-14 21:29:29'),(61,'czlkd15v3s','ihv034u1b','org.user','2014-05-14 19:08:55',NULL,'2014-05-14 22:08:55'),(78,'ohuvq38mb','ihv03788b','org.user','2014-05-16 20:11:23',NULL,'2014-05-16 23:11:23'),(79,'krbnc2n5da',NULL,'admin','2014-05-16 20:59:55',NULL,'2014-05-17 00:28:19'),(80,'krbnc2n5da','ihv03788b','org.admin','2014-05-16 21:28:28',NULL,'2014-05-17 00:28:28'),(84,'dhvh0il8k','ihv034u1b','org.user','2014-05-21 16:18:29',NULL,'2014-05-21 19:18:29'),(85,'dhvh0il8k','ihv034u1b','org.admin','2014-05-21 16:18:30',NULL,'2014-05-21 19:18:30'),(86,'6irh2g0hua','chvie0f3m','org.user','2014-05-22 15:57:43',NULL,'2014-05-22 18:57:43'),(87,'ghuvq38xi','ihv034u1b','org.user','2014-05-24 14:41:17',NULL,'2014-05-24 17:41:17');
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
  KEY `role` (`role`),
  KEY `org` (`org`),
  CONSTRAINT `role_user_log_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`),
  CONSTRAINT `role_user_log_ibfk_3` FOREIGN KEY (`role`) REFERENCES `role` (`id`),
  CONSTRAINT `role_user_log_ibfk_4` FOREIGN KEY (`org`) REFERENCES `org` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user_log`
--

LOCK TABLES `role_user_log` WRITE;
/*!40000 ALTER TABLE `role_user_log` DISABLE KEYS */;
INSERT INTO `role_user_log` VALUES ('krbnc2n5da',NULL,'admin','2014-04-29 18:07:45','2014-04-29 18:07:45');
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
  `avatar` varchar(100) DEFAULT NULL,
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
INSERT INTO `user` VALUES ('6irh2g0hua','Acácio','Acácio Neto','hv7azitd.jpg','2014-03-23 10:50:44','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-17 00:29:37'),('ahuvq312r','Manuela','Manuela Araújo','hv7b8xc3.jpg','2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:19:57'),('ahuvq3235','Manuela','Manuela Gomes',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq382q','Lucas','Lucas Gonçalves',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq38rx','Valentina','Valentina Gonçalves',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq390b','Laura','Laura Melo',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq395w','Manuela','Manuela Fernandes',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq39jv','Guilherme','Guilherme Araújo',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq39pg','Miguel','Miguel Ferreira',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ahuvq3f00','Laura','Laura Santos',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq30lz','Manuela','Manuela Pereira',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq33n9','Gabriel','Gabriel Ribeiro',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq34f6','Valentina','Valentina Cardoso',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq34qd','Maria Edua','Maria Eduarda Alves',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq35z5','Guilherme','Guilherme Rodrigues',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq37ua','Valentina','Valentina Barbosa',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq3933','Miguel','Miguel Cardoso',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq39mo','Miguel','Miguel Pereira',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq3aeq','Pedro','Pedro Martins',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq3bhz','Julia','Julia Almeida',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('bhuvq3bqc','Gabriel','Gabriel Fernandes',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('chuvq2zod','Alice','Alice Souza',NULL,'2014-05-06 18:42:00','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('chuvq2zzk','Gabriel','Gabriel Carvalho',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('chuvq35fl','Beatriz','Beatriz Cavalcante',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('chuvq39s9','Guilherme','Guilherme Azevedo',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('chuvq3bt5','Beatriz','Beatriz Fernandes',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('chv8efolc','Xis','Xis Nove',NULL,'2014-05-15 15:36:57',NULL,'2014-05-15 18:36:57'),('czlkd15v3s','Wagner','Wagner Silva',NULL,'2014-03-23 10:50:59','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq2zr6','Bernardo','Bernardo Fernandes',NULL,'2014-05-06 18:42:00','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq302c','Arthur','Arthur Melo',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq3056','Giovanna','Giovanna Azevedo',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq31b5','Giovanna','Giovanna Azevedo',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq31p6','Julia','Julia Lima','hvgv4p9k.jpg','2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-21 16:46:28'),('dhuvq325x','Miguel','Miguel Araújo',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq34nl','Isabella','Isabella Gonçalves',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq36ip','Manuela','Manuela Pereira',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhuvq3erl','Lucas','Lucas Pereira',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('dhvh0il8k','Fernando','Luis Fernando Vaz Gonçalves',NULL,'2014-05-21 16:17:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-21 19:19:20'),('ehuvq320c','Bernardo','Bernardo Schmitz',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvq32sd','Rafael','Rafael Barbosa',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvq37lx','Gabriel','Gabriel Azevedo',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvq3b3y','Gabriel','Gabriel Rocha',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvq3b6s','Isabella','Isabella Cardoso',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvq3c9w','Manuela','Manuela Correia',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvq3dr6','Bernardo','Bernardo Santos',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ehuvwze71','xxxxxxx','xxxxxxxx',NULL,'2014-05-06 21:55:00','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq2ztz','Maria Edua','Maria Eduarda Correia',NULL,'2014-05-06 18:42:00','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq2zwr','Maria Edua','Maria Eduarda Azevedo',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq315j','Lucas','Lucas Rocha',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq31rz','Pedro','Pedro Melo',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq336e','Pedro','Pedro Morais',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq367j','Guilherme','Guilherme Gonçalves',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq37j4','Isabella','Isabella Almeida',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq37op','Alice','Alice Ribeiro',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhuvq3dad','Sophia','Sophia Araújo',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhv69w2xe','novíssimo','usuário',NULL,'2014-05-14 03:54:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('fhv8e687k','Novo','Usuário',NULL,'2014-05-15 15:29:36',NULL,'2014-05-15 18:29:36'),('ghuvq30ud','Laura','Laura Dias',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq31me','Manuela','Manuela Melo',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq31ur','Valentina','Valentina Alves',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq32ed','Matheus','Matheus Gomes',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq330t','Giovanna','Giovanna Pereira',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq34t6','Rafael','Rafael Ferreira',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq354e','Laura','Laura Schmitz',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq37ri','Guilherme','Guilherme Correia',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq38uq','Manuela','Manuela Gonçalves',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ghuvq38xi','Alice','Alice Alves','hvl7gswr.jpg','2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 17:42:53'),('ghuvq3c74','Maria Edua','Maria Eduarda Ferreira',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('hhuvq34cd','Matheus','Matheus Montes',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('hhuvq35tj','Bernardo','Bernardo Lima',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('hhuvq38b4','Sophia','Sophia Costa',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('hhuvq3dzl','Beatriz','Beatriz Lima',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('hhuvq3ex7','Isabella','Isabella Morais',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('hhv8eeyx0','Ronaldo','Ronaldo',NULL,'2014-05-15 15:36:24',NULL,'2014-05-15 18:36:24'),('ihuvq328r','Alice','Alice Fernandes',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ihuvq32xz','Gabriel','Gabriel Dias',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ihuvq35wc','Giovanna','Giovanna Martins',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ihuvq37zw','Lucas','Lucas Lima',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ihuvq39xw','Giovanna','Giovanna Rodrigues',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ihuvq3ahk','Manuela','Manuela Teixeira',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ihuvq3f2s','Davi','Davi Silva',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq36wq','Julia','Julia Gonçalves',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq385i','Giovanna','Giovanna Montes',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq39e9','Valentina','Valentina Oliveira',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3a94','Rafael','Rafael Barbosa',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3avk','Isabella','Isabella Carvalho',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3d1x','Arthur','Arthur Fernandes',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3dlk','Guilherme','Guilherme Costa',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3dws','Giovanna','Giovanna Costa',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3edl','Valentina','Valentina Araújo',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('jhuvq3eot','Gabriel','Gabriel Silva',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq30or','Maria Edua','Maria Eduarda Almeida',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq32jz','Manuela','Manuela Alves',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq3398','Bernardo','Bernardo Schmitz',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq364q','Maria Edua','Maria Eduarda Melo',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq36d4','Matheus','Matheus Cavalcante',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq37aq','Giovanna','Giovanna Silva',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq38jh','Davi','Davi Melo',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq39h3','Guilherme','Guilherme Martins',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq3cwb','Valentina','Valentina Dias',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq3cz5','Lucas','Lucas Ribeiro',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvq3f5m','Manuela','Manuela Ferreira',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('khuvvwuqd','Christian','outro nome',NULL,'2014-05-06 21:25:00','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('krbnc2n5da','Christian','Christian Amaral','hvkerobl.jpg','2014-03-23 10:50:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 04:19:31'),('lhuvq32mr','Maria Edua','Maria Eduarda Araújo',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq34yt','Bernardo','Bernardo Souza',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq36lh','Alice','Alice Schmitz',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq36r2','Giovanna','Giovanna Alves',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq372c','Lucas','Lucas Alves',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq3aby','Alice','Alice Silva',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq3an6','Giovanna','Giovanna Silva',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq3asr','Miguel','Miguel Lima',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq3c1i','Valentina','Valentina Almeida',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq3dis','Gabriel','Gabriel Correia',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq31gr','Matheus','Matheus Almeida',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq33vm','Lucas','Lucas Ribeiro',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq3417','Arthur','Arthur Montes',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq3754','Pedro','Pedro Correia',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq377y','Arthur','Arthur Melo',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq3cl3','Guilherme','Guilherme Dias',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('mhuvq3euf','Giovanna','Giovanna Ribeiro',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq32h5','Alice','Alice Martins',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq33yf','Pedro','Pedro Alves',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq34hy','Sophia','Sophia Silva',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq359y','Miguel','Miguel Rodrigues',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq361x','Isabella','Isabella Morais',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq3a0q','Rafael','Rafael Gonçalves',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('nhuvq3c4a','Bernardo','Bernardo Ribeiro',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ohuvq3576','Isabella','Isabella Rodrigues',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ohuvq37x4','Laura','Laura Cavalcante',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ohuvq388c','Isabella','Isabella Gonçalves',NULL,'2014-05-06 18:42:11','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ohuvq38mb','Bernardo','Bernardo Teixeira',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('ohuvq3apz','Arthur','Arthur Rodrigues',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('phuvq35cs','Pedro','Pedro Rodrigues',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('phuvq38gp','Arthur','Arthur Gomes',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('phuvq3ayc','Alice','Alice Morais',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('phv8ealws','Fulano','Fulano da silva',NULL,'2014-05-15 15:33:01',NULL,'2014-05-15 18:33:01'),('qhuvq33c0','Manuela','Manuela Alves',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq33eu','Matheus','Matheus Lima',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq33hm','Bernardo','Bernardo Fernandes',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq351l','Valentina','Valentina Fernandes',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq35l6','Lucas','Lucas Rodrigues',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq35qr','Miguel','Miguel Montes',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq37dj','Valentina','Valentina Montes',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3byq','Isabella','Isabella Montes',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3cqp','Maria Edua','Maria Eduarda Melo',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3d4r','Manuela','Manuela Santos',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3dd6','Lucas','Lucas Dias',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3dfy','Beatriz','Beatriz Fernandes',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3e2e','Isabella','Isabella Costa',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhuvq3ej7','Maria Edua','Maria Eduarda Cardoso',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('qhv69v4zi','Laza','Rento',NULL,'2014-05-14 03:53:28','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq30ge','Beatriz','Beatriz Oliveira',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq34w0','Beatriz','Beatriz Gomes',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq37gc','Laura','Laura Cardoso',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq3b9k','Laura','Laura Rocha',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq3bvx','Alice','Alice Gomes',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq3cfi','Davi','Davi Souza',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq3ctj','Manuela','Manuela Costa',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('rhuvq3e7z','Arthur','Arthur Almeida',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq307y','Davi','Davi Gonçalves',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq30dk','Alice','Alice Souza',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq333m','Maria Edua','Maria Eduarda Fernandes',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq38dw','Gabriel','Gabriel Araújo',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq398o','Isabella','Isabella Lima',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq3bcd','Beatriz','Beatriz Silva',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq3bkr','Lucas','Lucas Almeida',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq3d7j','Isabella','Isabella Schmitz',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvq3e56','Guilherme','Guilherme Araújo',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('shuvx6065','Ainda','Mais Um Usuário',NULL,'2014-05-06 22:00:00','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('thuvq32v7','Giovanna','Giovanna Barbosa',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('thuvq35id','Lucas','Lucas Souza',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('thuvq36oa','Giovanna','Giovanna Schmitz',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('thuvq3du0','Maria Edua','Maria Eduarda Ferreira',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('uhuvq346s','Beatriz','Beatriz Schmitz',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('uhuvq36ab','Lucas','Lucas Dias',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('uhuvq36zi','Julia','Julia Montes',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('uhuvq39bh','Giovanna','Giovanna Ribeiro',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('uhuvq39v3','Bernardo','Bernardo Teixeira',NULL,'2014-05-06 18:42:13','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('vhuvq31jl','Giovanna','Giovanna Lima',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('vhuvq33kg','Miguel','Miguel Ferreira',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('vhuvq34ks','Isabella','Isabella Cavalcante',NULL,'2014-05-06 18:42:07','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('vhuvq36tw','Giovanna','Giovanna Correia',NULL,'2014-05-06 18:42:10','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('vhuvq38p3','Matheus','Matheus Pereira',NULL,'2014-05-06 18:42:12','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('vhuvq3a3i','Laura','Laura Melo',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('whuvq30as','Maria Edua','Maria Eduarda Ferreira',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('whuvq318b','Pedro','Pedro Gomes',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('whuvq31dx','Sophia','Sophia Gomes',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('whuvq31xk','Davi','Davi Fernandes',NULL,'2014-05-06 18:42:03','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('whuvq32bj','Miguel','Miguel Silva',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq30rk','Alice','Alice Gonçalves',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq33q1','Laura','Laura Araújo',NULL,'2014-05-06 18:42:05','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq3440','Sophia','Sophia Fernandes',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq349l','Beatriz','Beatriz Cardoso',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq36fw','Beatriz','Beatriz Martins',NULL,'2014-05-06 18:42:09','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq3akc','Isabella','Isabella Ribeiro',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq3bf5','Davi','Davi Souza',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq3bnk','Gabriel','Gabriel Morais',NULL,'2014-05-06 18:42:16','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq3cco','Pedro','Pedro Fernandes',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('xhuvq3elz','Giovanna','Giovanna Almeida',NULL,'2014-05-06 18:42:20','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq30j6','Alice','Alice Pereira',NULL,'2014-05-06 18:42:01','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq30x5','Gabriel','Gabriel Ferreira',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq32pl','Maria Edua','Maria Eduarda Araújo',NULL,'2014-05-06 18:42:04','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq3a6c','Sophia','Sophia Pereira',NULL,'2014-05-06 18:42:14','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq3b16','Julia','Julia Teixeira',NULL,'2014-05-06 18:42:15','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq3cia','Rafael','Rafael Morais',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq3cnx','Davi','Davi Morais',NULL,'2014-05-06 18:42:17','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('yhuvq3doe','Lucas','Lucas Rodrigues',NULL,'2014-05-06 18:42:18','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('zhuvq30zz','Valentina','Valentina Teixeira',NULL,'2014-05-06 18:42:02','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('zhuvq33su','Pedro','Pedro Ferreira',NULL,'2014-05-06 18:42:06','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('zhuvq35ny','Lucas','Lucas Silva',NULL,'2014-05-06 18:42:08','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('zhuvq3ear','Davi','Davi Oliveira',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('zhuvq3egd','Miguel','Miguel Alves',NULL,'2014-05-06 18:42:19','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30');
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
INSERT INTO `user_email` VALUES ('6irh2g0hua','acaciomonteiro@gmail.com','2014-03-23 17:52:56'),('ahuvq312r','manuela.ahuvq312r@gmail.com','2014-05-06 21:42:21'),('ahuvq3235','manuela.ahuvq3235@gmail.com','2014-05-06 21:42:22'),('ahuvq382q','lucas.ahuvq382q@gmail.com','2014-05-06 21:42:27'),('ahuvq38rx','valentina.ahuvq38rx@gmail.com','2014-05-06 21:42:27'),('ahuvq390b','laura.ahuvq390b@gmail.com','2014-05-06 21:42:27'),('ahuvq395w','manuela.ahuvq395w@gmail.com','2014-05-06 21:42:27'),('ahuvq39jv','guilherme.ahuvq39jv@gmail.com','2014-05-06 21:42:28'),('ahuvq39pg','miguel.ahuvq39pg@gmail.com','2014-05-06 21:42:28'),('ahuvq3f00','laura.ahuvq3f00@gmail.com','2014-05-06 21:42:32'),('bhuvq30lz','manuela.bhuvq30lz@gmail.com','2014-05-06 21:42:21'),('bhuvq33n9','gabriel.bhuvq33n9@gmail.com','2014-05-06 21:42:24'),('bhuvq34f6','valentina.bhuvq34f6@gmail.com','2014-05-06 21:42:24'),('bhuvq34qd','maria eduarda.bhuvq34qd@gmail.com','2014-05-06 21:42:24'),('bhuvq35z5','guilherme.bhuvq35z5@gmail.com','2014-05-06 21:42:25'),('bhuvq37ua','valentina.bhuvq37ua@gmail.com','2014-05-06 21:42:26'),('bhuvq3933','miguel.bhuvq3933@gmail.com','2014-05-06 21:42:27'),('bhuvq39mo','miguel.bhuvq39mo@gmail.com','2014-05-06 21:42:28'),('bhuvq3aeq','pedro.bhuvq3aeq@gmail.com','2014-05-06 21:42:28'),('bhuvq3bhz','julia.bhuvq3bhz@gmail.com','2014-05-06 21:42:29'),('bhuvq3bqc','gabriel.bhuvq3bqc@gmail.com','2014-05-06 21:42:29'),('chuvq2zod','alice.chuvq2zod@gmail.com','2014-05-06 21:42:20'),('chuvq2zzk','gabriel.chuvq2zzk@gmail.com','2014-05-06 21:42:20'),('chuvq35fl','beatriz.chuvq35fl@gmail.com','2014-05-06 21:42:25'),('chuvq39s9','guilherme.chuvq39s9@gmail.com','2014-05-06 21:42:28'),('chuvq3bt5','beatriz.chuvq3bt5@gmail.com','2014-05-06 21:42:29'),('czlkd15v3s','teste@email.com','2014-05-14 22:07:18'),('czlkd15v3s','wagnercmelosil@yahoo.com.br','2014-03-25 21:03:42'),('dhuvq2zr6','bernardo.dhuvq2zr6@gmail.com','2014-05-06 21:42:20'),('dhuvq302c','arthur.dhuvq302c@gmail.com','2014-05-06 21:42:21'),('dhuvq3056','giovanna.dhuvq3056@gmail.com','2014-05-06 21:42:21'),('dhuvq31b5','giovanna.dhuvq31b5@gmail.com','2014-05-06 21:42:22'),('dhuvq31p6','julia.dhuvq31p6@gmail.com','2014-05-06 21:42:22'),('dhuvq325x','miguel.dhuvq325x@gmail.com','2014-05-06 21:42:22'),('dhuvq34nl','isabella.dhuvq34nl@gmail.com','2014-05-06 21:42:24'),('dhuvq36ip','manuela.dhuvq36ip@gmail.com','2014-05-06 21:42:25'),('dhuvq36ip','teste@gmail.com','2014-05-14 04:56:46'),('dhuvq3erl','lucas.dhuvq3erl@gmail.com','2014-05-06 21:42:32'),('dhvh0il8k','luis.vaz@newconnecttelecom.com.br','2014-05-21 19:17:23'),('ehuvq320c','bernardo.ehuvq320c@gmail.com','2014-05-06 21:42:22'),('ehuvq32sd','rafael.ehuvq32sd@gmail.com','2014-05-06 21:42:23'),('ehuvq37lx','gabriel.ehuvq37lx@gmail.com','2014-05-06 21:42:26'),('ehuvq3b3y','gabriel.ehuvq3b3y@gmail.com','2014-05-06 21:42:29'),('ehuvq3b6s','isabella.ehuvq3b6s@gmail.com','2014-05-06 21:42:29'),('ehuvq3c9w','manuela.ehuvq3c9w@gmail.com','2014-05-06 21:42:30'),('ehuvq3dr6','bernardo.ehuvq3dr6@gmail.com','2014-05-06 21:42:31'),('fhuvq2ztz','maria eduarda.fhuvq2ztz@gmail.com','2014-05-06 21:42:20'),('fhuvq2zwr','maria eduarda.fhuvq2zwr@gmail.com','2014-05-06 21:42:20'),('fhuvq315j','lucas.fhuvq315j@gmail.com','2014-05-06 21:42:21'),('fhuvq31rz','pedro.fhuvq31rz@gmail.com','2014-05-06 21:42:22'),('fhuvq336e','pedro.fhuvq336e@gmail.com','2014-05-06 21:42:23'),('fhuvq367j','guilherme.fhuvq367j@gmail.com','2014-05-06 21:42:25'),('fhuvq37j4','isabella.fhuvq37j4@gmail.com','2014-05-06 21:42:26'),('fhuvq37op','alice.fhuvq37op@gmail.com','2014-05-06 21:42:26'),('fhuvq3dad','sophia.fhuvq3dad@gmail.com','2014-05-06 21:42:31'),('fhv69w2xe','teste@yahoo.com','2014-05-14 06:54:27'),('fhv8e687k','emaildousuario@gmail.com','2014-05-15 18:29:46'),('ghuvq30ud','laura.ghuvq30ud@gmail.com','2014-05-06 21:42:21'),('ghuvq31me','manuela.ghuvq31me@gmail.com','2014-05-06 21:42:22'),('ghuvq31ur','valentina.ghuvq31ur@gmail.com','2014-05-06 21:42:22'),('ghuvq32ed','matheus.ghuvq32ed@gmail.com','2014-05-06 21:42:22'),('ghuvq330t','giovanna.ghuvq330t@gmail.com','2014-05-06 21:42:23'),('ghuvq34t6','rafael.ghuvq34t6@gmail.com','2014-05-06 21:42:24'),('ghuvq354e','laura.ghuvq354e@gmail.com','2014-05-06 21:42:24'),('ghuvq37ri','guilherme.ghuvq37ri@gmail.com','2014-05-06 21:42:26'),('ghuvq38uq','manuela.ghuvq38uq@gmail.com','2014-05-06 21:42:27'),('ghuvq38xi','alice.ghuvq38xi@gmail.com','2014-05-06 21:42:27'),('ghuvq3c74','maria eduarda.ghuvq3c74@gmail.com','2014-05-06 21:42:30'),('hhuvq34cd','matheus.hhuvq34cd@gmail.com','2014-05-06 21:42:24'),('hhuvq35tj','bernardo.hhuvq35tj@gmail.com','2014-05-06 21:42:25'),('hhuvq38b4','sophia.hhuvq38b4@gmail.com','2014-05-06 21:42:27'),('hhuvq3dzl','beatriz.hhuvq3dzl@gmail.com','2014-05-06 21:42:31'),('hhuvq3ex7','isabella.hhuvq3ex7@gmail.com','2014-05-06 21:42:32'),('ihuvq328r','alice.ihuvq328r@gmail.com','2014-05-06 21:42:22'),('ihuvq32xz','gabriel.ihuvq32xz@gmail.com','2014-05-06 21:42:23'),('ihuvq35wc','giovanna.ihuvq35wc@gmail.com','2014-05-06 21:42:25'),('ihuvq37zw','lucas.ihuvq37zw@gmail.com','2014-05-06 21:42:27'),('ihuvq39xw','giovanna.ihuvq39xw@gmail.com','2014-05-06 21:42:28'),('ihuvq3ahk','manuela.ihuvq3ahk@gmail.com','2014-05-06 21:42:28'),('ihuvq3f2s','davi.ihuvq3f2s@gmail.com','2014-05-06 21:42:32'),('jhuvq36wq','julia.jhuvq36wq@gmail.com','2014-05-06 21:42:26'),('jhuvq385i','giovanna.jhuvq385i@gmail.com','2014-05-06 21:42:27'),('jhuvq39e9','valentina.jhuvq39e9@gmail.com','2014-05-06 21:42:28'),('jhuvq3a94','rafael.jhuvq3a94@gmail.com','2014-05-06 21:42:28'),('jhuvq3avk','isabella.jhuvq3avk@gmail.com','2014-05-06 21:42:29'),('jhuvq3d1x','arthur.jhuvq3d1x@gmail.com','2014-05-06 21:42:30'),('jhuvq3dlk','guilherme.jhuvq3dlk@gmail.com','2014-05-06 21:42:31'),('jhuvq3dws','giovanna.jhuvq3dws@gmail.com','2014-05-06 21:42:31'),('jhuvq3edl','valentina.jhuvq3edl@gmail.com','2014-05-06 21:42:31'),('jhuvq3eot','gabriel.jhuvq3eot@gmail.com','2014-05-06 21:42:32'),('khuvq30or','maria eduarda.khuvq30or@gmail.com','2014-05-06 21:42:21'),('khuvq32jz','manuela.khuvq32jz@gmail.com','2014-05-06 21:42:23'),('khuvq3398','bernardo.khuvq3398@gmail.com','2014-05-06 21:42:23'),('khuvq364q','maria eduarda.khuvq364q@gmail.com','2014-05-06 21:42:25'),('khuvq36d4','matheus.khuvq36d4@gmail.com','2014-05-06 21:42:25'),('khuvq37aq','giovanna.khuvq37aq@gmail.com','2014-05-06 21:42:26'),('khuvq38jh','davi.khuvq38jh@gmail.com','2014-05-06 21:42:27'),('khuvq39h3','guilherme.khuvq39h3@gmail.com','2014-05-06 21:42:28'),('khuvq3cwb','valentina.khuvq3cwb@gmail.com','2014-05-06 21:42:30'),('khuvq3cz5','lucas.khuvq3cz5@gmail.com','2014-05-06 21:42:30'),('khuvq3f5m','manuela.khuvq3f5m@gmail.com','2014-05-06 21:42:32'),('krbnc2n5da','christian.amaral@simtv.com.br','2014-04-25 20:55:36'),('krbnc2n5da','christianamaral@id.uff.br','2014-03-25 21:06:41'),('krbnc2n5da','darthcas@gmail.com','2014-03-25 21:03:42'),('krbnc2n5da','this.christian@yahoo.com','2014-03-25 21:06:44'),('lhuvq32mr','maria eduarda.lhuvq32mr@gmail.com','2014-05-06 21:42:23'),('lhuvq34yt','bernardo.lhuvq34yt@gmail.com','2014-05-06 21:42:24'),('lhuvq36lh','alice.lhuvq36lh@gmail.com','2014-05-06 21:42:25'),('lhuvq36r2','giovanna.lhuvq36r2@gmail.com','2014-05-06 21:42:25'),('lhuvq372c','lucas.lhuvq372c@gmail.com','2014-05-06 21:42:26'),('lhuvq3aby','alice.lhuvq3aby@gmail.com','2014-05-06 21:42:28'),('lhuvq3an6','giovanna.lhuvq3an6@gmail.com','2014-05-06 21:42:28'),('lhuvq3asr','miguel.lhuvq3asr@gmail.com','2014-05-06 21:42:29'),('lhuvq3c1i','valentina.lhuvq3c1i@gmail.com','2014-05-06 21:42:30'),('lhuvq3dis','gabriel.lhuvq3dis@gmail.com','2014-05-06 21:42:31'),('mhuvq31gr','matheus.mhuvq31gr@gmail.com','2014-05-06 21:42:22'),('mhuvq33vm','lucas.mhuvq33vm@gmail.com','2014-05-06 21:42:24'),('mhuvq3417','arthur.mhuvq3417@gmail.com','2014-05-06 21:42:24'),('mhuvq3754','pedro.mhuvq3754@gmail.com','2014-05-06 21:42:26'),('mhuvq377y','arthur.mhuvq377y@gmail.com','2014-05-06 21:42:26'),('mhuvq3cl3','guilherme.mhuvq3cl3@gmail.com','2014-05-06 21:42:30'),('mhuvq3euf','giovanna.mhuvq3euf@gmail.com','2014-05-06 21:42:32'),('nhuvq32h5','alice.nhuvq32h5@gmail.com','2014-05-06 21:42:22'),('nhuvq33yf','pedro.nhuvq33yf@gmail.com','2014-05-06 21:42:24'),('nhuvq34hy','sophia.nhuvq34hy@gmail.com','2014-05-06 21:42:24'),('nhuvq359y','miguel.nhuvq359y@gmail.com','2014-05-06 21:42:25'),('nhuvq361x','isabella.nhuvq361x@gmail.com','2014-05-06 21:42:25'),('nhuvq3a0q','rafael.nhuvq3a0q@gmail.com','2014-05-06 21:42:28'),('nhuvq3c4a','bernardo.nhuvq3c4a@gmail.com','2014-05-06 21:42:30'),('ohuvq3576','isabella.ohuvq3576@gmail.com','2014-05-06 21:42:25'),('ohuvq37x4','laura.ohuvq37x4@gmail.com','2014-05-06 21:42:26'),('ohuvq388c','isabella.ohuvq388c@gmail.com','2014-05-06 21:42:27'),('ohuvq38mb','bernardo.ohuvq38mb@gmail.com','2014-05-06 21:42:27'),('ohuvq3apz','arthur.ohuvq3apz@gmail.com','2014-05-06 21:42:28'),('phuvq35cs','pedro.phuvq35cs@gmail.com','2014-05-06 21:42:25'),('phuvq38gp','arthur.phuvq38gp@gmail.com','2014-05-06 21:42:27'),('phuvq3ayc','alice.phuvq3ayc@gmail.com','2014-05-06 21:42:29'),('phv8ealws','fulano@click21.com.br','2014-05-15 18:33:08'),('qhuvq33c0','manuela.qhuvq33c0@gmail.com','2014-05-06 21:42:23'),('qhuvq33eu','matheus.qhuvq33eu@gmail.com','2014-05-06 21:42:23'),('qhuvq33hm','bernardo.qhuvq33hm@gmail.com','2014-05-06 21:42:23'),('qhuvq351l','valentina.qhuvq351l@gmail.com','2014-05-06 21:42:24'),('qhuvq35l6','lucas.qhuvq35l6@gmail.com','2014-05-06 21:42:25'),('qhuvq35qr','miguel.qhuvq35qr@gmail.com','2014-05-06 21:42:25'),('qhuvq37dj','valentina.qhuvq37dj@gmail.com','2014-05-06 21:42:26'),('qhuvq3byq','isabella.qhuvq3byq@gmail.com','2014-05-06 21:42:30'),('qhuvq3cqp','maria eduarda.qhuvq3cqp@gmail.com','2014-05-06 21:42:30'),('qhuvq3d4r','manuela.qhuvq3d4r@gmail.com','2014-05-06 21:42:30'),('qhuvq3dd6','lucas.qhuvq3dd6@gmail.com','2014-05-06 21:42:31'),('qhuvq3dfy','beatriz.qhuvq3dfy@gmail.com','2014-05-06 21:42:31'),('qhuvq3e2e','isabella.qhuvq3e2e@gmail.com','2014-05-06 21:42:31'),('qhuvq3ej7','maria eduarda.qhuvq3ej7@gmail.com','2014-05-06 21:42:31'),('rhuvq30ge','beatriz.rhuvq30ge@gmail.com','2014-05-06 21:42:21'),('rhuvq34w0','beatriz.rhuvq34w0@gmail.com','2014-05-06 21:42:24'),('rhuvq37gc','laura.rhuvq37gc@gmail.com','2014-05-06 21:42:26'),('rhuvq3b9k','laura.rhuvq3b9k@gmail.com','2014-05-06 21:42:29'),('rhuvq3bvx','alice.rhuvq3bvx@gmail.com','2014-05-06 21:42:29'),('rhuvq3cfi','davi.rhuvq3cfi@gmail.com','2014-05-06 21:42:30'),('rhuvq3ctj','manuela.rhuvq3ctj@gmail.com','2014-05-06 21:42:30'),('rhuvq3e7z','arthur.rhuvq3e7z@gmail.com','2014-05-06 21:42:31'),('shuvq307y','davi.shuvq307y@gmail.com','2014-05-06 21:42:21'),('shuvq30dk','alice.shuvq30dk@gmail.com','2014-05-06 21:42:21'),('shuvq333m','maria eduarda.shuvq333m@gmail.com','2014-05-06 21:42:23'),('shuvq38dw','gabriel.shuvq38dw@gmail.com','2014-05-06 21:42:27'),('shuvq398o','isabella.shuvq398o@gmail.com','2014-05-06 21:42:27'),('shuvq3bcd','beatriz.shuvq3bcd@gmail.com','2014-05-06 21:42:29'),('shuvq3bkr','lucas.shuvq3bkr@gmail.com','2014-05-06 21:42:29'),('shuvq3d7j','isabella.shuvq3d7j@gmail.com','2014-05-06 21:42:31'),('shuvq3e56','guilherme.shuvq3e56@gmail.com','2014-05-06 21:42:31'),('shuvx6065','outro@yahoo.com','2014-05-07 01:01:35'),('thuvq32v7','giovanna.thuvq32v7@gmail.com','2014-05-06 21:42:23'),('thuvq35id','lucas.thuvq35id@gmail.com','2014-05-06 21:42:25'),('thuvq36oa','giovanna.thuvq36oa@gmail.com','2014-05-06 21:42:25'),('thuvq3du0','maria eduarda.thuvq3du0@gmail.com','2014-05-06 21:42:31'),('uhuvq346s','beatriz.uhuvq346s@gmail.com','2014-05-06 21:42:24'),('uhuvq36ab','lucas.uhuvq36ab@gmail.com','2014-05-06 21:42:25'),('uhuvq36zi','julia.uhuvq36zi@gmail.com','2014-05-06 21:42:26'),('uhuvq39bh','giovanna.uhuvq39bh@gmail.com','2014-05-06 21:42:28'),('uhuvq39v3','bernardo.uhuvq39v3@gmail.com','2014-05-06 21:42:28'),('vhuvq31jl','giovanna.vhuvq31jl@gmail.com','2014-05-06 21:42:22'),('vhuvq33kg','miguel.vhuvq33kg@gmail.com','2014-05-06 21:42:23'),('vhuvq34ks','isabella.vhuvq34ks@gmail.com','2014-05-06 21:42:24'),('vhuvq36tw','giovanna.vhuvq36tw@gmail.com','2014-05-06 21:42:25'),('vhuvq38p3','matheus.vhuvq38p3@gmail.com','2014-05-06 21:42:27'),('vhuvq3a3i','laura.vhuvq3a3i@gmail.com','2014-05-06 21:42:28'),('whuvq30as','maria eduarda.whuvq30as@gmail.com','2014-05-06 21:42:21'),('whuvq318b','pedro.whuvq318b@gmail.com','2014-05-06 21:42:22'),('whuvq31dx','sophia.whuvq31dx@gmail.com','2014-05-06 21:42:22'),('whuvq31xk','davi.whuvq31xk@gmail.com','2014-05-06 21:42:22'),('whuvq32bj','miguel.whuvq32bj@gmail.com','2014-05-06 21:42:22'),('xhuvq30rk','alice.xhuvq30rk@gmail.com','2014-05-06 21:42:21'),('xhuvq33q1','laura.xhuvq33q1@gmail.com','2014-05-06 21:42:24'),('xhuvq3440','sophia.xhuvq3440@gmail.com','2014-05-06 21:42:24'),('xhuvq349l','beatriz.xhuvq349l@gmail.com','2014-05-06 21:42:24'),('xhuvq36fw','beatriz.xhuvq36fw@gmail.com','2014-05-06 21:42:25'),('xhuvq3akc','isabella.xhuvq3akc@gmail.com','2014-05-06 21:42:28'),('xhuvq3bf5','davi.xhuvq3bf5@gmail.com','2014-05-06 21:42:29'),('xhuvq3bnk','gabriel.xhuvq3bnk@gmail.com','2014-05-06 21:42:29'),('xhuvq3cco','pedro.xhuvq3cco@gmail.com','2014-05-06 21:42:30'),('xhuvq3elz','giovanna.xhuvq3elz@gmail.com','2014-05-06 21:42:32'),('yhuvq30j6','alice.yhuvq30j6@gmail.com','2014-05-06 21:42:21'),('yhuvq30x5','gabriel.yhuvq30x5@gmail.com','2014-05-06 21:42:21'),('yhuvq32pl','maria eduarda.yhuvq32pl@gmail.com','2014-05-06 21:42:23'),('yhuvq3a6c','sophia.yhuvq3a6c@gmail.com','2014-05-06 21:42:28'),('yhuvq3b16','julia.yhuvq3b16@gmail.com','2014-05-06 21:42:29'),('yhuvq3cia','rafael.yhuvq3cia@gmail.com','2014-05-06 21:42:30'),('yhuvq3cnx','davi.yhuvq3cnx@gmail.com','2014-05-06 21:42:30'),('yhuvq3doe','lucas.yhuvq3doe@gmail.com','2014-05-06 21:42:31'),('zhuvq30zz','valentina.zhuvq30zz@gmail.com','2014-05-06 21:42:21'),('zhuvq33su','pedro.zhuvq33su@gmail.com','2014-05-06 21:42:24'),('zhuvq35ny','lucas.zhuvq35ny@gmail.com','2014-05-06 21:42:25'),('zhuvq3ear','davi.zhuvq3ear@gmail.com','2014-05-06 21:42:31'),('zhuvq3egd','miguel.zhuvq3egd@gmail.com','2014-05-06 21:42:31');
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
INSERT INTO `user_log` VALUES ('krbnc2n5da','Christian','Christian Amaral','hufokyby.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:13:40'),('krbnc2n5da','Christian','Christian Amaral','hulr4qjo.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:31:55'),('krbnc2n5da','Christian','Christian Amaral','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:51:12'),('krbnc2n5da','Novo','Amaral dos Nomes','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:51:50'),('krbnc2n5da','Christian','Amaral','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-04-29 22:51:59'),('krbnc2n5da','Christian','Christian Amaral','hulrs7wi.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-03 16:22:15'),('krbnc2n5da','Christian','Christian Amaral','hur4c7zr.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-05 15:34:53'),('6irh2g0hua','Acácio','Acácio Neto',NULL,NULL,'2014-05-06 21:16:55'),('6irh2g0hua','Acácio','Acácio Neto',NULL,NULL,'2014-05-06 21:20:22'),('khuvvwuqd','Christian','outro nome',NULL,NULL,'2014-05-07 00:26:02'),('khuvvwuqd','Christian','outro nome',NULL,NULL,'2014-05-07 00:27:20'),('khuvvwuqd','Christian','outro nome',NULL,NULL,'2014-05-07 00:28:25'),('khuvvwuqd','Christian','outro nome',NULL,NULL,'2014-05-07 00:30:26'),('khuvvwuqd','Christian','outro nome',NULL,NULL,'2014-05-07 00:30:43'),('ehuvwze71','xxxxxxx','xxxxxxxx',NULL,NULL,'2014-05-07 00:55:28'),('ehuvwze71','xxxxxxx','xxxxxxxx',NULL,NULL,'2014-05-07 00:55:34'),('rhuvq3bvx','Alice','Alice Gomes',NULL,NULL,'2014-05-07 18:15:58'),('krbnc2n5da','Christian','Christian Amaral','hutxj0ro.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 22:44:33'),('krbnc2n5da','Christian','Christian Amaral','huyn744c.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:03:08'),('krbnc2n5da','Christian','Christian Amaral','huynv0ko.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:04:49'),('krbnc2n5da','Christian','Christian Amaral','huynx6qs.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:10:00'),('krbnc2n5da','Christian','Christian Amaral','huyo3v5e.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:11:30'),('krbnc2n5da','Christian','Christian Amaral','huyo5rzy.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:29:29'),('krbnc2n5da','Christian','Christian Amaral','huyoswn2.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:32:01'),('krbnc2n5da','Christian','Christian Amaral','huyow65p.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:33:21'),('krbnc2n5da','Christian','Christian Amaral','huyoxvzo.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:36:45'),('krbnc2n5da','Christian','Christian Amaral','huyp28w1.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:38:14'),('krbnc2n5da','Christian','Christian Amaral','huyp45t8.png','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:38:25'),('krbnc2n5da','Christian','Christian Amaral','huyp4e2s.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-08 23:44:05'),('krbnc2n5da','Christian','Christian Amaral','huypbp0b.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-09 00:38:09'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-13 16:09:36'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-13 16:11:49'),('rhuvq34w0','Beatriz','Beatriz Gomes',NULL,NULL,'2014-05-13 16:14:01'),('rhuvq34w0','Beatriz','Beatriz Gomes',NULL,NULL,'2014-05-13 16:19:16'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-13 16:20:10'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-13 16:20:16'),('ihuvq328r','Alice','Alice Fernandes',NULL,NULL,'2014-05-13 16:20:28'),('ihuvq328r','Alice','Alice Fernandes',NULL,NULL,'2014-05-13 16:20:32'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-13 16:21:00'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-13 16:21:05'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-13 16:21:15'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-13 16:58:32'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-13 16:59:05'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-13 16:59:36'),('6irh2g0hua','Acácio','Acácio Neto',NULL,NULL,'2014-05-13 17:02:25'),('6irh2g0hua','Acácio','Acácio Neto',NULL,NULL,'2014-05-13 17:02:27'),('krbnc2n5da','Christian','Christian Amaral','huyr9843.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-14 08:27:27'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-14 19:51:24'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-14 19:51:34'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-14 19:51:47'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-14 19:52:06'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-14 19:52:17'),('czlkd15v3s','Wagner','Wagner Silva',NULL,NULL,'2014-05-14 22:07:08'),('ehuvwze71','xxxxxxx','xxxxxxxx',NULL,NULL,'2014-05-14 22:07:31'),('krbnc2n5da','Christian','Christian Amaral','hv6d7zwy.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-14 22:42:34'),('6irh2g0hua','Acácio','Acácio Neto',NULL,NULL,'2014-05-14 22:42:35'),('6irh2g0hua','Acácio','Acácio Neto',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq312r','Manuela','Manuela Araújo',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq3235','Manuela','Manuela Gomes',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq382q','Lucas','Lucas Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq38rx','Valentina','Valentina Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq390b','Laura','Laura Melo',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq395w','Manuela','Manuela Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq39jv','Guilherme','Guilherme Araújo',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq39pg','Miguel','Miguel Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('ahuvq3f00','Laura','Laura Santos',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq30lz','Manuela','Manuela Pereira',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq33n9','Gabriel','Gabriel Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq34f6','Valentina','Valentina Cardoso',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq34qd','Maria Edua','Maria Eduarda Alves',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq35z5','Guilherme','Guilherme Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq37ua','Valentina','Valentina Barbosa',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq3933','Miguel','Miguel Cardoso',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq39mo','Miguel','Miguel Pereira',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq3aeq','Pedro','Pedro Martins',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq3bhz','Julia','Julia Almeida',NULL,NULL,'2014-05-15 00:11:30'),('bhuvq3bqc','Gabriel','Gabriel Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('chuvq2zod','Alice','Alice Souza',NULL,NULL,'2014-05-15 00:11:30'),('chuvq2zzk','Gabriel','Gabriel Carvalho',NULL,NULL,'2014-05-15 00:11:30'),('chuvq35fl','Beatriz','Beatriz Cavalcante',NULL,NULL,'2014-05-15 00:11:30'),('chuvq39s9','Guilherme','Guilherme Azevedo',NULL,NULL,'2014-05-15 00:11:30'),('chuvq3bt5','Beatriz','Beatriz Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('czlkd15v3s','Wagner','Wagner Silva',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq2zr6','Bernardo','Bernardo Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq302c','Arthur','Arthur Melo',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq3056','Giovanna','Giovanna Azevedo',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq31b5','Giovanna','Giovanna Azevedo',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq31p6','Julia','Julia Lima',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq325x','Miguel','Miguel Araújo',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq34nl','Isabella','Isabella Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq36ip','Manuela','Manuela Pereira',NULL,NULL,'2014-05-15 00:11:30'),('dhuvq3erl','Lucas','Lucas Pereira',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq320c','Bernardo','Bernardo Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq32sd','Rafael','Rafael Barbosa',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq37lx','Gabriel','Gabriel Azevedo',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq3b3y','Gabriel','Gabriel Rocha',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq3b6s','Isabella','Isabella Cardoso',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq3c9w','Manuela','Manuela Correia',NULL,NULL,'2014-05-15 00:11:30'),('ehuvq3dr6','Bernardo','Bernardo Santos',NULL,NULL,'2014-05-15 00:11:30'),('ehuvwze71','xxxxxxx','xxxxxxxx',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq2ztz','Maria Edua','Maria Eduarda Correia',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq2zwr','Maria Edua','Maria Eduarda Azevedo',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq315j','Lucas','Lucas Rocha',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq31rz','Pedro','Pedro Melo',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq336e','Pedro','Pedro Morais',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq367j','Guilherme','Guilherme Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq37j4','Isabella','Isabella Almeida',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq37op','Alice','Alice Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('fhuvq3dad','Sophia','Sophia Araújo',NULL,NULL,'2014-05-15 00:11:30'),('fhv69w2xe','novíssimo','usuário',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq30ud','Laura','Laura Dias',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq31me','Manuela','Manuela Melo',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq31ur','Valentina','Valentina Alves',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq32ed','Matheus','Matheus Gomes',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq330t','Giovanna','Giovanna Pereira',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq34t6','Rafael','Rafael Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq354e','Laura','Laura Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq37ri','Guilherme','Guilherme Correia',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq38uq','Manuela','Manuela Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq38xi','Alice','Alice Alves',NULL,NULL,'2014-05-15 00:11:30'),('ghuvq3c74','Maria Edua','Maria Eduarda Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('hhuvq34cd','Matheus','Matheus Montes',NULL,NULL,'2014-05-15 00:11:30'),('hhuvq35tj','Bernardo','Bernardo Lima',NULL,NULL,'2014-05-15 00:11:30'),('hhuvq38b4','Sophia','Sophia Costa',NULL,NULL,'2014-05-15 00:11:30'),('hhuvq3dzl','Beatriz','Beatriz Lima',NULL,NULL,'2014-05-15 00:11:30'),('hhuvq3ex7','Isabella','Isabella Morais',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq328r','Alice','Alice Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq32xz','Gabriel','Gabriel Dias',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq35wc','Giovanna','Giovanna Martins',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq37zw','Lucas','Lucas Lima',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq39xw','Giovanna','Giovanna Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq3ahk','Manuela','Manuela Teixeira',NULL,NULL,'2014-05-15 00:11:30'),('ihuvq3f2s','Davi','Davi Silva',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq36wq','Julia','Julia Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq385i','Giovanna','Giovanna Montes',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq39e9','Valentina','Valentina Oliveira',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3a94','Rafael','Rafael Barbosa',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3avk','Isabella','Isabella Carvalho',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3d1x','Arthur','Arthur Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3dlk','Guilherme','Guilherme Costa',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3dws','Giovanna','Giovanna Costa',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3edl','Valentina','Valentina Araújo',NULL,NULL,'2014-05-15 00:11:30'),('jhuvq3eot','Gabriel','Gabriel Silva',NULL,NULL,'2014-05-15 00:11:30'),('khuvq30or','Maria Edua','Maria Eduarda Almeida',NULL,NULL,'2014-05-15 00:11:30'),('khuvq32jz','Manuela','Manuela Alves',NULL,NULL,'2014-05-15 00:11:30'),('khuvq3398','Bernardo','Bernardo Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('khuvq364q','Maria Edua','Maria Eduarda Melo',NULL,NULL,'2014-05-15 00:11:30'),('khuvq36d4','Matheus','Matheus Cavalcante',NULL,NULL,'2014-05-15 00:11:30'),('khuvq37aq','Giovanna','Giovanna Silva',NULL,NULL,'2014-05-15 00:11:30'),('khuvq38jh','Davi','Davi Melo',NULL,NULL,'2014-05-15 00:11:30'),('khuvq39h3','Guilherme','Guilherme Martins',NULL,NULL,'2014-05-15 00:11:30'),('khuvq3cwb','Valentina','Valentina Dias',NULL,NULL,'2014-05-15 00:11:30'),('khuvq3cz5','Lucas','Lucas Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('khuvq3f5m','Manuela','Manuela Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('khuvvwuqd','Christian','outro nome',NULL,NULL,'2014-05-15 00:11:30'),('krbnc2n5da','Christian','Christian Amaral','hv6d7zwy.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:11:30'),('lhuvq32mr','Maria Edua','Maria Eduarda Araújo',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq34yt','Bernardo','Bernardo Souza',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq36lh','Alice','Alice Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq36r2','Giovanna','Giovanna Alves',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq372c','Lucas','Lucas Alves',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq3aby','Alice','Alice Silva',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq3an6','Giovanna','Giovanna Silva',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq3asr','Miguel','Miguel Lima',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq3c1i','Valentina','Valentina Almeida',NULL,NULL,'2014-05-15 00:11:30'),('lhuvq3dis','Gabriel','Gabriel Correia',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq31gr','Matheus','Matheus Almeida',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq33vm','Lucas','Lucas Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq3417','Arthur','Arthur Montes',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq3754','Pedro','Pedro Correia',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq377y','Arthur','Arthur Melo',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq3cl3','Guilherme','Guilherme Dias',NULL,NULL,'2014-05-15 00:11:30'),('mhuvq3euf','Giovanna','Giovanna Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq32h5','Alice','Alice Martins',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq33yf','Pedro','Pedro Alves',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq34hy','Sophia','Sophia Silva',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq359y','Miguel','Miguel Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq361x','Isabella','Isabella Morais',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq3a0q','Rafael','Rafael Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('nhuvq3c4a','Bernardo','Bernardo Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('ohuvq3576','Isabella','Isabella Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('ohuvq37x4','Laura','Laura Cavalcante',NULL,NULL,'2014-05-15 00:11:30'),('ohuvq388c','Isabella','Isabella Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('ohuvq38mb','Bernardo','Bernardo Teixeira',NULL,NULL,'2014-05-15 00:11:30'),('ohuvq3apz','Arthur','Arthur Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('phuvq35cs','Pedro','Pedro Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('phuvq38gp','Arthur','Arthur Gomes',NULL,NULL,'2014-05-15 00:11:30'),('phuvq3ayc','Alice','Alice Morais',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq33c0','Manuela','Manuela Alves',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq33eu','Matheus','Matheus Lima',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq33hm','Bernardo','Bernardo Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq351l','Valentina','Valentina Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq35l6','Lucas','Lucas Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq35qr','Miguel','Miguel Montes',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq37dj','Valentina','Valentina Montes',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3byq','Isabella','Isabella Montes',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3cqp','Maria Edua','Maria Eduarda Melo',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3d4r','Manuela','Manuela Santos',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3dd6','Lucas','Lucas Dias',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3dfy','Beatriz','Beatriz Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3e2e','Isabella','Isabella Costa',NULL,NULL,'2014-05-15 00:11:30'),('qhuvq3ej7','Maria Edua','Maria Eduarda Cardoso',NULL,NULL,'2014-05-15 00:11:30'),('qhv69v4zi','Laza','Rento',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq30ge','Beatriz','Beatriz Oliveira',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq34w0','Beatriz','Beatriz Gomes',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq37gc','Laura','Laura Cardoso',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq3b9k','Laura','Laura Rocha',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq3bvx','Alice','Alice Gomes',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq3cfi','Davi','Davi Souza',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq3ctj','Manuela','Manuela Costa',NULL,NULL,'2014-05-15 00:11:30'),('rhuvq3e7z','Arthur','Arthur Almeida',NULL,NULL,'2014-05-15 00:11:30'),('shuvq307y','Davi','Davi Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('shuvq30dk','Alice','Alice Souza',NULL,NULL,'2014-05-15 00:11:30'),('shuvq333m','Maria Edua','Maria Eduarda Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('shuvq38dw','Gabriel','Gabriel Araújo',NULL,NULL,'2014-05-15 00:11:30'),('shuvq398o','Isabella','Isabella Lima',NULL,NULL,'2014-05-15 00:11:30'),('shuvq3bcd','Beatriz','Beatriz Silva',NULL,NULL,'2014-05-15 00:11:30'),('shuvq3bkr','Lucas','Lucas Almeida',NULL,NULL,'2014-05-15 00:11:30'),('shuvq3d7j','Isabella','Isabella Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('shuvq3e56','Guilherme','Guilherme Araújo',NULL,NULL,'2014-05-15 00:11:30'),('shuvx6065','Ainda','Mais Um Usuário',NULL,NULL,'2014-05-15 00:11:30'),('thuvq32v7','Giovanna','Giovanna Barbosa',NULL,NULL,'2014-05-15 00:11:30'),('thuvq35id','Lucas','Lucas Souza',NULL,NULL,'2014-05-15 00:11:30'),('thuvq36oa','Giovanna','Giovanna Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('thuvq3du0','Maria Edua','Maria Eduarda Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('uhuvq346s','Beatriz','Beatriz Schmitz',NULL,NULL,'2014-05-15 00:11:30'),('uhuvq36ab','Lucas','Lucas Dias',NULL,NULL,'2014-05-15 00:11:30'),('uhuvq36zi','Julia','Julia Montes',NULL,NULL,'2014-05-15 00:11:30'),('uhuvq39bh','Giovanna','Giovanna Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('uhuvq39v3','Bernardo','Bernardo Teixeira',NULL,NULL,'2014-05-15 00:11:30'),('vhuvq31jl','Giovanna','Giovanna Lima',NULL,NULL,'2014-05-15 00:11:30'),('vhuvq33kg','Miguel','Miguel Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('vhuvq34ks','Isabella','Isabella Cavalcante',NULL,NULL,'2014-05-15 00:11:30'),('vhuvq36tw','Giovanna','Giovanna Correia',NULL,NULL,'2014-05-15 00:11:30'),('vhuvq38p3','Matheus','Matheus Pereira',NULL,NULL,'2014-05-15 00:11:30'),('vhuvq3a3i','Laura','Laura Melo',NULL,NULL,'2014-05-15 00:11:30'),('whuvq30as','Maria Edua','Maria Eduarda Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('whuvq318b','Pedro','Pedro Gomes',NULL,NULL,'2014-05-15 00:11:30'),('whuvq31dx','Sophia','Sophia Gomes',NULL,NULL,'2014-05-15 00:11:30'),('whuvq31xk','Davi','Davi Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('whuvq32bj','Miguel','Miguel Silva',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq30rk','Alice','Alice Gonçalves',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq33q1','Laura','Laura Araújo',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq3440','Sophia','Sophia Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq349l','Beatriz','Beatriz Cardoso',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq36fw','Beatriz','Beatriz Martins',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq3akc','Isabella','Isabella Ribeiro',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq3bf5','Davi','Davi Souza',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq3bnk','Gabriel','Gabriel Morais',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq3cco','Pedro','Pedro Fernandes',NULL,NULL,'2014-05-15 00:11:30'),('xhuvq3elz','Giovanna','Giovanna Almeida',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq30j6','Alice','Alice Pereira',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq30x5','Gabriel','Gabriel Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq32pl','Maria Edua','Maria Eduarda Araújo',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq3a6c','Sophia','Sophia Pereira',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq3b16','Julia','Julia Teixeira',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq3cia','Rafael','Rafael Morais',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq3cnx','Davi','Davi Morais',NULL,NULL,'2014-05-15 00:11:30'),('yhuvq3doe','Lucas','Lucas Rodrigues',NULL,NULL,'2014-05-15 00:11:30'),('zhuvq30zz','Valentina','Valentina Teixeira',NULL,NULL,'2014-05-15 00:11:30'),('zhuvq33su','Pedro','Pedro Ferreira',NULL,NULL,'2014-05-15 00:11:30'),('zhuvq35ny','Lucas','Lucas Silva',NULL,NULL,'2014-05-15 00:11:30'),('zhuvq3ear','Davi','Davi Oliveira',NULL,NULL,'2014-05-15 00:11:30'),('zhuvq3egd','Miguel','Miguel Alves',NULL,NULL,'2014-05-15 00:11:30'),('6irh2g0hua','Acácio','Acácio Neto',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:12:39'),('ahuvq312r','Manuela','Manuela Araújo',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-15 00:19:57'),('6irh2g0hua','Acácio','Acácio Neto','hv7azitd.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-16 21:05:57'),('mhuvq377y','Arthur','Arthur Melo',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-16 23:43:56'),('6irh2g0hua','Acácio','Acácio Neto','hv7azitd.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-17 00:29:37'),('krbnc2n5da','Christian','Christian Amaral','hv6d7zwy.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-17 00:29:37'),('6irh2g0hua','Acácio','Acácio Neto','hv7azitd.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-17 00:29:56'),('krbnc2n5da','Christian','Christian Amaral','hv6d7zwy.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-17 00:33:30'),('dhuvq31p6','Julia','Julia Lima',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-21 16:46:28'),('ghuvq38xi','Alice','Alice Alves',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-21 17:02:05'),('czlkd15v3s','Wagner','Wagner Silva',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-21 19:11:48'),('dhvh0il8k','Fernando','Luis Fernando Vaz Gonçalves',NULL,NULL,'2014-05-21 19:19:20'),('krbnc2n5da','Christian','Christian Amaral','hva6m1lm.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 00:20:59'),('krbnc2n5da','Christian','Christian Amaral','hvk68wx0.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 04:18:56'),('krbnc2n5da','Christian','Christian Amaral','hvkeqx76.jpg','$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 04:19:31'),('ghuvq38xi','Alice','Alice Alves',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 17:40:50'),('ghuvq38xi','Alice','Alice Alves',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 17:41:01'),('ghuvq38xi','Alice','Alice Alves',NULL,'$2a$10$OepYePf0J8VWcxStcB/TO.TOs37VMzcASjd8.YVQWQHu1/5wCBe/e','2014-05-24 17:42:53');
/*!40000 ALTER TABLE `user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_session`
--

DROP TABLE IF EXISTS `user_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_session` (
  `user` varchar(10) NOT NULL,
  `session` varchar(32) NOT NULL,
  PRIMARY KEY (`user`),
  UNIQUE KEY `session` (`session`),
  CONSTRAINT `user_session_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_session`
--

LOCK TABLES `user_session` WRITE;
/*!40000 ALTER TABLE `user_session` DISABLE KEYS */;
INSERT INTO `user_session` VALUES ('krbnc2n5da','Fvy23vDubaEjef3fOjOKwAiN'),('ghuvq38xi','hJWH7g8KQjfCMTAH7WIUyfd9');
/*!40000 ALTER TABLE `user_session` ENABLE KEYS */;
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

--
-- Final view structure for view `active_email`
--

/*!50001 DROP TABLE IF EXISTS `active_email`*/;
/*!50001 DROP VIEW IF EXISTS `active_email`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `active_email` AS select `user_email`.`email` AS `email`,`user`.`full_name` AS `full_name` from ((`active_user` join `user` on((`user`.`id` = `active_user`.`user`))) join `user_email` on((`user_email`.`user` = `active_user`.`user`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-24 20:23:47
