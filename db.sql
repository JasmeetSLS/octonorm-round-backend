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
CREATE DATABASE IF NOT EXISTS `octonorm_round` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `octonorm_round`;

-- Dumping structure for table octonorm_round.participant_rounds
CREATE TABLE IF NOT EXISTS `participant_rounds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `participant_id` int NOT NULL,
  `round_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `participant_id` (`participant_id`,`round_id`),
  KEY `round_id` (`round_id`),
  CONSTRAINT `participant_rounds_ibfk_1` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `participant_rounds_ibfk_2` FOREIGN KEY (`round_id`) REFERENCES `rounds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.participant_rounds: ~70 rows (approximately)
INSERT INTO `participant_rounds` (`id`, `participant_id`, `round_id`) VALUES
	(1, 1, 1),
	(2, 2, 1),
	(3, 2, 2),
	(4, 3, 1),
	(5, 3, 2),
	(6, 4, 1),
	(7, 4, 2),
	(8, 5, 1),
	(9, 6, 1),
	(10, 7, 1),
	(11, 8, 1),
	(12, 9, 1),
	(13, 9, 2),
	(14, 10, 1),
	(15, 10, 2),
	(16, 11, 1),
	(17, 12, 1),
	(18, 13, 1),
	(19, 14, 1),
	(20, 14, 2),
	(21, 15, 1),
	(22, 16, 1),
	(23, 17, 1),
	(24, 18, 1),
	(25, 19, 1),
	(26, 19, 2),
	(27, 20, 1),
	(28, 20, 2),
	(29, 21, 1),
	(30, 22, 1),
	(31, 22, 2),
	(32, 23, 1),
	(33, 23, 2),
	(34, 24, 1),
	(35, 24, 2),
	(36, 25, 1),
	(37, 26, 1),
	(38, 27, 1),
	(39, 28, 1),
	(40, 29, 1),
	(41, 29, 2),
	(42, 30, 1),
	(43, 30, 2),
	(44, 31, 1),
	(45, 32, 1),
	(46, 33, 1),
	(47, 33, 2),
	(48, 34, 1),
	(49, 35, 1),
	(50, 36, 1),
	(51, 37, 1),
	(52, 38, 1),
	(53, 39, 1),
	(54, 39, 2),
	(55, 40, 1),
	(56, 40, 2),
	(57, 41, 1),
	(58, 42, 1),
	(59, 43, 1),
	(60, 43, 2),
	(61, 44, 1),
	(62, 44, 2),
	(63, 45, 1),
	(64, 46, 1),
	(65, 47, 1),
	(66, 48, 1),
	(67, 49, 1),
	(68, 49, 2),
	(69, 50, 1),
	(70, 50, 2);

-- Dumping structure for table octonorm_round.participants
CREATE TABLE IF NOT EXISTS `participants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setup_id` int NOT NULL,
  `employee_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_slot_id` int DEFAULT NULL,
  `trainer_id` int DEFAULT NULL,
  `room_id` int DEFAULT NULL,
  `position` int NOT NULL DEFAULT '0',
  `profile_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_stage` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'main',
  PRIMARY KEY (`id`),
  UNIQUE KEY `setup_id` (`setup_id`,`employee_id`),
  KEY `trainer_id` (`trainer_id`),
  KEY `room_id` (`room_id`),
  KEY `time_slot_id` (`time_slot_id`),
  CONSTRAINT `participants_ibfk_1` FOREIGN KEY (`setup_id`) REFERENCES `setup` (`id`) ON DELETE CASCADE,
  CONSTRAINT `participants_ibfk_2` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `participants_ibfk_3` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE SET NULL,
  CONSTRAINT `participants_ibfk_4` FOREIGN KEY (`time_slot_id`) REFERENCES `time_slots` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.participants: ~50 rows (approximately)
INSERT INTO `participants` (`id`, `setup_id`, `employee_id`, `name`, `email`, `role`, `language`, `time_slot_id`, `trainer_id`, `room_id`, `position`, `profile_image`, `current_stage`) VALUES
	(1, 1, '18655', 'Harjot Singh', NULL, 'DSE', 'Tamil', 3, 2, 2, 2, '/uploads/users/1/profile.jpg', 'main'),
	(2, 1, '90226540', 'Anson Daniel', NULL, 'TC', 'Hindi', 3, 3, 3, 2, '/uploads/users/2/profile.jpg', 'main'),
	(3, 1, '503666', 'Athi Raja', NULL, 'HSE', 'Assamese', 4, 3, 3, 3, '/uploads/users/3/profile.jpg', 'main'),
	(4, 1, '503825', 'D Shanker Naik', NULL, 'DFM', 'Gujarati', 5, 4, 4, 4, '/uploads/users/4/profile.jpg', 'main'),
	(5, 1, '503709', 'Sneha', NULL, 'SNE', 'Telugu', 1, 5, 5, 0, '/uploads/users/5/profile.jpg', 'main'),
	(6, 1, '18642', 'Lavanya Sen', NULL, 'PSC', 'Marathi', 1, 6, 6, 0, '/uploads/users/6/profile.jpg', 'main'),
	(7, 1, '503816', 'Mari Prakash', NULL, 'DSE', 'Tamil', 1, 7, 7, 0, '/uploads/users/7/profile.jpg', 'main'),
	(8, 1, '16362', 'Nisha Patel', NULL, 'TC', 'Hindi', 1, 8, 8, 0, '/uploads/users/8/profile.jpg', 'main'),
	(9, 1, '16367', 'Prasanth Josi', NULL, 'HSE', 'Assamese', 1, 9, 9, 0, '/uploads/users/9/profile.jpg', 'main'),
	(10, 1, '90178761', 'Rekha', NULL, 'DFM', 'Gujarati', 2, 10, 10, 1, '/uploads/users/10/profile.jpg', 'main'),
	(11, 1, '90163255', 'Samarth', NULL, 'SNE', 'Marathi', 5, 3, 3, 4, '/uploads/users/11/profile.jpg', 'main'),
	(12, 1, '18349', 'Sravan Reddy', NULL, 'PSC', 'Tamil', 2, 1, 1, 1, '/uploads/users/12/profile.jpg', 'main'),
	(13, 1, '16158', 'Vallabhaneni Kumar', NULL, 'DSE', 'Hindi', 4, 1, 1, 3, '/uploads/users/13/profile.jpg', 'main'),
	(14, 1, '18087', 'Akash B', NULL, 'TC', 'Assamese', 2, 4, 4, 1, '/uploads/users/14/profile.jpg', 'main'),
	(15, 1, '19225', 'Arun K Narayan', NULL, 'HSE', 'Gujarati', 2, 5, 5, 1, '/uploads/users/15/profile.jpg', 'main'),
	(16, 1, '90236226', 'Barath Selvakumar', NULL, 'DFM', 'Telugu', 2, 6, 6, 1, '/uploads/users/16/profile.jpg', 'main'),
	(17, 1, '18247', 'DHANASEALAN L', NULL, 'SNE', 'Marathi', 2, 7, 7, 1, '/uploads/users/17/profile.jpg', 'main'),
	(18, 1, '16401', 'Isha', NULL, 'PSC', 'Tamil', 2, 8, 8, 1, '/uploads/users/18/profile.jpg', 'main'),
	(19, 1, '13961', 'Mahesh Bavirisetti', NULL, 'DSE', 'Hindi', 2, 9, 9, 1, '/uploads/users/19/profile.jpg', 'main'),
	(20, 1, '16245', 'Mohamed Anishkhan', NULL, 'TC', 'Assamese', 3, 10, 10, 2, '/uploads/users/20/profile.jpg', 'main'),
	(21, 1, '14880', 'Avni', NULL, 'HSE', 'Telugu', 2, 2, 2, 1, '/uploads/users/21/profile.jpg', 'main'),
	(22, 1, '10801', 'Prashantha Kumara D K', NULL, 'DFM', 'Marathi', 1, 10, 10, 0, '/uploads/users/22/profile.jpg', 'main'),
	(23, 1, '90185205', 'Pavneet', NULL, 'SNE', 'Tamil', 2, 3, 3, 1, '/uploads/users/23/profile.jpg', 'main'),
	(24, 1, '16638', 'Samiksha Lajurkar', NULL, 'PSC', 'Hindi', 3, 4, 4, 2, '/uploads/users/24/profile.jpg', 'main'),
	(25, 1, '90184106', 'Sridharan K M', NULL, 'DSE', 'Assamese', 3, 5, 5, 2, '/uploads/users/25/profile.jpg', 'main'),
	(26, 1, '90205575', 'Vanshika', NULL, 'TC', 'Gujarati', 3, 6, 6, 2, '/uploads/users/26/profile.jpg', 'main'),
	(27, 1, '90222590', 'Anil', NULL, 'HSE', 'Telugu', 3, 7, 7, 2, '/uploads/users/27/profile.jpg', 'main'),
	(28, 1, '16669', 'Ashita Jain', NULL, 'DFM', 'Marathi', 3, 8, 8, 2, '/uploads/users/28/profile.jpg', 'main'),
	(29, 1, '17656', 'Bhavana Choudhary', NULL, 'SNE', 'Tamil', 3, 9, 9, 2, '/uploads/users/29/profile.jpg', 'main'),
	(30, 1, '503845', 'Dileep', NULL, 'PSC', 'Hindi', 4, 10, 10, 3, '/uploads/users/30/profile.jpg', 'main'),
	(31, 1, '19128', 'Komal', NULL, 'DSE', 'Gujarati', 5, 2, 2, 4, '/uploads/users/31/profile.jpg', 'main'),
	(32, 1, '90176461', 'Manikanta', NULL, 'TC', 'Telugu', 4, 2, 2, 3, '/uploads/users/32/profile.jpg', 'main'),
	(33, 1, '18103', 'Moorthy V', NULL, 'HSE', 'Marathi', 5, 1, 1, 4, '/uploads/users/33/profile.jpg', 'main'),
	(34, 1, '16365', 'Perumandla Vivekananda', NULL, 'DFM', 'Tamil', 1, 2, 2, 0, '/uploads/users/34/profile.jpg', 'main'),
	(35, 1, '16134', 'R Sesha Sai', NULL, 'SNE', 'Hindi', 4, 5, 5, 3, '/uploads/users/35/profile.jpg', 'main'),
	(36, 1, '17347', 'S Rajeshwar Reddy', NULL, 'PSC', 'Assamese', 4, 6, 6, 3, '/uploads/users/36/profile.jpg', 'main'),
	(37, 1, '17256', 'Santosh M', NULL, 'DSE', 'Gujarati', 4, 7, 7, 3, '/uploads/users/37/profile.jpg', 'main'),
	(38, 1, '16091', 'Srikar', NULL, 'TC', 'Telugu', 4, 8, 8, 3, '/uploads/users/38/profile.jpg', 'main'),
	(39, 1, '18929', 'Annapragada Dheeraj', NULL, 'HSE', 'Marathi', 4, 9, 9, 3, '/uploads/users/39/profile.jpg', 'main'),
	(40, 1, '503747', 'Ashker PP', NULL, 'DFM', 'Tamil', 5, 10, 10, 4, '/uploads/users/40/profile.jpg', 'main'),
	(41, 1, '16087', 'Rajvir Singh', NULL, 'SNE', 'Assamese', 1, 1, 1, 0, '/uploads/users/41/profile.jpg', 'main'),
	(42, 1, '16699', 'Gulothungan', NULL, 'PSC', 'Gujarati', 3, 1, 1, 2, '/uploads/users/42/profile.jpg', 'main'),
	(43, 1, 'P015509', 'Kiran P Revankar', NULL, 'DSE', 'Telugu', 1, 3, 3, 0, '/uploads/users/43/profile.jpg', 'main'),
	(44, 1, '90164475', 'Manoj Alandkar', NULL, 'TC', 'Marathi', 1, 4, 4, 0, '/uploads/users/44/profile.jpg', 'main'),
	(45, 1, '90240344', 'Natarajan', NULL, 'HSE', 'Tamil', 5, 5, 5, 4, '/uploads/users/45/profile.jpg', 'main'),
	(46, 1, '90166297', 'Prasad', NULL, 'DFM', 'Hindi', 5, 6, 6, 4, '/uploads/users/46/profile.jpg', 'main'),
	(47, 1, '503821', 'Rakesh', NULL, 'SNE', 'Assamese', 5, 8, 8, 4, '/uploads/users/47/profile.jpg', 'main'),
	(48, 1, '16371', 'Sakshi Dhangekar', NULL, 'PSC', 'Gujarati', 5, 7, 7, 4, '/uploads/users/48/profile.jpg', 'main'),
	(49, 1, '18941', 'Kriti', NULL, 'DSE', 'Telugu', 5, 9, 9, 4, '/uploads/users/49/profile.jpg', 'main'),
	(50, 1, '17436', 'Sudish Pai', NULL, 'TC', 'Marathi', 4, 4, 4, 3, '/uploads/users/50/profile.jpg', 'main');

-- Dumping structure for table octonorm_round.role_permissions
CREATE TABLE IF NOT EXISTS `role_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `stage_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `can_view` tinyint(1) DEFAULT '1',
  `can_move` tinyint(1) DEFAULT '0',
  `can_edit_trainer` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_id` (`role_id`,`stage_key`),
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.role_permissions: ~8 rows (approximately)
INSERT INTO `role_permissions` (`id`, `role_id`, `stage_key`, `can_view`, `can_move`, `can_edit_trainer`) VALUES
	(1, 1, 'main', 1, 1, 1),
	(2, 1, 'holding', 1, 1, 1),
	(3, 1, 'prep', 1, 1, 1),
	(4, 1, 'round_1', 1, 1, 1),
	(5, 1, 'hold_after_round_1', 1, 1, 1),
	(6, 1, 'round_2', 1, 1, 1),
	(7, 1, 'hold_after_round_2', 1, 1, 1),
	(8, 1, 'completed', 1, 1, 1);

-- Dumping structure for table octonorm_round.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.roles: ~4 rows (approximately)
INSERT INTO `roles` (`id`, `name`) VALUES
	(1, 'admin'),
	(2, 'trainer'),
	(3, 'evaluator'),
	(4, 'observer');

-- Dumping structure for table octonorm_round.rooms
CREATE TABLE IF NOT EXISTS `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setup_id` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehicle_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trainer_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setup_id` (`setup_id`,`name`),
  KEY `fk_rooms_trainer` (`trainer_id`),
  CONSTRAINT `fk_rooms_trainer` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`setup_id`) REFERENCES `setup` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.rooms: ~10 rows (approximately)
INSERT INTO `rooms` (`id`, `setup_id`, `name`, `vehicle_name`, `trainer_id`) VALUES
	(1, 1, 'Octonorm 1', NULL, 1),
	(2, 1, 'Octonorm 2', NULL, 2),
	(3, 1, 'Octonorm 3', 'HF Deluxe', 3),
	(4, 1, 'Octonorm 4', 'GlamourX-1', 4),
	(5, 1, 'Octonorm 5', NULL, 5),
	(6, 1, 'Octonorm 6', NULL, 6),
	(7, 1, 'Octonorm 7', NULL, 7),
	(8, 1, 'Octonorm 8', NULL, 8),
	(9, 1, 'Octonorm 9', 'Destini 125-2', 9),
	(10, 1, 'Octonorm 10', 'Xoom 125', 10);

-- Dumping structure for table octonorm_round.rounds
CREATE TABLE IF NOT EXISTS `rounds` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setup_id` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_minutes` int NOT NULL,
  `hold_area` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `setup_id` (`setup_id`,`name`),
  CONSTRAINT `rounds_ibfk_1` FOREIGN KEY (`setup_id`) REFERENCES `setup` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.rounds: ~2 rows (approximately)
INSERT INTO `rounds` (`id`, `setup_id`, `name`, `time_minutes`, `hold_area`) VALUES
	(1, 1, 'Round 1', 10, 1),
	(2, 1, 'Round 2', 15, 1);

-- Dumping structure for table octonorm_round.setup
CREATE TABLE IF NOT EXISTS `setup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hold_area_pre` tinyint(1) DEFAULT '0',
  `preparation_enabled` tinyint(1) DEFAULT '1',
  `preparation_booths` int DEFAULT '5',
  `preparation_time` int DEFAULT '5',
  `auto_close_prep` tinyint(1) DEFAULT '1',
  `hold_area_post` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.setup: ~0 rows (approximately)
INSERT INTO `setup` (`id`, `hold_area_pre`, `preparation_enabled`, `preparation_booths`, `preparation_time`, `auto_close_prep`, `hold_area_post`, `created_at`) VALUES
	(1, 1, 1, 5, 5, 1, 1, '2026-08-14 07:40:09');

-- Dumping structure for table octonorm_round.time_slots
CREATE TABLE IF NOT EXISTS `time_slots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `time` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `time` (`time`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.time_slots: ~8 rows (approximately)
INSERT INTO `time_slots` (`id`, `time`, `created_at`) VALUES
	(1, '09:00', '2026-08-18 08:56:56'),
	(2, '09:30', '2026-08-18 08:56:56'),
	(3, '10:00', '2026-08-18 08:56:56'),
	(4, '10:30', '2026-08-18 08:56:56'),
	(5, '11:00', '2026-08-18 08:56:56'),
	(6, '11:30', '2026-08-18 08:56:56'),
	(7, '12:00', '2026-08-18 08:56:56'),
	(8, '12:30', '2026-08-18 08:56:56');

-- Dumping structure for table octonorm_round.trainers
CREATE TABLE IF NOT EXISTS `trainers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `languages` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.trainers: ~10 rows (approximately)
INSERT INTO `trainers` (`id`, `name`, `email`, `languages`) VALUES
	(1, 'Abhisheks', 'abhisheks@example.com', 'Hindi'),
	(2, 'Pooja Bora', 'pooja.bora@example.com', 'Hindi, English'),
	(3, 'Hitendra', 'hitendra@example.com', 'Hindi'),
	(4, 'Manjira', 'manjira@example.com', 'Hindi, Marathi, Gujarati'),
	(5, 'Amit', 'amit@example.com', 'Hindi, Bengali'),
	(6, 'Sagar', 'sagar@example.com', 'Hindi, Tamil, Kannada'),
	(7, 'Vinendra', 'vinendra@example.com', 'Hindi'),
	(8, 'Balshree', 'balshree@example.com', 'Hindi, Telugu, Urdu'),
	(9, 'Madhu TV', 'madhu.tv@example.com', 'Hindi, Malayalam'),
	(10, 'Mithir', 'mithir@example.com', 'Hindi, Punjabi, Odia');

-- Dumping structure for table octonorm_round.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` int NOT NULL,
  `trainer_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `role_id` (`role_id`),
  KEY `trainer_id` (`trainer_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table octonorm_round.users: ~0 rows (approximately)
INSERT INTO `users` (`id`, `username`, `password_hash`, `role_id`, `trainer_id`, `created_at`) VALUES
	(1, 'admin', '$2b$12$24vr9WK4g3VJRlDslopOBuIU5tsgIVNcfEx4jhgaYrcMszO5wqyzS', 1, NULL, '2026-08-17 09:35:46');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
