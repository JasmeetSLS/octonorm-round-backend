-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.43 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.15.0.7171
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for octonorm_round
CREATE DATABASE IF NOT EXISTS `octonorm_round` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `octonorm_round`;

-- Dumping structure for table octonorm_round.setup_panel
CREATE TABLE IF NOT EXISTS `setup_panel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `manpower_count` int NOT NULL,
  `role_holder_categories` int NOT NULL,
  `count_per_category` int NOT NULL,
  `preparation_stage` enum('Y','N') DEFAULT 'N',
  `preparation_booths` int DEFAULT '0',
  `preparation_time_per_case` int DEFAULT '0',
  `preparation_rounds` int DEFAULT '0',
  `preparation_autoclose` enum('Y','N') DEFAULT 'N',
  `no_of_evaluations` int NOT NULL,
  `rounds` int NOT NULL,
  `no_of_evaluators` int NOT NULL,
  `evaluator_participant_mapping` enum('Y','N') DEFAULT 'N',
  `time_per_evaluation_round` int DEFAULT '0',
  `reminder` enum('Y','N') DEFAULT 'N',
  `reminder_count` int DEFAULT '0',
  `auto_submit` enum('Y','N') DEFAULT 'N',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
