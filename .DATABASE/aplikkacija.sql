/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP DATABASE IF EXISTS `aplikacija`;
CREATE DATABASE IF NOT EXISTS `aplikacija` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `aplikacija`;

DROP TABLE IF EXISTS `administrator`;
CREATE TABLE IF NOT EXISTS `administrator` (
  `administrator_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `password_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`administrator_id`),
  UNIQUE KEY `uq_administrator_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `administrator`;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` (`administrator_id`, `username`, `password_hash`) VALUES
	(1, 'Mikan', '8F7CD35F1289BB9FADF7D82E8A380E8CB07B73CDFB3C1BD97329C9104C413F61635EF740CDAAFDA4ADBB0F7BD8226FC33B2F1C170D5A43D6EDD00BEC9EED4DCD'),
	(2, 'Micela', '9602A1DBA38E5D32418001B4FECDAC8B4D0F492D8A2C47843071755E917A0F2987D49FB5639B5A3CB4025D7A19D9FCED6FDAE5D52BFBA1F2CC68CEE084B22E73'),
	(3, 'pperic', '0690A3BDCBD8D39B159F6BC990B26CD4F73533634B28759F324301D5B808C5329F0DAFB94A1E66246A7198A5DEC1A3F903B236384703C7F5374D4070B3EF5E23'),
	(7, 'marentija', 'C24F384BC3FF74B797F93E7B6CFE811B7EF28F4EA800591081A3A7FB1AF63F8A71A368D9A80400920D75AF0ED4A974CCC401F7DDF24C426720CB977C463CC3F4'),
	(8, 'admin', '7FCF4BA391C48784EDDE599889D6E3F1E47A27DB36ECC050CC92F259BFAC38AFAD2C68A1AE804D77075E8FB722503F3ECA2B2C1006EE6F6C7B7628CB45FFFD1D');
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;

DROP TABLE IF EXISTS `article`;
CREATE TABLE IF NOT EXISTS `article` (
  `article_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  `excerpt` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('available','visible','hidden') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'available',
  `is_promoted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`article_id`),
  KEY `fk_article_category_id` (`category_id`),
  CONSTRAINT `fk_article_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `article`;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` (`article_id`, `name`, `category_id`, `excerpt`, `description`, `status`, `is_promoted`, `created_at`) VALUES
	(1, 'ACME HDD 512GB', 5, 'Kratak opis', 'Detaljan opis..', 'available', 0, '2021-09-21 20:51:52'),
	(2, 'ACME HD11 1024GB', 5, 'Neki kratak tekst 2...', 'Neki malo duzi tekst o proizvodu 2', 'visible', 1, '2021-10-06 23:31:42'),
	(3, 'HP Premuim X10', 3, 'Laptop sa najboljim performansom', 'Detaljan opis laptop racunara...', 'available', 0, '2022-01-08 21:32:27');
/*!40000 ALTER TABLE `article` ENABLE KEYS */;

DROP TABLE IF EXISTS `article_feature`;
CREATE TABLE IF NOT EXISTS `article_feature` (
  `article_feature_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`article_feature_id`),
  UNIQUE KEY `uq_article_feature_article_id_feature_id` (`article_id`,`feature_id`),
  KEY `fk_article_feature_feature_id` (`feature_id`),
  CONSTRAINT `fk_article_feature_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_article_feature_feature_id` FOREIGN KEY (`feature_id`) REFERENCES `feature` (`feature_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `article_feature`;
/*!40000 ALTER TABLE `article_feature` DISABLE KEYS */;
INSERT INTO `article_feature` (`article_feature_id`, `article_id`, `feature_id`, `value`) VALUES
	(1, 1, 1, '512GB'),
	(2, 1, 2, 'SATA 3.0'),
	(3, 1, 3, 'SSD'),
	(6, 2, 1, '1024GB'),
	(7, 2, 2, 'SATA 3.0'),
	(8, 3, 7, 'HP'),
	(9, 3, 8, '15.6"'),
	(10, 3, 9, 'Bez OS');
/*!40000 ALTER TABLE `article_feature` ENABLE KEYS */;

DROP TABLE IF EXISTS `article_price`;
CREATE TABLE IF NOT EXISTS `article_price` (
  `article_price_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned NOT NULL DEFAULT '0',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`article_price_id`),
  KEY `fk_article_price_article_id` (`article_id`),
  CONSTRAINT `fk_article_price_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `article_price`;
/*!40000 ALTER TABLE `article_price` DISABLE KEYS */;
INSERT INTO `article_price` (`article_price_id`, `article_id`, `price`, `created_at`) VALUES
	(1, 1, 45.00, '2021-09-21 21:32:01'),
	(2, 1, 43.60, '2021-09-21 21:32:20'),
	(3, 2, 56.89, '2021-10-06 23:31:42'),
	(4, 2, 57.11, '2021-11-22 21:21:36'),
	(5, 3, 340.00, '2022-01-15 15:48:03');
/*!40000 ALTER TABLE `article_price` ENABLE KEYS */;

DROP TABLE IF EXISTS `cart`;
CREATE TABLE IF NOT EXISTS `cart` (
  `cart_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `fk_cart_user_id` (`user_id`),
  CONSTRAINT `fk_cart_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `cart`;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` (`cart_id`, `user_id`, `created_at`) VALUES
	(1, 3, '2022-01-08 01:03:50'),
	(2, 3, '2022-01-11 18:22:23'),
	(3, 3, '2022-01-11 18:26:13'),
	(4, 3, '2022-01-11 18:30:41'),
	(5, 4, '2022-01-16 23:21:42'),
	(6, 4, '2022-01-17 23:20:22'),
	(7, 4, '2022-01-17 23:54:49'),
	(8, 4, '2022-01-18 00:11:02'),
	(9, 4, '2022-01-18 16:31:58'),
	(10, 4, '2022-01-18 16:33:18'),
	(11, 4, '2022-01-18 16:43:20'),
	(12, 4, '2022-01-18 17:00:21'),
	(13, 4, '2022-01-18 19:04:37'),
	(14, 4, '2022-01-19 00:32:21'),
	(15, 4, '2022-01-19 18:14:49'),
	(16, 4, '2022-01-19 18:18:27'),
	(17, 4, '2022-01-19 22:23:37'),
	(18, 4, '2022-01-19 22:49:27'),
	(19, 4, '2022-01-19 22:57:33'),
	(20, 4, '2022-01-19 22:59:48'),
	(21, 4, '2022-01-19 23:08:53'),
	(22, 4, '2022-01-19 23:09:55'),
	(23, 4, '2022-01-19 23:14:04'),
	(24, 4, '2022-01-19 23:15:01'),
	(25, 4, '2022-01-19 23:22:57'),
	(26, 4, '2022-01-20 00:02:34'),
	(27, 4, '2022-01-20 00:03:40'),
	(28, 4, '2022-01-20 00:12:25'),
	(29, 4, '2022-01-20 11:11:23'),
	(30, 4, '2022-01-20 11:15:25'),
	(31, 4, '2022-01-20 11:17:03'),
	(32, 4, '2022-01-20 11:21:43'),
	(33, 4, '2022-01-20 11:27:05'),
	(34, 4, '2022-01-20 11:37:01'),
	(35, 4, '2022-01-20 11:38:25'),
	(36, 4, '2022-01-20 11:39:20'),
	(37, 4, '2022-01-20 11:40:17'),
	(38, 4, '2022-01-20 21:56:07'),
	(39, 4, '2022-01-20 22:06:30'),
	(40, 4, '2022-01-20 23:54:10'),
	(41, 4, '2022-01-21 00:08:43'),
	(42, 4, '2022-01-21 00:11:07'),
	(43, 4, '2022-01-21 00:37:37'),
	(44, 4, '2022-01-21 00:40:18'),
	(45, 4, '2022-01-21 01:24:45'),
	(46, 4, '2022-01-21 01:27:29'),
	(47, 4, '2022-01-21 01:28:18'),
	(48, 4, '2022-01-21 01:29:23'),
	(49, 4, '2022-01-21 01:40:11'),
	(50, 4, '2022-01-21 01:42:03'),
	(51, 4, '2022-01-22 16:17:14'),
	(52, 4, '2022-01-22 16:19:02'),
	(53, 4, '2022-01-22 16:20:09'),
	(54, 4, '2022-01-22 16:22:26'),
	(55, 4, '2022-01-22 16:24:08'),
	(56, 4, '2022-01-22 16:25:22'),
	(57, 4, '2022-01-22 16:26:22'),
	(58, 4, '2022-01-22 16:29:24'),
	(59, 4, '2022-01-22 16:40:26'),
	(60, 4, '2022-01-22 16:46:35'),
	(61, 4, '2022-01-22 16:49:04'),
	(62, 4, '2022-01-22 16:50:23'),
	(63, 4, '2022-01-22 16:55:26'),
	(64, 4, '2022-01-22 17:18:30'),
	(65, 4, '2022-01-22 17:24:24'),
	(66, 4, '2022-01-22 17:26:16'),
	(67, 4, '2022-01-22 17:29:04'),
	(68, 4, '2022-01-22 18:45:42'),
	(69, 4, '2022-01-22 18:58:23'),
	(70, 4, '2022-01-22 19:06:17'),
	(71, 4, '2022-01-22 19:10:18'),
	(72, 4, '2022-01-22 19:25:11'),
	(73, 4, '2022-01-22 19:38:06'),
	(74, 8, '2022-01-22 20:06:06'),
	(75, 8, '2022-01-22 20:13:42'),
	(76, 8, '2022-01-22 20:20:44'),
	(77, 8, '2022-01-22 20:27:22'),
	(78, 8, '2022-01-22 20:31:39'),
	(79, 8, '2022-01-22 20:33:05'),
	(80, 8, '2022-01-22 20:36:34'),
	(81, 8, '2022-01-23 00:07:37'),
	(82, 8, '2022-01-23 00:10:59'),
	(83, 8, '2022-01-23 00:13:20'),
	(84, 8, '2022-01-23 00:14:58'),
	(85, 8, '2022-01-23 00:25:25'),
	(86, 8, '2022-01-23 00:32:38'),
	(87, 8, '2022-01-23 00:33:45'),
	(88, 8, '2022-01-23 00:35:07'),
	(89, 8, '2022-01-23 00:41:25'),
	(90, 8, '2022-01-23 00:54:31'),
	(91, 8, '2022-01-23 01:12:24'),
	(92, 8, '2022-01-23 01:22:32'),
	(93, 8, '2022-01-23 17:09:29'),
	(94, 8, '2022-01-23 17:37:15'),
	(95, 8, '2022-01-23 18:14:35'),
	(96, 8, '2022-02-06 02:30:28');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;

DROP TABLE IF EXISTS `cart_article`;
CREATE TABLE IF NOT EXISTS `cart_article` (
  `cart_article_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cart_id` int(10) unsigned NOT NULL DEFAULT '0',
  `article_id` int(10) unsigned NOT NULL DEFAULT '0',
  `quantity` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`cart_article_id`),
  UNIQUE KEY `uq_cart_article_cart_id_article_id` (`cart_id`,`article_id`),
  KEY `fk_cart_article_article` (`article_id`),
  CONSTRAINT `FK_cart_article_cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_article_article` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `cart_article`;
/*!40000 ALTER TABLE `cart_article` DISABLE KEYS */;
INSERT INTO `cart_article` (`cart_article_id`, `cart_id`, `article_id`, `quantity`) VALUES
	(1, 1, 1, 7),
	(3, 1, 2, 1),
	(9, 2, 1, 1),
	(10, 3, 2, 5),
	(11, 4, 1, 4),
	(12, 5, 1, 3),
	(13, 5, 2, 1),
	(14, 6, 2, 1),
	(15, 6, 1, 3),
	(16, 7, 1, 3),
	(17, 7, 3, 1),
	(18, 8, 2, 3),
	(19, 8, 1, 1),
	(20, 9, 1, 1),
	(21, 9, 2, 1),
	(22, 10, 2, 1),
	(23, 10, 1, 1),
	(24, 11, 1, 1),
	(25, 12, 2, 1),
	(26, 13, 2, 1),
	(27, 14, 2, 1),
	(28, 15, 2, 2),
	(29, 15, 1, 3),
	(30, 16, 1, 3),
	(31, 17, 1, 3),
	(32, 18, 1, 3),
	(33, 18, 2, 2),
	(34, 19, 2, 2),
	(35, 20, 2, 2),
	(36, 21, 2, 2),
	(37, 22, 2, 2),
	(38, 23, 1, 3),
	(39, 24, 1, 3),
	(40, 25, 1, 3),
	(41, 26, 1, 3),
	(42, 27, 1, 3),
	(43, 28, 1, 3),
	(44, 29, 1, 3),
	(45, 29, 2, 2),
	(46, 30, 2, 2),
	(47, 30, 1, 2),
	(48, 31, 1, 2),
	(49, 32, 1, 2),
	(50, 32, 2, 2),
	(51, 33, 1, 2),
	(52, 34, 1, 3),
	(53, 35, 1, 3),
	(54, 36, 1, 3),
	(55, 37, 1, 3),
	(56, 38, 1, 3),
	(57, 39, 1, 3),
	(58, 39, 2, 3),
	(59, 40, 2, 3),
	(60, 41, 1, 4),
	(61, 42, 1, 2),
	(62, 43, 3, 2),
	(63, 44, 3, 2),
	(64, 45, 2, 4),
	(65, 46, 2, 4),
	(66, 47, 2, 4),
	(67, 48, 2, 4),
	(68, 49, 2, 4),
	(69, 50, 2, 4),
	(70, 51, 2, 4),
	(71, 52, 2, 4),
	(72, 53, 2, 4),
	(73, 54, 2, 4),
	(74, 55, 2, 4),
	(75, 56, 2, 4),
	(76, 57, 2, 4),
	(77, 58, 2, 4),
	(78, 59, 2, 4),
	(79, 60, 2, 4),
	(80, 61, 2, 4),
	(81, 62, 2, 4),
	(82, 63, 2, 4),
	(83, 64, 2, 4),
	(84, 65, 2, 4),
	(85, 66, 2, 4),
	(86, 67, 2, 4),
	(87, 68, 2, 4),
	(88, 69, 2, 4),
	(89, 70, 2, 4),
	(90, 71, 2, 4),
	(91, 72, 2, 4),
	(92, 73, 2, 4),
	(93, 74, 1, 2),
	(94, 74, 2, 2),
	(95, 75, 2, 2),
	(96, 76, 2, 3),
	(97, 77, 2, 3),
	(98, 78, 3, 1),
	(99, 79, 3, 1),
	(100, 80, 1, 3),
	(101, 81, 1, 2),
	(102, 82, 1, 2),
	(103, 83, 1, 2),
	(104, 84, 1, 2),
	(105, 85, 1, 2),
	(106, 86, 1, 2),
	(107, 87, 1, 2),
	(108, 88, 1, 2),
	(109, 89, 1, 2),
	(110, 90, 1, 2),
	(111, 91, 1, 2),
	(112, 92, 1, 2),
	(113, 93, 1, 2),
	(114, 94, 1, 2),
	(115, 94, 2, 2),
	(116, 95, 1, 1),
	(117, 95, 2, 1);
/*!40000 ALTER TABLE `cart_article` ENABLE KEYS */;

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `image_path` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `parent__category_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uq_category_name` (`name`),
  UNIQUE KEY `uq_category_image_path` (`image_path`),
  KEY `fk_category_parent__category_id` (`parent__category_id`),
  CONSTRAINT `fk_category_parent__category_id` FOREIGN KEY (`parent__category_id`) REFERENCES `category` (`category_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `category`;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`category_id`, `name`, `image_path`, `parent__category_id`) VALUES
	(1, 'Racunarske komponente', 'assets/pc.jpg', NULL),
	(2, 'Kucna elektronika', 'assets/home.jpg', NULL),
	(3, 'Laptop racunari', 'assets/pc/laptop.jpg', 1),
	(4, 'Memorijski mediji', 'assets/pc/memory.jpg', 1),
	(5, 'Hard diskovi', 'assets/pc/memory/hardDisk.jpg', 4);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;

DROP TABLE IF EXISTS `feature`;
CREATE TABLE IF NOT EXISTS `feature` (
  `feature_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `category_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`feature_id`),
  UNIQUE KEY `uq_feature_name_category_id` (`name`,`category_id`),
  KEY `fk_feature_category_id` (`category_id`),
  CONSTRAINT `fk_feature_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `feature`;
/*!40000 ALTER TABLE `feature` DISABLE KEYS */;
INSERT INTO `feature` (`feature_id`, `name`, `category_id`) VALUES
	(8, 'Dijagonala ekrana', 3),
	(1, 'Kapacitet', 5),
	(4, 'Napon', 2),
	(9, 'Operativni sistem', 3),
	(6, 'Proizvodjac', 2),
	(7, 'Proizvodjac', 3),
	(5, 'Snaga', 2),
	(3, 'Tehnologija', 5),
	(2, 'Tip', 5);
/*!40000 ALTER TABLE `feature` ENABLE KEYS */;

DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cart_id` int(10) unsigned NOT NULL,
  `status` enum('rejected','accepted','shipped','pending') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uq_order_cart_id` (`cart_id`),
  CONSTRAINT `fk_order_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `order`;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` (`order_id`, `created_at`, `cart_id`, `status`) VALUES
	(1, '2022-01-11 18:20:42', 1, 'pending'),
	(2, '2022-01-11 18:24:50', 2, 'pending'),
	(3, '2022-01-11 18:30:19', 3, 'pending'),
	(4, '2022-01-16 23:25:14', 5, 'pending'),
	(5, '2022-01-17 23:22:43', 6, 'pending'),
	(6, '2022-01-17 23:57:42', 7, 'pending'),
	(7, '2022-01-18 00:11:47', 8, 'pending'),
	(8, '2022-01-18 16:32:29', 9, 'pending'),
	(9, '2022-01-18 16:33:38', 10, 'pending'),
	(10, '2022-01-18 16:43:40', 11, 'pending'),
	(11, '2022-01-18 17:00:40', 12, 'pending'),
	(12, '2022-01-18 19:04:47', 13, 'pending'),
	(13, '2022-01-19 00:32:49', 14, 'pending'),
	(14, '2022-01-19 18:15:53', 15, 'pending'),
	(15, '2022-01-19 18:18:49', 16, 'pending'),
	(16, '2022-01-19 22:24:01', 17, 'pending'),
	(17, '2022-01-19 22:49:47', 18, 'pending'),
	(18, '2022-01-19 22:57:45', 19, 'pending'),
	(19, '2022-01-19 22:59:57', 20, 'pending'),
	(20, '2022-01-19 23:09:06', 21, 'pending'),
	(21, '2022-01-19 23:10:07', 22, 'pending'),
	(22, '2022-01-19 23:14:22', 23, 'pending'),
	(23, '2022-01-19 23:15:12', 24, 'pending'),
	(24, '2022-01-19 23:23:12', 25, 'pending'),
	(25, '2022-01-20 00:02:45', 26, 'pending'),
	(26, '2022-01-20 00:03:47', 27, 'pending'),
	(27, '2022-01-20 00:12:36', 28, 'pending'),
	(28, '2022-01-20 11:11:49', 29, 'pending'),
	(29, '2022-01-20 11:15:56', 30, 'pending'),
	(30, '2022-01-20 11:17:13', 31, 'pending'),
	(31, '2022-01-20 11:21:59', 32, 'pending'),
	(32, '2022-01-20 11:27:15', 33, 'pending'),
	(33, '2022-01-20 11:37:24', 34, 'pending'),
	(34, '2022-01-20 11:38:41', 35, 'pending'),
	(35, '2022-01-20 11:39:28', 36, 'pending'),
	(36, '2022-01-20 11:40:29', 37, 'pending'),
	(37, '2022-01-20 21:56:32', 38, 'pending'),
	(38, '2022-01-20 22:07:27', 39, 'pending'),
	(39, '2022-01-20 23:54:35', 40, 'pending'),
	(40, '2022-01-21 00:09:00', 41, 'pending'),
	(41, '2022-01-21 00:11:23', 42, 'pending'),
	(42, '2022-01-21 00:37:59', 43, 'pending'),
	(43, '2022-01-21 00:40:29', 44, 'pending'),
	(44, '2022-01-21 01:25:02', 45, 'pending'),
	(45, '2022-01-21 01:27:46', 46, 'pending'),
	(46, '2022-01-21 01:28:30', 47, 'pending'),
	(47, '2022-01-21 01:29:34', 48, 'pending'),
	(48, '2022-01-21 01:40:21', 49, 'pending'),
	(49, '2022-01-21 01:42:12', 50, 'pending'),
	(50, '2022-01-22 16:17:49', 51, 'pending'),
	(51, '2022-01-22 16:19:26', 52, 'pending'),
	(52, '2022-01-22 16:21:40', 53, 'pending'),
	(53, '2022-01-22 16:23:06', 54, 'pending'),
	(54, '2022-01-22 16:24:16', 55, 'pending'),
	(55, '2022-01-22 16:25:31', 56, 'pending'),
	(56, '2022-01-22 16:26:31', 57, 'pending'),
	(57, '2022-01-22 16:29:35', 58, 'pending'),
	(58, '2022-01-22 16:40:41', 59, 'pending'),
	(59, '2022-01-22 16:46:45', 60, 'pending'),
	(60, '2022-01-22 16:49:11', 61, 'pending'),
	(61, '2022-01-22 16:50:34', 62, 'pending'),
	(62, '2022-01-22 16:55:35', 63, 'pending'),
	(63, '2022-01-22 17:18:49', 64, 'pending'),
	(64, '2022-01-22 17:24:37', 65, 'pending'),
	(65, '2022-01-22 17:26:27', 66, 'pending'),
	(66, '2022-01-22 17:29:13', 67, 'pending'),
	(67, '2022-01-22 18:45:52', 68, 'pending'),
	(68, '2022-01-22 18:58:31', 69, 'pending'),
	(69, '2022-01-22 19:06:27', 70, 'pending'),
	(70, '2022-01-22 19:10:27', 71, 'pending'),
	(71, '2022-01-22 19:25:22', 72, 'pending'),
	(72, '2022-01-22 19:38:27', 73, 'pending'),
	(73, '2022-01-22 20:07:11', 74, 'pending'),
	(74, '2022-01-22 20:13:55', 75, 'pending'),
	(75, '2022-01-22 20:20:57', 76, 'pending'),
	(76, '2022-01-22 20:27:39', 77, 'pending'),
	(77, '2022-01-22 20:31:58', 78, 'pending'),
	(78, '2022-01-22 20:33:16', 79, 'pending'),
	(79, '2022-01-22 20:36:52', 80, 'pending'),
	(80, '2022-01-23 00:08:19', 81, 'pending'),
	(81, '2022-01-23 00:11:10', 82, 'pending'),
	(82, '2022-01-23 00:13:31', 83, 'rejected'),
	(83, '2022-01-23 00:15:07', 84, 'pending'),
	(84, '2022-01-23 00:25:36', 85, 'pending'),
	(85, '2022-01-23 00:32:54', 86, 'pending'),
	(86, '2022-01-23 00:33:55', 87, 'pending'),
	(87, '2022-01-23 00:35:23', 88, 'pending'),
	(88, '2022-01-23 00:41:36', 89, 'pending'),
	(89, '2022-01-23 00:54:44', 90, 'pending'),
	(90, '2022-01-23 01:12:34', 91, 'pending'),
	(91, '2022-01-23 01:22:59', 92, 'pending'),
	(92, '2022-01-23 17:09:56', 93, 'pending'),
	(93, '2022-01-23 17:37:43', 94, 'pending'),
	(94, '2022-01-23 18:15:08', 95, 'accepted');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;

DROP TABLE IF EXISTS `photo`;
CREATE TABLE IF NOT EXISTS `photo` (
  `photo_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int(10) unsigned NOT NULL DEFAULT '0',
  `image_path` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`photo_id`),
  UNIQUE KEY `uq_photo_image_path` (`image_path`),
  KEY `fk_photo_article_id` (`article_id`),
  CONSTRAINT `fk_photo_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `photo`;
/*!40000 ALTER TABLE `photo` DISABLE KEYS */;
INSERT INTO `photo` (`photo_id`, `article_id`, `image_path`) VALUES
	(8, 2, '20211014-6475993536-har-disk-slika-2.png'),
	(9, 2, '20211014-10015564978-har-disk-slika-2.png');
/*!40000 ALTER TABLE `photo` ENABLE KEYS */;

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `password_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `forename` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `surname` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `phone_number` varchar(24) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `postal_address` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_user_email` (`email`),
  UNIQUE KEY `uq_user_phone_number` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`user_id`, `email`, `password_hash`, `forename`, `surname`, `phone_number`, `postal_address`) VALUES
	(1, 'perap@gmail.com', '0x45u6fh93jp43', 'Pera', 'Peric', '+38164132654', 'Bulevar Kralja Aleksandra 136, 11000 Beograd'),
	(2, 'mika@gmail', '0xc83049h7g04c', 'Mika', 'Mikic', '+38163222156', 'GospodarJevremova 45, 11000 Beograd'),
	(3, 'test@test.rs', 'DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F', 'Perica', 'Pericic', '+381641234567', 'Nepoznata adresa bb, Glavna luka, Nedodjija'),
	(4, 'maliRadojca@test.rs', 'C70B5DD9EBFB6F51D09D4132B7170C9D20750A7852F00680F65658F0310E810056E6763C34C9A00B0E940076F54495C169FC2302CCEB312039271C43469507DC', 'Antonije', 'Pusic', '+381647654321', 'Kazandzijska bb, Novi Beograd, Beograd'),
	(8, 'vezbacinicovek@gmail.com', '5F70A029A00637134E617C0750131E82CAF263E5913A87771448E9B2A5F2172F15C406787F837C9A1D821F43DE4042E3DD07B03BEB5F60730F509F0831F8F383', 'Antonije', 'Pusic', '+381643421789', 'Nepoznata adresa bb, Glavna luka, Nedodjija');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

DROP TABLE IF EXISTS `user_token`;
CREATE TABLE IF NOT EXISTS `user_token` (
  `user_token_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `token` text COLLATE utf8_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_valid` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_token_id`),
  KEY `fk_user_token_user_id` (`user_id`),
  CONSTRAINT `fk_user_token_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `user_token`;
/*!40000 ALTER TABLE `user_token` DISABLE KEYS */;
INSERT INTO `user_token` (`user_token_id`, `user_id`, `created_at`, `token`, `expires_at`, `is_valid`) VALUES
	(1, 8, '2022-02-05 23:51:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0Njc3OTg3Ni45NjksImlwIjoiOjoxIiwidWEiOiJQb3N0bWFuUnVudGltZS83LjI5LjAiLCJpYXQiOjE2NDQxMDE0NzZ9.1quKcDfuqa-knkY5c3Rbp6vBTkAzdbkWchHam2DYfdQ', '2022-03-08 22:51:16', 0),
	(2, 8, '2022-02-06 02:47:48', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0Njc5MDQ2OC40MzIsImlwIjoiOjoxIiwidWEiOiJQb3N0bWFuUnVudGltZS83LjI5LjAiLCJpYXQiOjE2NDQxMTIwNjh9.mDtVDz84mLSSEF87L-LSTxWjqwk4F21ym6JJ5mHXEwM', '2022-03-09 01:47:48', 1),
	(3, 8, '2022-02-22 23:34:59', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0NzY5OS40NDIsImlwIjoiOjoxIiwidWEiOiJQb3N0bWFuUnVudGltZS83LjI5LjAiLCJpYXQiOjE2NDU1NjkyOTl9.Kxo6TrVJJY51x_MMnU9g_QN_X2mwxKFNvWm6X2kTQ4k', '2022-03-25 22:34:59', 1),
	(4, 8, '2022-02-22 23:38:54', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0NzkzNC4xMzksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NTM0fQ.VQgfT4ssSVtucMfRxRv8h8BcVZ-sg-4O5w4yOBPyEOM', '2022-03-25 22:38:54', 1),
	(5, 8, '2022-02-22 23:39:34', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0Nzk3NC4yNTMsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NTc0fQ.Sk_KP0u7OvUeI_S4kn3hxPAfFJ5paCAiACU0u71e2_0', '2022-03-25 22:39:34', 1),
	(6, 8, '2022-02-22 23:39:37', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0Nzk3Ny45MzUsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NTc3fQ.6Gg-WnyYgg1SXZCYvm4HRrgt902gAR670VdnlIVGpnY', '2022-03-25 22:39:37', 1),
	(7, 8, '2022-02-22 23:39:38', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0Nzk3OC4xNjMsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NTc4fQ.yuFXG16WWZmqYBAoP5S5THf3AOKk_I4hoXFK2uk2Q2A', '2022-03-25 22:39:38', 1),
	(8, 8, '2022-02-22 23:42:07', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEyNy4wMDYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzI3fQ.oxG3rdCU1U07EBzDiZklRcaEqhatGzYf9i12UnufnyE', '2022-03-25 22:42:07', 1),
	(9, 8, '2022-02-22 23:42:15', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNS4zMjQsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM1fQ.c6HehozUY6yoI-7BfgWlJ5scVGfB-4e3d9fBZkwDTk8', '2022-03-25 22:42:15', 1),
	(10, 8, '2022-02-22 23:42:15', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNS42MjEsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM1fQ.g_hbiJjHqfoikBNtyzjZB9bkP8oVv4qVHQkw2-tzjFw', '2022-03-25 22:42:15', 1),
	(11, 8, '2022-02-22 23:42:15', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNS44MjksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM1fQ.Z1dG1zpH5aZyxr02SUGgfP8fyDO3CUSQf_81XjNN3Rs', '2022-03-25 22:42:15', 1),
	(12, 8, '2022-02-22 23:42:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNi4yMjcsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM2fQ.vl7WXYlPAeucRidxJiDlHsNMJKnsL9wxzxmxB-EjN2c', '2022-03-25 22:42:16', 1),
	(13, 8, '2022-02-22 23:42:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNi40MTIsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM2fQ.a61zOH9MITOqaOvVa9hlXT72lSjorNMnq1-XG3k1l8g', '2022-03-25 22:42:16', 1),
	(14, 8, '2022-02-22 23:42:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNi42MDQsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM2fQ.4nPXcTD0HD6eR6pii1paM1C-jl71PMvCU8a1LCa9DVs', '2022-03-25 22:42:16', 1),
	(15, 8, '2022-02-22 23:42:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNi45NDUsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM2fQ.0XXYIRyuXaxs4vVrHdR7yP_AsFByo2LpruYATXnFhXk', '2022-03-25 22:42:16', 1),
	(16, 8, '2022-02-22 23:42:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNy4xMiwiaXAiOiI6OjEiLCJ1YSI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTAyIFNhZmFyaS81MzcuMzYiLCJpYXQiOjE2NDU1Njk3Mzd9.s_L1bhm7lgSh68LfbdIY4qwcIvCC-HyrsDSi817y4cA', '2022-03-25 22:42:17', 1),
	(17, 8, '2022-02-22 23:42:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNy4yODMsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM3fQ.6Nbb095P0S9TVeWLuUxG3cyppvN9h0eNy4uNZL0BUOo', '2022-03-25 22:42:17', 1),
	(18, 8, '2022-02-22 23:42:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNy40NSwiaXAiOiI6OjEiLCJ1YSI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTAyIFNhZmFyaS81MzcuMzYiLCJpYXQiOjE2NDU1Njk3Mzd9.hya_6nG72AzRA2ih5Raoc8lPJCIJZcRRd7pjZ-2nMzM', '2022-03-25 22:42:17', 1),
	(19, 8, '2022-02-22 23:42:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNy42MTksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM3fQ.9122HLtidFH5Yt3KkLfeak1S6cStccMUmrBgGySNHOM', '2022-03-25 22:42:17', 1),
	(20, 8, '2022-02-22 23:42:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNy43OTYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM3fQ.gi75ppk4Y6FRsTJnLLLu0lS5ixG4zLlW6xfAjhlcKWk', '2022-03-25 22:42:17', 1),
	(21, 8, '2022-02-22 23:42:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzNy45NjUsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM3fQ.CIZCVITp5wSQ8sHmv7eGTxyR5iF8WQzGHjhrNB0FWmM', '2022-03-25 22:42:17', 1),
	(22, 8, '2022-02-22 23:42:18', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzOC4xNTcsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM4fQ.gYYLtMCXT9M-NAsay4TIQxaxnVQuZ4vSYuzbjUyLN-k', '2022-03-25 22:42:18', 1),
	(23, 8, '2022-02-22 23:42:18', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzOC41MDQsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM4fQ.auv_umIDUSVuu1cIPcRUdkQtQGw8mRu5XhYrao5Ucao', '2022-03-25 22:42:18', 1),
	(24, 8, '2022-02-22 23:42:18', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzOC44NjUsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM4fQ.bX9lbjSQOJbkgvosF8ripUf0hJ_iDpstSPqclG6tflg', '2022-03-25 22:42:18', 1),
	(25, 8, '2022-02-22 23:42:19', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzOS4xODgsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM5fQ.Rxu8vnAXzkHL_hvLOSO-Naz1I1nhSgxIeBkXHk1as-s', '2022-03-25 22:42:19', 1),
	(26, 8, '2022-02-22 23:42:19', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODEzOS4zNTgsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5NzM5fQ.UsOrs3-orh3MgW6FW2HKC0uwAFCFmnECBZLNOM1I6VM', '2022-03-25 22:42:19', 1),
	(27, 8, '2022-02-22 23:45:55', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODM1NS45NjYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5OTU1fQ.UycRiomwoNKSk7D79UqWiZmEauS1cuvhZTR_aZVJZD8', '2022-03-25 22:45:55', 1),
	(28, 8, '2022-02-22 23:46:08', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODM2OC4wMDksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5OTY4fQ.cH60lsj84kHrxL3c5FrTgb9dhnLz60CtjVU2L-R1NRQ', '2022-03-25 22:46:08', 1),
	(29, 8, '2022-02-22 23:46:12', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODM3Mi42NTgsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTY5OTcyfQ.25lAPgFneuMNDIkQ03hz1cIjiZmzXJhhCK95qayXPMI', '2022-03-25 22:46:12', 1),
	(30, 8, '2022-02-22 23:50:33', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODYzMy43NzcsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwMjMzfQ.bn-IB4_e5zyQnP9rLTaAUkxqTasR8vaF954dGlfa_t0', '2022-03-25 22:50:33', 1),
	(31, 8, '2022-02-22 23:51:15', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODY3NS42MTUsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwMjc1fQ.3iOtC8eReZuGp4UPk0X2Qrsz3IfFCAXXC1abQMNh2vs', '2022-03-25 22:51:15', 1),
	(32, 8, '2022-02-22 23:51:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODY3Ny41NDEsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwMjc3fQ.q3GlKNyat--LVqLirdOUOHewoVF6Y33u3Dy7WTRGEME', '2022-03-25 22:51:17', 1),
	(33, 8, '2022-02-22 23:56:04', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0ODk2NC40MTcsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwNTY0fQ.98HVGCzp7ciqTUAqh806UCfa3mCR4txSVhGTgHr-fco', '2022-03-25 22:56:04', 1),
	(34, 8, '2022-02-22 23:58:15', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTA5NS41NjEsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwNjk1fQ.4V6ML1BQnQhla0TPhF9krLt9xBAdt288DKFltJKx16k', '2022-03-25 22:58:15', 1),
	(35, 8, '2022-02-22 23:58:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTA5Ni41OCwiaXAiOiI6OjEiLCJ1YSI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTAyIFNhZmFyaS81MzcuMzYiLCJpYXQiOjE2NDU1NzA2OTZ9.oVVn6WHYysFYVo5UYVMWQWUEjCJ1wF99S3EOPdn7inE', '2022-03-25 22:58:16', 1),
	(36, 8, '2022-02-22 23:58:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTA5Ny4yODYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwNjk3fQ.mo_sQN-LI_ihtddQPD-Vr7bGO-ZI-RvK_mlSXmwp824', '2022-03-25 22:58:17', 1),
	(37, 8, '2022-02-23 00:01:48', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTMwOC41NjYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwOTA4fQ.MWz8QCFU5Izab0R010AVuTOiCjerB2FNmdvJC6gwM0I', '2022-03-25 23:01:48', 1),
	(38, 8, '2022-02-23 00:02:04', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTMyNC40MzgsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwOTI0fQ.s6kOpOs57Mc_jD59YuuuksFzVOQVrlC2iqLqxfAREtE', '2022-03-25 23:02:04', 1),
	(39, 8, '2022-02-23 00:02:11', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTMzMS44NzYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcwOTMxfQ.rinReATNW981kXmQj7CgXj_wXMrmIyFoVUXIXPKJypU', '2022-03-25 23:02:11', 1),
	(40, 8, '2022-02-23 00:04:37', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI0OTQ3Ny44LCJpcCI6Ijo6MSIsInVhIjoiTW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzk4LjAuNDc1OC4xMDIgU2FmYXJpLzUzNy4zNiIsImlhdCI6MTY0NTU3MTA3N30.w8Me16O7iqN-szppCkYJuCYAUaeXk0GZcQ0q4YSWOKo', '2022-03-25 23:04:37', 1),
	(41, 8, '2022-02-23 00:20:03', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MDQwMy4zNjIsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcyMDAzfQ.cHa_6qZmiAsjtUO63PJfLlUwVTN_aPMtGW9YYBWqrl4', '2022-03-25 23:20:03', 1),
	(42, 8, '2022-02-23 00:20:38', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MDQzOC45MTYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcyMDM4fQ.1MHYt3gR8TpePjT5aRNGfaZxBHRjVuM-VZXGK9sGono', '2022-03-25 23:20:38', 1),
	(43, 8, '2022-02-23 00:21:40', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MDUwMC45MSwiaXAiOiI6OjEiLCJ1YSI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTAyIFNhZmFyaS81MzcuMzYiLCJpYXQiOjE2NDU1NzIxMDB9.nB7ntq8temh53oeav-0WuEYelgdD9n6tCCUK9o9leaM', '2022-03-25 23:21:40', 1),
	(44, 8, '2022-02-23 00:21:58', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MDUxOC4zNTEsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcyMTE4fQ.qvnoWLYrH3xY12H3w6Fw-OSchAZdy_pdBLx_VKJmeo0', '2022-03-25 23:21:58', 1),
	(45, 8, '2022-02-23 00:28:41', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MDkyMS42NDcsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcyNTIxfQ.Hx8gQIamdR92sDt0lRz224caVab-iue00PhvGAysIkY', '2022-03-25 23:28:41', 1),
	(46, 8, '2022-02-23 00:29:17', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MDk1Ny4xMzUsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcyNTU3fQ.Tgrf-alpInqQ_Ps5SQWc07PlqWWZCgiGB-eHrdiNXiA', '2022-03-25 23:29:17', 1),
	(47, 8, '2022-02-23 00:31:16', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MTA3Ni4xNjksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTcyNjc2fQ.XBs4-nsT9udfEI5aO-c3zat342dQGLTb-dKuhzyvfSk', '2022-03-25 23:31:16', 1),
	(48, 8, '2022-02-23 00:39:19', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MTU1OS4zMTQsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTczMTU5fQ.AJ1mFA5okMcUcC5KFo_fkbcOaumWzas0Nx9vm-Joww4', '2022-03-25 23:39:19', 1),
	(49, 8, '2022-02-23 00:41:05', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MTY2NS4yNDYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTczMjY1fQ.4GSOdtass7qZFRB2hRqEDy035IAoJZVceNwR_VkWo9s', '2022-03-25 23:41:05', 1),
	(50, 8, '2022-02-23 00:41:51', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MTcxMS42MjgsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTczMzExfQ.dCGYc4nRK_dNVAjjvegkf89s1qom3WLilposLML_Y5E', '2022-03-25 23:41:51', 1),
	(51, 8, '2022-02-23 00:42:13', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODI1MTczMy40ODksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NTczMzMzfQ.Ka3Y_f7tyCfQZVfUDMUYSLr2Cvc40-1h0sWZvnWb8fw', '2022-03-25 23:42:13', 1),
	(52, 8, '2022-02-24 18:20:05', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwMTYwNS42MiwiaXAiOiI6OjEiLCJ1YSI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTAyIFNhZmFyaS81MzcuMzYiLCJpYXQiOjE2NDU3MjMyMDV9.qR6-aBKL45DjjaOJSE9ZVQ5ygv9abZWTBNF20uCNa4M', '2022-03-27 17:20:05', 1),
	(53, 8, '2022-02-24 18:20:26', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwMTYyNi41NDQsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzIzMjI2fQ.rYojLHW8C8DVWyefFGUkMGMgPKlqT8hXxdpmbKQTmbc', '2022-03-27 17:20:26', 1),
	(54, 8, '2022-02-24 18:34:12', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwMjQ1Mi41NTQsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzI0MDUyfQ.fOJ09mdrM5sD59szpVO5IY3G8ojfBtUAkgvis6egUEc', '2022-03-27 17:34:12', 1),
	(55, 8, '2022-02-24 18:35:11', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwMjUxMS44OTgsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzI0MTExfQ.s0YQAjzxh9gd6s17L8_CMK9-F3DrDbon2BsI-2voYOU', '2022-03-27 17:35:11', 1),
	(56, 8, '2022-02-24 18:50:09', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwMzQwOS40MywiaXAiOiI6OjEiLCJ1YSI6Ik1vemlsbGEvNS4wIChXaW5kb3dzIE5UIDEwLjA7IFdpbjY0OyB4NjQpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIENocm9tZS85OC4wLjQ3NTguMTAyIFNhZmFyaS81MzcuMzYiLCJpYXQiOjE2NDU3MjUwMDl9.xk26Jb-PUOsnBzfLYl0p5NbGtcbm1hNerWXG4Z4Sq_Y', '2022-03-27 17:50:09', 1),
	(57, 8, '2022-02-24 18:50:47', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwMzQ0Ny44MjYsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzI1MDQ3fQ.CWg09sslLe3L7OpK18_t-aatjLm1vMqPsZebb9QOUjY', '2022-03-27 17:50:47', 1),
	(58, 8, '2022-02-24 19:21:23', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwNTI4My41MjIsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzI2ODgzfQ.-WvhxYuw4_BMOf9Q5kkhHjJic2VGb0I4oMRbAMtqQk8', '2022-03-27 18:21:23', 1),
	(59, 8, '2022-02-24 19:43:49', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwNjYyOS42MTcsImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzI4MjI5fQ.NJpoomHSxFvVoA4UlTHa0Wv01A8Iy59FXh-fek2ITNw', '2022-03-27 18:43:49', 1),
	(60, 8, '2022-02-24 19:45:07', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjo4LCJpZGVudGl0eSI6InZlemJhY2luaWNvdmVrQGdtYWlsLmNvbSIsImV4cCI6MTY0ODQwNjcwNy42NzksImlwIjoiOjoxIiwidWEiOiJNb3ppbGxhLzUuMCAoV2luZG93cyBOVCAxMC4wOyBXaW42NDsgeDY0KSBBcHBsZVdlYktpdC81MzcuMzYgKEtIVE1MLCBsaWtlIEdlY2tvKSBDaHJvbWUvOTguMC40NzU4LjEwMiBTYWZhcmkvNTM3LjM2IiwiaWF0IjoxNjQ1NzI4MzA3fQ.Sx_caaGa_oPdYZ4r0vYVddXNm11KkR1CZIEt4pipOyM', '2022-03-27 18:45:07', 1);
/*!40000 ALTER TABLE `user_token` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
