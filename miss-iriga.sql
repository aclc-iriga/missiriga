-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2024 at 11:51 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `miss-iriga`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active_portion` varchar(255) DEFAULT NULL,
  `called_at` timestamp NULL DEFAULT NULL,
  `pinged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `number`, `name`, `avatar`, `username`, `password`, `active_portion`, `called_at`, `pinged_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'DEVELOPMENT', 'no-avatar.jpg', 'admin', 'admin', NULL, NULL, NULL, '2023-02-19 07:36:32', '2023-05-28 03:58:25');

-- --------------------------------------------------------

--
-- Table structure for table `arrangements`
--

CREATE TABLE `arrangements` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `order` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `competition_id` tinyint(3) UNSIGNED NOT NULL,
  `slug` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `competition_id`, `slug`, `title`, `created_at`, `updated_at`) VALUES
(1, 1, 'pageant-night', 'Pageant Night', '2023-04-06 13:25:10', '2023-04-06 13:25:10');

-- --------------------------------------------------------

--
-- Table structure for table `competitions`
--

CREATE TABLE `competitions` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `slug` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competitions`
--

INSERT INTO `competitions` (`id`, `slug`, `title`, `created_at`, `updated_at`) VALUES
(1, 'miss-iriga-2024', 'Miss Iriga 2024', '2023-04-06 13:24:04', '2024-06-10 21:23:20');

-- --------------------------------------------------------

--
-- Table structure for table `criteria`
--

CREATE TABLE `criteria` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `percentage` float UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `criteria`
--

INSERT INTO `criteria` (`id`, `event_id`, `title`, `percentage`, `created_at`, `updated_at`) VALUES
(1, 1, 'Beauty ', 40, '2024-06-10 21:37:30', '2024-06-10 21:37:30'),
(2, 1, 'Intelligence', 40, '2024-06-10 21:37:42', '2024-06-10 21:37:42'),
(3, 1, 'Over-all Impression', 20, '2024-06-10 21:37:57', '2024-06-10 21:37:57');

-- --------------------------------------------------------

--
-- Table structure for table `deductions`
--

CREATE TABLE `deductions` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `technical_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `value` float UNSIGNED NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `eliminations`
--

CREATE TABLE `eliminations` (
  `id` mediumint(9) NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `category_id` tinyint(3) UNSIGNED NOT NULL,
  `slug` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `category_id`, `slug`, `title`, `created_at`, `updated_at`) VALUES
(1, 1, 'final-qa', 'Final Q&A', '2024-06-10 21:33:57', '2024-06-10 21:37:07');

-- --------------------------------------------------------

--
-- Table structure for table `judges`
--

CREATE TABLE `judges` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active_portion` varchar(255) DEFAULT NULL,
  `called_at` timestamp NULL DEFAULT NULL,
  `pinged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `judges`
--

INSERT INTO `judges` (`id`, `number`, `name`, `avatar`, `username`, `password`, `active_portion`, `called_at`, `pinged_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Judge 01', 'no-avatar.jpg', 'judge01', 'judge01', NULL, NULL, NULL, '2023-04-06 13:58:11', '2023-04-06 13:58:11'),
(2, 2, 'Judge 02', 'no-avatar.jpg', 'judge02', 'judge02', NULL, NULL, NULL, '2023-04-06 13:58:28', '2023-04-06 13:58:28'),
(3, 3, 'Judge 03', 'no-avatar.jpg', 'judge03', 'judge03', NULL, NULL, NULL, '2023-04-06 13:58:42', '2023-04-06 13:58:42'),
(4, 4, 'Judge 04', 'no-avatar.jpg', 'judge04', 'judge04', NULL, NULL, NULL, '2023-04-06 13:59:26', '2023-04-06 13:59:26'),
(5, 5, 'Judge 05', 'no-avatar.jpg', 'judge05', 'judge05', NULL, NULL, NULL, '2023-04-06 14:00:00', '2023-04-06 14:00:00'),
(6, 7, 'Judge 06', 'no-avatar.jpg', 'judge06', 'judge06', NULL, NULL, NULL, '2024-06-10 21:38:33', '2024-06-10 21:38:33'),
(7, 7, 'Judge 07', 'no-avatar.jpg', 'judge07', 'judge07', NULL, NULL, NULL, '2024-06-10 21:38:50', '2024-06-10 21:38:50');

-- --------------------------------------------------------

--
-- Table structure for table `judge_event`
--

CREATE TABLE `judge_event` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `judge_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `is_chairman` tinyint(1) NOT NULL DEFAULT 0,
  `active_team_id` tinyint(3) UNSIGNED NOT NULL,
  `has_active_team` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `judge_event`
--

INSERT INTO `judge_event` (`id`, `judge_id`, `event_id`, `is_chairman`, `active_team_id`, `has_active_team`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 0, 1, 0, '2024-06-10 21:39:11', '2024-06-10 21:50:51'),
(2, 2, 1, 0, 1, 0, '2024-06-10 21:39:17', '2024-06-10 21:50:53'),
(3, 3, 1, 0, 1, 0, '2024-06-10 21:39:22', '2024-06-10 21:50:54'),
(4, 4, 1, 0, 1, 0, '2024-06-10 21:39:28', '2024-06-10 21:50:56'),
(5, 5, 1, 0, 1, 0, '2024-06-10 21:39:36', '2024-06-10 21:50:58'),
(6, 6, 1, 0, 1, 0, '2024-06-10 21:39:41', '2024-06-10 21:51:00'),
(7, 7, 1, 0, 1, 0, '2024-06-10 21:39:47', '2024-06-10 21:51:04');

-- --------------------------------------------------------

--
-- Table structure for table `noshows`
--

CREATE TABLE `noshows` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `participants`
--

CREATE TABLE `participants` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `number` smallint(5) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `points`
--

CREATE TABLE `points` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `rank` tinyint(3) UNSIGNED NOT NULL,
  `value` float UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `judge_id` tinyint(3) UNSIGNED NOT NULL,
  `criteria_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `value` float UNSIGNED NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(4) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `location` varchar(32) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `competing_for` enum('Miss Rinconada','Miss Iriga','Miss Bicol Tourism') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `number`, `name`, `location`, `avatar`, `competing_for`, `created_at`, `updated_at`) VALUES
(1, 1, 'Janna Eloisa Lanuzga', 'Nabua, Camarines Sur', 'no-avatar.jpg', 'Miss Rinconada', '2024-06-10 21:26:11', '2024-06-10 21:26:11'),
(2, 2, 'Jodelyn Mendoza', 'Nabua, Camarines Sur', 'no-avatar.jpg', 'Miss Rinconada', '2024-06-10 21:26:31', '2024-06-10 21:26:31'),
(3, 3, 'Maria Shelley Sabularse', 'Baao, Camarines Sur', 'no-avatar.jpg', 'Miss Rinconada', '2024-06-10 21:26:54', '2024-06-10 21:26:54'),
(4, 4, 'Mary Claire Chavez', 'Buhi, Camarines Sur', 'no-avatar.jpg', 'Miss Rinconada', '2024-06-10 21:27:15', '2024-06-10 21:27:15'),
(5, 5, 'Nicole Joycean Peñaserada', 'Buhi, Camarines Sur', 'no-avatar.jpg', 'Miss Rinconada', '2024-06-10 21:28:09', '2024-06-10 21:28:09'),
(6, 6, 'Lauriane Magistrado', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:28:33', '2024-06-10 21:48:17'),
(7, 7, 'Jessabel Bearis', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:28:50', '2024-06-10 21:48:22'),
(8, 8, 'Lisa Mae General', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:29:05', '2024-06-10 21:48:26'),
(9, 9, 'Bettina Pauline Francia', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:29:23', '2024-06-10 21:48:31'),
(10, 10, 'Katrina Claudia Jamin', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:29:41', '2024-06-10 21:48:39'),
(11, 11, 'Sherrie Mae Romaraog', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:29:58', '2024-06-10 21:48:35'),
(12, 12, 'Mary Dine Monge', 'Iriga City', 'no-avatar.jpg', 'Miss Iriga', '2024-06-10 21:30:15', '2024-06-10 21:48:43'),
(13, 13, 'Angelica Maximo', 'Polangui, Albay', 'no-avatar.jpg', 'Miss Bicol Tourism', '2024-06-10 21:30:34', '2024-06-10 21:48:48'),
(14, 14, 'Cherry Love Jebulan', 'Sto. Domingo, Albay', 'no-avatar.jpg', 'Miss Bicol Tourism', '2024-06-10 21:30:58', '2024-06-10 21:48:52'),
(15, 15, 'Dara Sofia Cartujano', 'Naga City, Camarines Sur', 'no-avatar.jpg', 'Miss Bicol Tourism', '2024-06-10 21:31:22', '2024-06-10 21:48:57'),
(16, 16, 'Eaula Marie Balcueva', 'Presentacion, Camarines Sur', 'no-avatar.jpg', 'Miss Bicol Tourism', '2024-06-10 21:32:04', '2024-06-10 21:49:02'),
(17, 17, 'Liezl Anne Iñigo', 'Camaligan, Camarines Sur', 'no-avatar.jpg', 'Miss Bicol Tourism', '2024-06-10 21:32:34', '2024-06-10 21:49:58');

-- --------------------------------------------------------

--
-- Table structure for table `technicals`
--

CREATE TABLE `technicals` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active_portion` varchar(255) DEFAULT NULL,
  `called_at` timestamp NULL DEFAULT NULL,
  `pinged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `technicals`
--

INSERT INTO `technicals` (`id`, `number`, `name`, `avatar`, `username`, `password`, `active_portion`, `called_at`, `pinged_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Technical 01', 'no-avatar.jpg', 'technical01', 'technical01', NULL, NULL, NULL, '2023-02-19 08:58:58', '2023-04-06 14:00:12');

-- --------------------------------------------------------

--
-- Table structure for table `technical_event`
--

CREATE TABLE `technical_event` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `technical_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `active_team_id` tinyint(3) UNSIGNED NOT NULL,
  `has_active_team` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `titles`
--

CREATE TABLE `titles` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `rank` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `arrangements`
--
ALTER TABLE `arrangements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `competition_id` (`competition_id`);

--
-- Indexes for table `competitions`
--
ALTER TABLE `competitions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `criteria`
--
ALTER TABLE `criteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `deductions`
--
ALTER TABLE `deductions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`technical_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `eliminations`
--
ALTER TABLE `eliminations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `area_id` (`category_id`);

--
-- Indexes for table `judges`
--
ALTER TABLE `judges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `judge_event`
--
ALTER TABLE `judge_event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`judge_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `active_team_id` (`active_team_id`);

--
-- Indexes for table `noshows`
--
ALTER TABLE `noshows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `participants`
--
ALTER TABLE `participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `points`
--
ALTER TABLE `points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`judge_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `criteria_id` (`criteria_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `technicals`
--
ALTER TABLE `technicals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `technical_event`
--
ALTER TABLE `technical_event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`technical_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `active_team_id` (`active_team_id`);

--
-- Indexes for table `titles`
--
ALTER TABLE `titles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `arrangements`
--
ALTER TABLE `arrangements`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `competitions`
--
ALTER TABLE `competitions`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `criteria`
--
ALTER TABLE `criteria`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `deductions`
--
ALTER TABLE `deductions`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `eliminations`
--
ALTER TABLE `eliminations`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `judges`
--
ALTER TABLE `judges`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `judge_event`
--
ALTER TABLE `judge_event`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `noshows`
--
ALTER TABLE `noshows`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `participants`
--
ALTER TABLE `participants`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `points`
--
ALTER TABLE `points`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `technicals`
--
ALTER TABLE `technicals`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `technical_event`
--
ALTER TABLE `technical_event`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `titles`
--
ALTER TABLE `titles`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `arrangements`
--
ALTER TABLE `arrangements`
  ADD CONSTRAINT `arrangements_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `arrangements_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `criteria`
--
ALTER TABLE `criteria`
  ADD CONSTRAINT `criteria_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `deductions`
--
ALTER TABLE `deductions`
  ADD CONSTRAINT `deductions_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `deductions_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `deductions_ibfk_3` FOREIGN KEY (`technical_id`) REFERENCES `technicals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eliminations`
--
ALTER TABLE `eliminations`
  ADD CONSTRAINT `eliminations_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `eliminations_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `judge_event`
--
ALTER TABLE `judge_event`
  ADD CONSTRAINT `judge_event_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `judge_event_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `judge_event_ibfk_3` FOREIGN KEY (`active_team_id`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `noshows`
--
ALTER TABLE `noshows`
  ADD CONSTRAINT `noshows_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `noshows_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `participants`
--
ALTER TABLE `participants`
  ADD CONSTRAINT `participants_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `participants_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `points`
--
ALTER TABLE `points`
  ADD CONSTRAINT `points_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`criteria_id`) REFERENCES `criteria` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_3` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `technical_event`
--
ALTER TABLE `technical_event`
  ADD CONSTRAINT `technical_event_ibfk_2` FOREIGN KEY (`technical_id`) REFERENCES `technicals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `technical_event_ibfk_3` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `technical_event_ibfk_4` FOREIGN KEY (`active_team_id`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `titles`
--
ALTER TABLE `titles`
  ADD CONSTRAINT `titles_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
